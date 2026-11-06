#!/bin/bash
set -euo pipefail
# Prevent accidental Dock reveals when the pointer touches the screen edge.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
killall Dock || true
