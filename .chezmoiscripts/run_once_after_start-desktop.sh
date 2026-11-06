#!/bin/bash
set -euo pipefail
# Match bfpimentel's menu bar behavior so SketchyBar has its own space.
defaults write NSGlobalDomain _HIHideMenuBar -bool true
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
brew services start sketchybar
brew services start borders
open -a AeroSpace
open -a Karabiner-Elements
