#!/bin/bash
cache_dir="$HOME/.cache/sketchybar"
battery=$(pmset -g batt)
percent=$(printf '%s\n' "$battery" | sed -n 's/.*[[:space:]]\([0-9][0-9]*\)%.*/\1/p' | head -1)
if [ -z "$percent" ]; then
  sketchybar --set "$NAME" drawing=off
else
  image="$cache_dir/battery-$percent.png"
  [ -f "$image" ] || "$cache_dir/render" battery "$percent" "$image"
  sketchybar --set "$NAME" drawing=on background.image="$image"
fi
