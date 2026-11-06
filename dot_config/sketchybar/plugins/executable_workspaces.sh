#!/bin/bash
# Ignore events while SketchyBar is rebuilding its items during a reload.
sketchybar --query workspace.refresh >/dev/null 2>&1 || exit 0
source "${CONFIG_DIR:-$HOME/.config/sketchybar}/colors.sh"
cache_dir="$HOME/.cache/sketchybar"
focused=$(aerospace list-workspaces --focused 2>/dev/null)
windows=$(aerospace list-windows --all --format '%{workspace}|%{app-bundle-id}' 2>/dev/null)
args=()
for workspace in 1 2 3 4 5 6; do
  bundles=()
  while IFS= read -r bundle; do
    [ -n "$bundle" ] && bundles+=("$bundle")
  done < <(printf '%s\n' "$windows" | awk -F '|' -v ws="$workspace" '$1==ws && !seen[$2]++ {print $2}' | head -3)
  fg="$MUTED"
  bg="$CHIP"
  [ "${#bundles[@]}" -gt 0 ] && fg="$FG"
  if [ "$workspace" = "$focused" ]; then
    fg=0xff141414
    bg="$ACCENT"
  fi
  args+=(--set "workspace.$workspace" "background.color=$bg" --set "space.$workspace" "icon.color=$fg")
  for index in 1 2 3; do
    bundle="${bundles[$((index-1))]}"
    if [ -n "$bundle" ]; then
      image="$cache_dir/app-$bundle.png"
      [ -f "$image" ] || "$cache_dir/render" app "$bundle" "$image" 2>/dev/null
      if [ -f "$image" ]; then
        args+=(--set "space.$workspace.app.$index" drawing=on "background.image=$image")
        continue
      fi
    fi
    args+=(--set "space.$workspace.app.$index" drawing=off)
  done
done
sketchybar "${args[@]}"
