#!/bin/bash

##   Zphisher - Theme System
##   Theme Support for CLI Interface
##   Version: 1.0.0

## Theme Configuration File
THEME_CONFIG="${BASE_DIR}/.theme"

## Default Theme
CURRENT_THEME="default"

## Available Themes
declare -A THEMES
THEMES["default"]="Default Theme"
THEMES["cyberpunk"]="Cyberpunk Neon"
THEMES["matrix"]="Matrix Green"
THEMES["nord"]="Nord Cold"
THEMES["dracula"]="Dracula Dark"
THEMES["sunset"]="Sunset Warm"
THEMES["ocean"]="Ocean Blue"

## Load Theme
load_theme() {
    local theme="${1:-default}"
    
    if [[ -z "${THEMES[$theme]}" ]]; then
        echo -e "${RED}[${WHITE}!${RED}]${RED} Theme '$theme' not found. Using default.${WHITE}"
        theme="default"
    fi
    
    CURRENT_THEME="$theme"
    apply_theme_colors
}

## Apply Theme Colors
apply_theme_colors() {
    case "$CURRENT_THEME" in
        "default")
            RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
            MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
            REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
            MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
            ;;
        "cyberpunk")
            RED="$(printf '\033[38;5;197m')"  GREEN="$(printf '\033[38;5;120m')"  ORANGE="$(printf '\033[38;5;208m')"  BLUE="$(printf '\033[38;5;39m')"
            MAGENTA="$(printf '\033[38;5;197m')"  CYAN="$(printf '\033[38;5;51m')"  WHITE="$(printf '\033[38;5;15m')" BLACK="$(printf '\033[38;5;232m')"
            REDBG="$(printf '\033[48;5;197m')"  GREENBG="$(printf '\033[48;5;120m')"  ORANGEBG="$(printf '\033[48;5;208m')"  BLUEBG="$(printf '\033[48;5;39m')"
            MAGENTABG="$(printf '\033[48;5;197m')"  CYANBG="$(printf '\033[48;5;51m')"  WHITEBG="$(printf '\033[48;5;15m')" BLACKBG="$(printf '\033[48;5;232m')"
            ;;
        "matrix")
            RED="$(printf '\033[38;5;34m')"  GREEN="$(printf '\033[38;5;46m')"  ORANGE="$(printf '\033[38;5;82m')"  BLUE="$(printf '\033[38;5;28m')"
            MAGENTA="$(printf '\033[38;5;34m')"  CYAN="$(printf '\033[38;5;48m')"  WHITE="$(printf '\033[38;5;154m')" BLACK="$(printf '\033[38;5;22m')"
            REDBG="$(printf '\033[48;5;34m')"  GREENBG="$(printf '\033[48;5;46m')"  ORANGEBG="$(printf '\033[48;5;82m')"  BLUEBG="$(printf '\033[48;5;28m')"
            MAGENTABG="$(printf '\033[48;5;34m')"  CYANBG="$(printf '\033[48;5;48m')"  WHITEBG="$(printf '\033[48;5;154m')" BLACKBG="$(printf '\033[48;5;22m')"
            ;;
        "nord")
            RED="$(printf '\033[38;5;210m')"  GREEN="$(printf '\033[38;5;150m')"  ORANGE="$(printf '\033[38;5;180m')"  BLUE="$(printf '\033[38;5;117m')"
            MAGENTA="$(printf '\033[38;5;182m')"  CYAN="$(printf '\033[38;5;153m')"  WHITE="$(printf '\033[38;5;188m')" BLACK="$(printf '\033[38;5;46m')"
            REDBG="$(printf '\033[48;5;210m')"  GREENBG="$(printf '\033[48;5;150m')"  ORANGEBG="$(printf '\033[48;5;180m')"  BLUEBG="$(printf '\033[48;5;117m')"
            MAGENTABG="$(printf '\033[48;5;182m')"  CYANBG="$(printf '\033[48;5;153m')"  WHITEBG="$(printf '\033[48;5;188m')" BLACKBG="$(printf '\033[48;5;46m')"
            ;;
        "dracula")
            RED="$(printf '\033[38;5;189m')"  GREEN="$(printf '\033[38;5;139m')"  ORANGE="$(printf '\033[38;5;209m')"  BLUE="$(printf '\033[38;5;98m')"
            MAGENTA="$(printf '\033[38;5;189m')"  CYAN="$(printf '\033[38;5;117m')"  WHITE="$(printf '\033[38;5;188m')" BLACK="$(printf '\033[38;5;236m')"
            REDBG="$(printf '\033[48;5;189m')"  GREENBG="$(printf '\033[48;5;139m')"  ORANGEBG="$(printf '\033[48;5;209m')"  BLUEBG="$(printf '\033[48;5;98m')"
            MAGENTABG="$(printf '\033[48;5;189m')"  CYANBG="$(printf '\033[48;5;117m')"  WHITEBG="$(printf '\033[48;5;188m')" BLACKBG="$(printf '\033[48;5;236m')"
            ;;
        "sunset")
            RED="$(printf '\033[38;5;203m')"  GREEN="$(printf '\033[38;5;112m')"  ORANGE="$(printf '\033[38;5;214m')"  BLUE="$(printf '\033[38;5;67m')"
            MAGENTA="$(printf '\033[38;5;198m')"  CYAN="$(printf '\033[38;5;116m')"  WHITE="$(printf '\033[38;5;255m')" BLACK="$(printf '\033[38;5;52m')"
            REDBG="$(printf '\033[48;5;203m')"  GREENBG="$(printf '\033[48;5;112m')"  ORANGEBG="$(printf '\033[48;5;214m')"  BLUEBG="$(printf '\033[48;5;67m')"
            MAGENTABG="$(printf '\033[48;5;198m')"  CYANBG="$(printf '\033[48;5;116m')"  WHITEBG="$(printf '\033[48;5;255m')" BLACKBG="$(printf '\033[48;5;52m')"
            ;;
        "ocean")
            RED="$(printf '\033[38;5;196m')"  GREEN="$(printf '\033[38;5;84m')"  ORANGE="$(printf '\033[38;5;166m')"  BLUE="$(printf '\033[38;5;75m')"
            MAGENTA="$(printf '\033[38;5;201m')"  CYAN="$(printf '\033[38;5;74m')"  WHITE="$(printf '\033[38;5;231m')" BLACK="$(printf '\033[38;5;17m')"
            REDBG="$(printf '\033[48;5;196m')"  GREENBG="$(printf '\033[48;5;84m')"  ORANGEBG="$(printf '\033[48;5;166m')"  BLUEBG="$(printf '\033[48;5;75m')"
            MAGENTABG="$(printf '\033[48;5;201m')"  CYANBG="$(printf '\033[48;5;74m')"  WHITEBG="$(printf '\033[48;5;231m')" BLACKBG="$(printf '\033[48;5;17m')"
            ;;
    esac
}

