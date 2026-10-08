#!/bin/bash

VOLUME="$INFO"
[ -z "$VOLUME" ] && VOLUME=$(osascript -e 'output volume of (get volume settings)')

case "$VOLUME" in
  [6-9][0-9]|100)   ICON="" ;;
  [1-9]|[1-5][0-9]) ICON="" ;;
  *)                ICON="" ;;
esac

sketchybar --set "$NAME" icon="$ICON"
