#!/bin/bash
# ──────────────────────────────────────────────
# 	NetMenu — Modern Network Manager TUI
# ──────────────────────────────────────────────
# Dependencies: gum, alacritty, nmcli, nmtui


pkill -f "alacritty --class netmenu" && exit 0

alacritty --class netmenu --option font.size=15 -e bash -c '
pad="        "

###--- STYLE ---###
export GUM_CHOOSE_HEADER_FOREGROUND="#FF79C6"
export GUM_CHOOSE_CURSOR_FOREGROUND="#FF79C6"
export GUM_CHOOSE_SELECTED_FOREGROUND="#1E1E2E"
export GUM_CHOOSE_SELECTED_BACKGROUND="#FF79C6"
export GUM_INPUT_PROMPT_FOREGROUND="#8BE9FD"
export GUM_CONFIRM_PROMPT_FOREGROUND="#8BE9FD"
export GUM_CONFIRM_SELECTED_BACKGROUND="#FF79C6"
export GUM_CHOOSE_KEYS_HELP=""

###--- HELPERS ---###
get_status() {
    essid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep "^yes" | cut -d: -f2)
    signal=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep "^yes" | cut -d: -f2)
    if [[ -n "$essid" ]]; then
        if (( signal >= 85 )); then bars="▂▄▆█"; color="#50FA7B"; fi
        if (( signal >= 60 && signal < 85 )); then bars="▂▄▆ "; color="#F1FA8C"; fi
        if (( signal >= 35 && signal < 60 )); then bars="▂▄  "; color="#FFB86C"; fi
        if (( signal < 35 )); then bars="▂   "; color="#FF5555"; fi
        gum style --margin "0 0 0 8" --foreground "$color" "Connected to: $essid   $bars ($signal%)"
    else
        if nmcli -t -f DEVICE,TYPE,STATE dev | grep -q "ethernet:connected"; then
            gum style --margin "0 0 0 8" --foreground "#50FA7B" "󰈀  Connected via Ethernet"
        else
            gum style --margin "0 0 0 8" --foreground "#FF5555" "  Not connected"
        fi
    fi
}

### MAIN ###
while true; do
    clear
    echo
    gum style --margin "0 0 0 8" --foreground "#FF79C6" --bold "  Network Manager  "
    echo
    get_status
    echo
    gum style --margin "0 0 0 8" --foreground "#44475A" "──────────────────────────────────────────────"
    echo

    choice=$(gum choose --cursor "➤" \
        --header "$(printf "${pad}Use ↑ ↓ to navigate • Press [Enter] to select")" \
        --header.foreground="#8BE9FD" \
        "${pad}󱘖    Connect to a network" \
        "${pad}󱖫    Network status"\
        "${pad}󰌾    Configure proxy/VPN" \
        "${pad}    Quit")

    if [[ -z "$choice" ]]; then
      exit 0
    fi

    case "$choice" in
        "${pad}󱘖    Connect to a network")
            clear; nmtui connect ;;
        "${pad}󰌾    Configure proxy/VPNs")
            clear; nmtui ;;
        "${pad}󱖫    Network status")
            clear
            gum style --margin "0 0 0 8" --foreground "#FF79C6" --bold "󰄨 Network Status"
            echo
            nmcli general status | sed "s/^/${pad}/"
            echo
            nmcli device status | sed "s/^/${pad}/"
            echo
            gum confirm --affirmative "Return" "Press Enter to return..." ;;
        "${pad}    Quit")
            exit 0 ;;
    esac
done
'
