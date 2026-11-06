#!/bin/bash
if [ "$SENDER" = front_app_switched ]; then
  sketchybar --set "$NAME" label="$INFO"
else
  app=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)
  sketchybar --set "$NAME" label="${app:-Desktop}"
fi
