#!/bin/bash
device=$(SwitchAudioSource -c 2>/dev/null)
symbol=hifispeaker.fill
case "$device" in *AirPods*|*Headphone*|*headphone*|*Headset*|*headset*) symbol=headphones ;; esac
sketchybar --set audio_device.name label="${device:-Audio output}" \
  --set audio_device background.image="$HOME/.cache/sketchybar/$symbol.png"
