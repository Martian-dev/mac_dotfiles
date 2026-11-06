#!/bin/bash
set -euo pipefail
repo_dir="$(cd -- "$(dirname -- "$0")" && pwd)"
if ! command -v brew >/dev/null 2>&1; then
  echo 'Install Homebrew from https://brew.sh first, then rerun this script.' >&2
  exit 1
fi
brew bundle --file="$repo_dir/Brewfile"
chezmoi init --source "$repo_dir"
chezmoi apply
