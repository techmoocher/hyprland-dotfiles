#!/usr/bin/env bash


BAT=$(cat /sys/class/power_supply/*/capacity | head -1)
STATUS=$(cat /sys/class/power_supply/*/status | head -1)

ICON=""
COLOR=""
TEXT=""

if [[ "$STATUS" == "Charging" ]]; then
    ICON=""
    COLOR="#C1E1C1"
elif [[ "$STATUS" == "Plugged" ]]; then
    ICON="󰂄"
    COLOR="#C1E1C1"

else
    if    (( BAT >= 91 )); then ICON="󰁹"
    elif  (( BAT >= 81 )); then ICON="󰂂"
    elif  (( BAT >= 71 )); then ICON="󰂁"
    elif  (( BAT >= 61 )); then ICON="󰂀"
    elif  (( BAT >= 51 )); then ICON="󰁿"
    elif  (( BAT >= 41 )); then ICON="󰁾"
    elif  (( BAT >= 31 )); then ICON="󰁽"
    elif  (( BAT >= 21 )); then ICON="󰁼"
    elif  (( BAT >= 11 )); then ICON="󰁻"
    else  ICON="󰂃"
    fi

    if    (( BAT >= 50 )); then COLOR="#5FAF6E"
    elif  (( BAT >= 30 )); then COLOR="#E3B44A"
    else  COLOR="#C04554"
    fi
fi

case "$STATUS" in
    "Charging")
        TEXT="$BAT% (Charging)"
        ICON=""
        ;;

    "Full")
        TEXT="$BAT% (Full)"
        ;;

    "Not charging")
        TEXT="$BAT% remaining"
        ;;

    "Discharging")
        TEXT="$BAT% remaining"
        ;;

    "Unknown")
        TEXT="$BAT% remaining"
        ;;

    *)
        if grep -qi "ac" <<< "$STATUS"; then
            TEXT="$BAT% (Plugged)"
        else
            TEXT="$BAT% remaining"
        fi
        ;;
esac

echo "<span foreground='$COLOR'>$ICON  $TEXT</span>"
