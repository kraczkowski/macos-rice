#!/bin/bash
# Highlights the focused AeroSpace workspace. $1 = this item's workspace id.
source "$HOME/.config/sketchybar/colors.sh" 2>/dev/null

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.color=$BLUE icon.color=$BASE
else
  sketchybar --set "$NAME" background.color=$SURFACE icon.color=$TEXT
fi
