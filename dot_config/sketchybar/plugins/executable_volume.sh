#!/bin/bash
volume="${INFO:-$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)}"
sketchybar --set "$NAME" label="${volume:-?}%"
