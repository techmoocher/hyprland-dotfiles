#!/bin/bash

# --- Dynamic Configuration ---
# File where nwg-displays saves the configuration
MONITORS_CONF="$HOME/.config/hypr/monitors.conf"

# Check if the monitors.conf file exists
if [ ! -f "$MONITORS_CONF" ]; then
    echo "Error: $MONITORS_CONF not found. Please run nwg-displays to generate it." >&2
    exit 1
fi

# Parse the monitor names from the file.
# This assumes the first monitor listed is the primary/laptop display.
LAPTOP_DISPLAY=$(grep 'monitor =' "$MONITORS_CONF" | head -n 1 | awk -F, '{print $1}' | awk -F= '{print $2}' | sed 's/ //g')
EXTERNAL_DISPLAY=$(grep 'monitor =' "$MONITORS_CONF" | tail -n 1 | awk -F, '{print $1}' | awk -F= '{print $2}' | sed 's/ //g')

# If only one monitor is detected, LAPTOP_DISPLAY and EXTERNAL_DISPLAY will be the same.
# The script will still work, but "Extend" and "Duplicate" will have the same effect as "Laptop Only".

# --- Fallback (Optional) ---
# If parsing fails, you could uncomment these lines to use default values
# : ${LAPTOP_DISPLAY:="eDP-1"}
# : ${EXTERNAL_DISPLAY:="HDMI-A-1"}

# Set a common resolution for mirroring. Both displays must support it.
MIRROR_RESOLUTION="1920x1080"

# --- Main Logic ---

# Present the user with a menu of options using wofi
chosen=$(printf "Extend\nDuplicate (Mirror)\nExternal Only\nLaptop Only" | wofi --dmenu -p "Select Display Mode")

# Execute a command based on the user's choice
case "$chosen" in
    "Extend")
        hyprctl keyword monitor "$LAPTOP_DISPLAY,preferred,auto,1"
        hyprctl keyword monitor "$EXTERNAL_DISPLAY,preferred,auto,1,rightof,$LAPTOP_DISPLAY"
        ;;
    "Duplicate (Mirror)")
        hyprctl keyword monitor "$LAPTOP_DISPLAY,$MIRROR_RESOLUTION,0x0,1"
        hyprctl keyword monitor "$EXTERNAL_DISPLAY,$MIRROR_RESOLUTION,0x0,1"
        ;;
    "External Only")
        hyprctl keyword monitor "$LAPTOP_DISPLAY,disable"
        hyprctl keyword monitor "$EXTERNAL_DISPLAY,preferred,auto,1"
        ;;
    "Laptop Only")
        hyprctl keyword monitor "$EXTERNAL_DISPLAY,disable"
        hyprctl keyword monitor "$LAPTOP_DISPLAY,preferred,auto,1"
        ;;
    *)
        # If the user cancels (e.g., by pressing Esc), do nothing
        exit 1
        ;;
esac