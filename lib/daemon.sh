#!/bin/bash

##   Zphisher - Daemon Mode
##   Background Execution Support
##   Version: 1.0.0

## Daemon Configuration
DAEMON_PID_FILE="${BASE_DIR}/.daemon.pid"
DAEMON_LOG_FILE="${BASE_DIR}/.daemon.log"
DAEMON_SESSION_NAME="zphisher_daemon"
DAEMON_STATUS="stopped"

## Check if screen/tmux is available
check_screen_support() {
    if command -v screen &>/dev/null; then
        echo "screen"
    elif command -v tmux &>/dev/null; then
        echo "tmux"
    else
        echo "none"
    fi
}

## Start in background using nohup
start_daemon_nohup() {
    local cmd="$1"
    local args="${2:-}"
    
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Starting daemon in background...${WHITE}"
    
    nohup bash -c "$cmd $args" > "$DAEMON_LOG_FILE" 2>&1 &
    local pid=$!
    
    echo "$pid" > "$DAEMON_PID_FILE"
    DAEMON_STATUS="running"
    
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Daemon started with PID: $pid${WHITE}"
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Log file: $DAEMON_LOG_FILE${WHITE}"
}

## Start using screen
start_daemon_screen() {
    local cmd="$1"
    local args="${2:-}"
    
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Starting daemon in screen session...${WHITE}"
    
    screen -dmS "$DAEMON_SESSION_NAME" bash -c "$cmd $args; exec bash"
    
    sleep 1
    local pid=$(screen -ls | grep "$DAEMON_SESSION_NAME" | awk -F. '{print $1}' | awk '{print $1}')
    
    echo "$pid" > "$DAEMON_PID_FILE"
    DAEMON_STATUS="running"
    
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Screen session started: $DAEMON_SESSION_NAME${WHITE}"
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} To attach: screen -r $DAEMON_SESSION_NAME${WHITE}"
}

## Start using tmux
start_daemon_tmux() {
    local cmd="$1"
    local args="${2:-}"
    
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Starting daemon in tmux session...${WHITE}"
    
    tmux new-session -d -s "$DAEMON_SESSION_NAME" "$cmd $args"
    
    sleep 1
    local pid=$(tmux list-panes -s -t "$DAEMON_SESSION_NAME" -F '#{pane_pid}')
    
    echo "$pid" > "$DAEMON_PID_FILE"
    DAEMON_STATUS="running"
    
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Tmux session started: $DAEMON_SESSION_NAME${WHITE}"
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} To attach: tmux attach-session -t $DAEMON_SESSION_NAME${WHITE}"
}

## Start daemon with best available method
start_daemon() {
    local method="${1:-auto}"
    local cmd="$0"
    
    if [[ ! -x "$cmd" ]]; then
        cmd="bash $0"
    fi
    
    case "$method" in
        "screen")
            start_daemon_screen "$cmd"
            ;;
        "tmux")
            start_daemon_tmux "$cmd"
            ;;
        "nohup")
            start_daemon_nohup "$cmd"
            ;;
        "auto"|*)
            local support=$(check_screen_support)
            if [[ "$support" == "screen" ]]; then
                start_daemon_screen "$cmd"
            elif [[ "$support" == "tmux" ]]; then
                start_daemon_tmux "$cmd"
            else
                start_daemon_nohup "$cmd"
            fi
            ;;
    esac
}

## Stop daemon
stop_daemon() {
    if [[ -f "$DAEMON_PID_FILE" ]]; then
        local pid=$(cat "$DAEMON_PID_FILE")
        
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null
            echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Daemon with PID $pid stopped.${WHITE}"
        else
            echo -e "${RED}[${WHITE}!${RED}]${RED} Daemon not running.${WHITE}"
        fi
        
        rm -f "$DAEMON_PID_FILE"
        DAEMON_STATUS="stopped"
    else
        if screen -ls 2>/dev/null | grep -q "$DAEMON_SESSION_NAME"; then
            screen -S "$DAEMON_SESSION_NAME" -X quit
            echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Screen session terminated.${WHITE}"
        fi
        
        if tmux list-sessions 2>/dev/null | grep -q "$DAEMON_SESSION_NAME"; then
            tmux kill-session -t "$DAEMON_SESSION_NAME"
            echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Tmux session terminated.${WHITE}"
        fi
    fi
}

