#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh" 2>/dev/null

SSID=$(ipconfig getsummary en0 2>/dev/null | awk -F ' SSID : ' '/ SSID : / {print $2}')

if [ -z "$SSID" ]; then
  sketchybar --set "$NAME" icon="" icon.color=$RED label="off"
else
  sketchybar --set "$NAME" icon="" icon.color=$CYAN label="$SSID"
fi
