#!/bin/bash

BATTERY=$(pmset -g batt)
PERCENT=$(grep -Eo "[0-9]+%" <<<"$BATTERY" | head -1 | cut -d% -f1)
CHARGING=$(grep -q 'AC Power' <<<"$BATTERY" && echo yes)

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
COLOR=0xff{{text}}
if [ -n "$CHARGING" ]; then
  ICON=""
elif [ "$PERCENT" -le 20 ]; then
  COLOR=0xff{{ember}}
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENT}%" label.drawing=on label.color=0xff{{text}}
