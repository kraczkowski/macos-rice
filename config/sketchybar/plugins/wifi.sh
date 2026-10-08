#!/bin/bash

SSID=$(ipconfig getsummary en0 2>/dev/null | awk -F ' SSID : ' '/ SSID : / {print $2}')

if [ -z "$SSID" ]; then
  sketchybar --set "$NAME" icon="" icon.color=0xff{{ember}}
else
  sketchybar --set "$NAME" icon="" icon.color=0xff{{linen}}
fi
