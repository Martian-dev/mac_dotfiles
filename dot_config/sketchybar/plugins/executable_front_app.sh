#!/bin/bash
app=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)
bundle=$(aerospace list-windows --focused --format '%{app-bundle-id}' 2>/dev/null)
[ "$SENDER" = front_app_switched ] && app="$INFO"
args=(--set "$NAME" "label=${app:-Desktop}")
image="$HOME/.cache/sketchybar/app-$bundle.png"
if [ -n "$bundle" ]; then
  [ -f "$image" ] || "$HOME/.cache/sketchybar/render" app "$bundle" "$image" 2>/dev/null
fi
if [ -n "$bundle" ] && [ -f "$image" ]; then
  args+=(--set front_app.icon drawing=on "background.image=$image")
else
  args+=(--set front_app.icon drawing=off)
fi
sketchybar "${args[@]}"
