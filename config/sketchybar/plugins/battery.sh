#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh" 2>/dev/null

PERCENT=$(pmset -g batt | grep -Eo "[0-9]+%" | head -1 | cut -d% -f1)
CHARGING=$(pmset -g batt | grep -q 'AC Power' && echo yes)

[ -z "$PERCENT" ] && exit 0

# icon shape reflects charge level
case "$PERCENT" in
  100|9[0-9]|8[0-9]) ICON="" ;;
  [67][0-9])         ICON="" ;;
  [45][0-9])         ICON="" ;;
  [23][0-9])         ICON="" ;;
  *)                 ICON="" ;;
esac

# color stays neutral; only alerts when genuinely low
if [ -n "$CHARGING" ]; then
  ICON=""
  COLOR=$TEXT
elif [ "$PERCENT" -le 20 ]; then
  COLOR=$RED
else
  COLOR=$TEXT
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENT}%" label.drawing=on label.color=$TEXT
