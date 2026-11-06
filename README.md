# mac_dotfiles

macOS shell, terminal and desktop configuration managed with chezmoi. No encryption or password-manager integration is required. Only the selected configuration files are tracked; SSH keys, account tokens and session snapshots stay local.

## Current desktop mode

SketchyBar is paused and disabled at login; its configuration is retained for later. The native macOS menu bar stays visible. AeroSpace uses an 8px top gap below the system menu bar, and its SketchyBar callbacks are disabled. Ghostty has 12px horizontal and 8px vertical padding.

## Included

- Zsh: the existing Starship prompt and aliases, Homebrew completions, fzf shell integration, fzf-tab, autosuggestions and syntax highlighting.
- Ghostty: Everforest dark medium, hidden native titlebar, with Option+digits forwarded to tmux.
- tmux: Everforest colors, default Ctrl+B prefix, default keybindings and zero-based window numbering. Option+0–9 switches windows. TPM, Resurrect and Continuum provide session saving/restoration.
- AeroSpace: six persistent numbered workspaces, pybash1's shortcuts, bfpimentel's 8px gaps and horizontal tiling. All AeroSpace gaps are 8px while the native macOS menu bar is active. Ghostty stays tiled alongside other apps. Command+T opens an independent terminal window; use tmux for tabs within a window.
- Karabiner: pybash1's Caps Lock → Command+Option+Control mapping, F4 → Escape, and Caps+D/N macros. His hardware-specific device entry is omitted.
- SketchyBar (currently disabled): a persistent translation of bfpimentel's current Halo overview, with its 26pt clock, stacked weekday/date, 56px CPU sparkline, 30px battery ring and 26px workspace chips containing up to three native 14px app icons. Current app, media and compact audio controls remain available; click the output-device icon for its name.
- JankyBorders: bfpimentel's thin rounded white active borders.

The native macOS menu bar stays visible; SketchyBar is currently stopped. The Dock has a 1000-second reveal delay to prevent accidental bottom-edge popups. Undo the delay with `defaults delete com.apple.dock autohide-delay` followed by `killall Dock`.

## Install on a Mac

Install Homebrew, then:

```sh
git clone https://github.com/Martian-dev/mac_dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
./bootstrap.sh
```

Run bootstrap in an interactive terminal: Karabiner's installer needs administrator authentication. Grant any macOS Accessibility, Input Monitoring and driver/background permissions requested by AeroSpace or Karabiner. Install a Node version with nvm if this is a fresh machine. Reload Ghostty with Command+Shift+comma and open a new shell.

Start terminal sessions with `tmux new -As main`. This does not automatically start tmux in every shell.

## Keys

| Action | Keys |
|---|---|
| tmux prefix | Ctrl+B |
| New tmux window | Ctrl+B, then C |
| Split panes | Ctrl+B, then % or " |
| Change pane | Ctrl+B, then arrow |
| Detach | Ctrl+B, then D |
| Switch tmux window | Option+0–9 |
| Save session | Ctrl+B, then Ctrl+S |
| Restore session | Ctrl+B, then Ctrl+R |
| Switch desktop workspace | Caps Lock+1–6 |
| Move window to workspace | Caps Lock+Shift+1–6 |
| Focus neighboring window | Caps Lock+arrow |
| Move window | Caps Lock+Shift+arrow |
| Open Ghostty | Caps Lock+Enter |
| Resize window | Caps Lock+minus/equal |
| Toggle tiling/accordion orientation | Caps Lock+slash/comma |
| Previous workspace | Option+Tab |
| AeroSpace service mode | Caps Lock+Shift+semicolon |

In AeroSpace service mode, F toggles floating, R resets the layout, and Escape reloads the config and exits the mode. The imported Caps+D/N macros emit Option+Shift+K followed by 1/3; their effect depends on the receiving app.

Continuum saves every 15 minutes while an attached tmux client renders the status bar and restores on tmux server startup. Restoration recovers session/window/pane structure and working directories; it is not a checkpoint of arbitrary running processes. Saved state stays outside Git in tmux-resurrect's local data directory.

## Ghostty tabs and AeroSpace

Ghostty remains tiled. Command+T opens a separate Ghostty window, like Command+N. Use tmux windows (Ctrl+B, then C; Option+0–9 to switch) for tabs within a terminal. tmux remains manually started.

macOS exposes Ghostty native tabs as separate windows to AeroSpace, which can leave blank tiled areas. This is a [documented Ghostty/macOS limitation](https://ghostty.org/docs/help/macos-tiling-wms), not a duplicate shortcut. The suggested force-tiling workaround was tested on this Mac and did not resolve it. The native New Tab menu action still exists; avoid it while Ghostty is tiled.

## Saved SketchyBar appearance (currently disabled)

The bar recreates the visual components in [bfpimentel's Overview.tsx](https://github.com/bfpimentel/dotfiles/blob/52702407aac544e08baada16f25d1c5c3806f466/dotfiles/halo/dashboard/Overview.tsx) using SketchyBar. The source uses Halo, so this is an implementation in a different bar, rather than an imported SketchyBar config. Numbered workspaces and your keybindings are preserved.

- Exact theme values: background `#141414f2`, foreground `#e8e8e8`, accent `#d6d6d6`, muted `#6b6b6b`.
- Panel radius 9px with a subtle `#ffffff12` border. Workspace chips use radius 4px and `#ffffff08` backgrounds, with 6px between chips.
- 8px AeroSpace gaps and thin rounded JankyBorders follow the reference. The built-in MacBook display's reserved 32px top area is included when calculating the gap below the bar.
- Native app icons and SF Symbols are rendered locally through AppKit, with no downloaded icon assets. The battery ring and CPU sample data update live.
- `helpers/render.swift` compiles into `~/.cache/sketchybar/render` when its source changes. Generated images and CPU samples also remain in that cache, outside Git. Homebrew's Xcode Command Line Tools provide Swift/AppKit; JetBrains Mono Nerd Font is included in the Brewfile.

Ghostty's native titlebar is hidden for a minimal terminal appearance. This setting takes effect in new windows after a config reload; existing windows must be recreated to lose their titlebar. Wallpaper and desktop widgets are independent of the bar/window-manager styling.

## Update configs

```sh
chezmoi edit ~/.config/tmux/tmux.conf
chezmoi diff
chezmoi apply
# After editing files directly, import only the changed file:
chezmoi re-add ~/.config/tmux/tmux.conf
chezmoi cd
git add .
git commit -m "Update tmux configuration"
git push
```

Reload tmux with `tmux source-file ~/.config/tmux/tmux.conf`, SketchyBar with `sketchybar --reload`, AeroSpace with `aerospace reload-config`, and open a new shell for Zsh changes. tmux plugins are managed as chezmoi Git externals and can also be updated through TPM with Ctrl+B, then Shift+U.

Backups from the initial setup are in `~/.local/state/mac-dotfiles-backup` on the original Mac. Stop desktop services with `brew services stop sketchybar` and `brew services stop borders`. Restore a permanently visible menu bar with `defaults write NSGlobalDomain _HIHideMenuBar -bool false` and log out/in if needed.

## Sources

- [pybash1/dotdotdot](https://github.com/pybash1/dotdotdot): AeroSpace shortcuts, Karabiner rules and tmux session workflow.
- [bfpimentel/dotfiles](https://github.com/bfpimentel/dotfiles): AeroSpace spacing, borders and [Halo palette](https://github.com/bfpimentel/dotfiles/blob/main/dotfiles/halo/ui/theme.ts), adapted for SketchyBar.
- [Everforest](https://github.com/sainnhe/everforest): terminal and tmux palette.
