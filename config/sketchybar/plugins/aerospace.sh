#!/bin/bash
# Highlights the focused AeroSpace workspace. $1 = this item's workspace id.
source "$HOME/.config/sketchybar/colors.sh" 2>/dev/null

# On startup the event var is empty — fall back to querying AeroSpace
[ -z "$FOCUSED_WORKSPACE" ] && FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" icon.color=$BLUE
else
  sketchybar --set "$NAME" icon.color=$SURFACE
fi
