#!/bin/bash


pkill -f "alacritty --class netmenu" && exit 0

alacritty --class netmenu -e bash -c '
clear
pad="       "

printf "\033[5 q"

### --- Colors --- ###
title="\033[1;95m"       # Sakura pink for title
accent="\033[96m"        # Cyan accent
text="\033[97m"          # White text
dim="\033[90m"           # Dim gray
reset="\033[0m"          # Reset color
warn="\033[91m"          # Red for alerts
ok="\033[92m"            # Green for OK text

### --- Connection Info --- ###
get_connection_info() {
    local essid signal bars
    essid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep "^yes" | cut -d: -f2)
    signal=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep "^yes" | cut -d: -f2)

    if [[ -n "$essid" ]]; then
        # Build signal bars ▂▄▆█ based on signal strength
        if (( signal >= 85 )); then
            bars="▂▄▆█"
        elif (( signal >= 60 )); then
            bars="▂▄▆ "
        elif (( signal >= 35 )); then
            bars="▂▄  "
        elif (( signal >= 15 )); then
            bars="▂   "
        else
            bars="    "
        fi
        printf "%s${accent}Connected to:${reset} ${text}%s${reset}  ${accent}%s${reset}\n" "$pad" "$essid" "$bars"
    else
        if nmcli -t -f DEVICE,TYPE,STATE dev | grep -q "ethernet:connected"; then
            printf "%s${accent}Connected via:${reset} ${ok}Ethernet${reset}\n" "$pad"
        else
            printf "%s${warn}Not connected${reset}\n" "$pad"
        fi
    fi
}

### --- Main menu --- ###
show_menu() {
    clear
    printf "\n${pad}${title}🛰️  Network Manager${reset}\n"
    printf "${pad}${dim}──────────────────────────────────────────────${reset}\n"
    get_connection_info
    printf "${pad}${dim}──────────────────────────────────────────────${reset}\n"
    printf "${pad}${text}[1]${reset} Connect to a Wi-Fi\n"
    printf "${pad}${text}[2]${reset} Show available networks\n"
    printf "${pad}${text}[3]${reset} Manage VPNs\n"
    printf "${pad}${text}[4]${reset} Configure Proxy\n"
    printf "${pad}${text}[5]${reset} Network status\n\n"
    printf "${pad}${dim}Press [q] to quit.${reset}\n\n"
    printf "${pad}${accent}Select an option:${reset} "
}

show_status() {
    clear
    printf "\n${pad}${title}Network Status${reset}\n"
    printf "${pad}${dim}──────────────────────────────────────────────${reset}\n\n"
    nmcli general status | awk -v pad="$pad" "{print pad \$0}"
    echo
    nmcli device status | awk -v pad="$pad" "{print pad \$0}"
    echo
    read -rp "${pad}${accent}Press Enter to return...${reset}" tmp
    show_menu
}

auto_refresh() {
    while sleep 3; do
        # Move cursor below title line, redraw connection section only
        tput cup 2 0
        printf "${pad}${dim}──────────────────────────────────────────────${reset}\n"
        get_connection_info
        printf "${pad}${dim}──────────────────────────────────────────────${reset}\n"
        # move cursor back to input prompt line
        tput cup 13 0
        printf "${pad}${accent}Select an option:${reset} "
    done
}

show_menu
auto_refresh &   # start the refresh loop in background
refresh_pid=$!
trap "kill $refresh_pid 2>/dev/null" EXIT


# --- Main loop ---
while true; do
    read -rp "" key
    case "$key" in
        "1")
            kill "$refresh_pid" 2>/dev/null
            clear
            nmtui connect
            auto_refresh & refresh_pid=$!
            show_menu
            ;;
        "2")
            kill "$refresh_pid" 2>/dev/null
            clear
            nmcli dev wifi list | less
            auto_refresh & refresh_pid=$!
            show_menu
            ;;
        "3"|"4")
            kill "$refresh_pid" 2>/dev/null
            clear
            nmtui
            auto_refresh & refresh_pid=$!
            show_menu
            ;;
        "5")
            kill "$refresh_pid" 2>/dev/null
            show_status
            auto_refresh & refresh_pid=$!
            ;;
        "q"|"Q")
            printf "\n${pad}${dim}Exiting...${reset}\n"
            sleep 0.3
            break
            ;;
        *)
            printf "${pad}${warn}Invalid option.${reset}\n"
            sleep 0.8
            show_menu
            ;;
    esac
done
' &