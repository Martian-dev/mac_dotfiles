#!/bin/bash
set -euo pipefail
config_dir="${CONFIG_DIR:-$HOME/.config/sketchybar}"
cache_dir="$HOME/.cache/sketchybar"
mkdir -p "$cache_dir"
xcrun swiftc "$config_dir/helpers/render.swift" -o "$cache_dir/render"
