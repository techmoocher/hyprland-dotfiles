#!/bin/bash

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"
SAVED="/var/lib/brightness"

if [ -f "$SAVED" ]; then
    cat "$SAVED" > "$BRIGHTNESS_FILE"
fi
