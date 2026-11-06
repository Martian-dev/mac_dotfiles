#!/bin/bash
workspace="$1"
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
if [ "$workspace" = "$focused" ]; then
  sketchybar --set "$NAME" background.drawing=on icon.color=0xff141414
else
  sketchybar --set "$NAME" background.drawing=off icon.color=0xff6b6b6b
fi
