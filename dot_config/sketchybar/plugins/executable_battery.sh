#!/bin/bash
battery=$(pmset -g batt)
percent=$(printf '%s\n' "$battery" | sed -n 's/.*[[:space:]]\([0-9][0-9]*%\).*/\1/p' | head -1)
if [ -z "$percent" ]; then
  sketchybar --set "$NAME" drawing=off
else
  icon=BAT
  case "$battery" in *'AC Power'*) icon=AC ;; esac
  sketchybar --set "$NAME" drawing=on icon="$icon" label="$percent"
fi
