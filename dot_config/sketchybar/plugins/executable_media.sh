#!/bin/bash
if [ -z "$INFO" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi
state=$(printf '%s' "$INFO" | jq -r '.state // "stopped"')
if [ "$state" = playing ]; then
  title=$(printf '%s' "$INFO" | jq -r '[.artist, .title] | map(select(. != null and . != "")) | join(" — ")')
  sketchybar --set "$NAME" drawing=on label="$title"
else
  sketchybar --set "$NAME" drawing=off
fi