## Restart daemon
restart_daemon() {
    echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Restarting daemon...${WHITE}"
    stop_daemon
    sleep 1
    start_daemon "$1"
}

## Check daemon status
daemon_status() {
    if [[ -f "$DAEMON_PID_FILE" ]]; then
        local pid=$(cat "$DAEMON_PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Daemon is running (PID: $pid)${WHITE}"
            DAEMON_STATUS="running"
            return 0
        fi
    fi
    
    if screen -ls 2>/dev/null | grep -q "$DAEMON_SESSION_NAME"; then
        echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Daemon running in screen session${WHITE}"
        DAEMON_STATUS="running"
        return 0
    fi
    
    if tmux list-sessions 2>/dev/null | grep -q "$DAEMON_SESSION_NAME"; then
        echo -e "${GREEN}[${WHITE}+${GREEN}]${CYAN} Daemon running in tmux session${WHITE}"
        DAEMON_STATUS="running"
        return 0
    fi
    
    echo -e "${RED}[${WHITE}!${RED}]${RED} Daemon is not running.${WHITE}"
    DAEMON_STATUS="stopped"
    return 1
}

## View daemon logs
view_daemon_logs() {
    if [[ -f "$DAEMON_LOG_FILE" ]]; then
        tail -f "$DAEMON_LOG_FILE"
    else
        echo -e "${RED}[${WHITE}!${RED}]${RED} No log file found.${WHITE}"
    fi
}

## Attach to daemon session
attach_daemon() {
    local support=$(check_screen_support)
    
    if [[ "$support" == "screen" ]]; then
        screen -r "$DAEMON_SESSION_NAME"
    elif [[ "$support" == "tmux" ]]; then
        tmux attach-session -t "$DAEMON_SESSION_NAME"
    else
        echo -e "${RED}[${WHITE}!${RED}]${RED} No terminal multiplexer available.${WHITE}"
        echo -e "${CYAN}Install screen or tmux for this feature.${WHITE}"
    fi
}

## Daemon Menu
daemon_menu() {
    { clear; banner_small; echo; }
    
    cat <<- EOF
		${GREEN}[${WHITE}01${RED}]${ORANGE} Start Daemon       ${GREEN}[${WHITE}02${RED}]${ORANGE} Stop Daemon
		${GREEN}[${WHITE}03${RED}]${ORANGE} Restart Daemon    ${GREEN}[${WHITE}04${RED}]${ORANGE} Status
		${GREEN}[${WHITE}05${RED}]${ORANGE} View Logs         ${GREEN}[${WHITE}06${RED}]${ORANGE} Attach Session
		${GREEN}[${WHITE}99${RED}]${ORANGE} Back

	EOF
    
    echo -e "${CYAN}Current Status: ${GREEN}$DAEMON_STATUS${WHITE}\n"
    
    read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"
    
    case $REPLY in
        1)
            read -n1 -p "${RED}[${WHITE}?${RED}]${ORANGE} Choose method (1=screen, 2=tmux, 3=nohup, 4=auto): ${WHITE}" method_opt
            echo
            case $method_opt in
                1) start_daemon "screen" ;;
                2) start_daemon "tmux" ;;
                3) start_daemon "nohup" ;;
                *) start_daemon "auto" ;;
            esac
            sleep 2
            daemon_menu
            ;;
        2)
            stop_daemon
            sleep 1
            daemon_menu
            ;;
        3)
            read -n1 -p "${RED}[${WHITE}?${RED}]${ORANGE} Choose method (1=screen, 2=tmux, 3=nohup, 4=auto): ${WHITE}" method_opt
            echo
            restart_daemon "$method_opt"
            sleep 2
            daemon_menu
            ;;
        4)
            daemon_status
            sleep 2
            daemon_menu
            ;;
        5)
            view_daemon_logs
            ;;
        6)
            attach_daemon
            ;;
        99)
            main_menu
            ;;
        *)
            echo -e "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again...${WHITE}"
            sleep 1
            daemon_menu
            ;;
    esac
}

## Load daemon config
load_daemon_config() {
    if [[ -f "${BASE_DIR}/.daemon_config" ]]; then
        source "${BASE_DIR}/.daemon_config"
    fi
}

## Is daemon running
is_daemon_running() {
    daemon_status &>/dev/null
}
