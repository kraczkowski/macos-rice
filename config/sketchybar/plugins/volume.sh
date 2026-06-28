#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh" 2>/dev/null

VOLUME="$INFO"
[ -z "$VOLUME" ] && VOLUME=$(osascript -e 'output volume of (get volume settings)')

case "$VOLUME" in
  [6-9][0-9]|100) ICON="" ;;
  [3-5][0-9])     ICON="" ;;
  [1-9]|[1-2][0-9]) ICON="" ;;
  *) ICON="" ;;
esac

sketchybar --set "$NAME" icon="$ICON" icon.color=$CYAN label="${VOLUME}%"