## List Available Themes
list_themes() {
    echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Available Themes:${WHITE}\n"
    local i=1
    for theme in "${!THEMES[@]}"; do
        if [[ "$theme" == "$CURRENT_THEME" ]]; then
            echo -e "  ${GREEN}[${WHITE}$i${GREEN}]${ORANGE} ${THEMES[$theme]} ${GREEN}(active)${WHITE}"
        else
            echo -e "  ${GREEN}[${WHITE}$i${GREEN}]${ORANGE} ${THEMES[$theme]}${WHITE}"
        fi
        ((i++))
    done
    echo -e "\n${GREEN}[${WHITE}99${GREEN}]${ORANGE} Back to Main Menu${WHITE}"
}

## Theme Menu
theme_menu() {
    { clear; banner_small; echo; }
    list_themes
    
    read -p "${RED}[${WHITE}-${RED}]${GREEN} Select a theme : ${BLUE}"
    
    local themes_array=("${!THEMES[@]}")
    local count=${#themes_array[@]}
    
    if [[ $REPLY =~ ^[0-9]+$ ]] && [[ $REPLY -ge 1 && $REPLY -le $count ]]; then
        local selected_theme="${themes_array[$((REPLY-1))]}"
        load_theme "$selected_theme"
        save_theme "$selected_theme"
        echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Theme '${THEMES[$selected_theme]}' applied!${WHITE}"
        sleep 1.5
    elif [[ $REPLY == "99" ]]; then
        main_menu
    else
        echo -e "\n${RED}[${WHITE}!${RED}]${RED} Invalid option, try again...${WHITE}"
        sleep 1
        theme_menu
    fi
}

## Save Theme Preference
save_theme() {
    echo "THEME=$1" > "$THEME_CONFIG"
}

## Load Saved Theme
load_saved_theme() {
    if [[ -f "$THEME_CONFIG" ]]; then
        source "$THEME_CONFIG"
        if [[ -n "$THEME" && -n "${THEMES[$THEME]}" ]]; then
            load_theme "$THEME"
        fi
    fi
}

## Get Current Theme Name
get_current_theme() {
    echo "$CURRENT_THEME"
}
