#!/bin/bash
device=$(SwitchAudioSource -c 2>/dev/null)
sketchybar --set "$NAME" label="${device:-Audio}"
