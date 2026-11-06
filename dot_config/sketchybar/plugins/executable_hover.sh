#!/bin/bash
focused=$(aerospace list-workspaces --focused 2>/dev/null)
[ "$1" = "$focused" ] && exit 0
if [ "$SENDER" = mouse.entered ]; then
  sketchybar --animate sin 12 --set "workspace.$1" background.color=0x14ffffff
else
  sketchybar --animate sin 12 --set "workspace.$1" background.color=0x08ffffff
fi
