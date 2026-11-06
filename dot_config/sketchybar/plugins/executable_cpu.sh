#!/bin/bash
usage=$("$HOME/.cache/sketchybar/render" cpu "$HOME/.cache/sketchybar/cpu-state") || exit
percent=$(awk -v usage="$usage" 'BEGIN { printf "%.0f", usage * 100 }')
sketchybar --set cpu.label label="CPU  $percent%" --push cpu.graph "$usage"
