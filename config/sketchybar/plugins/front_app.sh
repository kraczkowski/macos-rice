#!/bin/bash
# Shows the name of the focused app.
if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
else
  # When the bar starts there has been no switch yet: ask AeroSpace.
  sketchybar --set "$NAME" label="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"
fi
