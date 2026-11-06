#!/bin/bash
sketchybar --set clock.time label="$(date '+%H:%M')" \
  --set clock.day label="$(date '+%A')" \
  --set clock.date label="$(date '+%-d %B')"
