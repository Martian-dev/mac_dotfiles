#!/bin/bash
set -euo pipefail
# Use the native macOS menu bar; retain SketchyBar config for later.
defaults write NSGlobalDomain _HIHideMenuBar -bool false
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
brew services stop sketchybar
brew services start borders
open -a AeroSpace
open -a Karabiner-Elements
