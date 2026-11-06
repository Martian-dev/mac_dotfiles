#!/bin/bash
volume="${INFO:-$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)}"
symbol=speaker.wave.2.fill
[ "${volume:-0}" = 0 ] && symbol=speaker.slash.fill
sketchybar --set "$NAME" label="${volume:-?}%" \
  background.image="$HOME/.cache/sketchybar/$symbol.png"
