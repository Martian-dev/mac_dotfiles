# mac_dotfiles

macOS shell, terminal and desktop configuration managed with chezmoi. No encryption or password-manager integration is required. Only the selected configuration files are tracked; SSH keys, account tokens and session snapshots stay local.

## Included

- Zsh: the existing Starship prompt and aliases, Homebrew completions, fzf shell integration, fzf-tab, autosuggestions and syntax highlighting.
- Ghostty: Everforest dark medium, with Option+digits forwarded to tmux.
- tmux: Everforest colors, default Ctrl+B prefix, default keybindings and zero-based window numbering. Option+0–9 switches windows. TPM, Resurrect and Continuum provide session saving/restoration.
- AeroSpace: six persistent numbered workspaces, pybash1's shortcuts, bfpimentel's 8px gaps and horizontal tiling. A 40px top gap leaves room for SketchyBar. Ghostty stays tiled alongside other apps. Command+T opens an independent terminal window; use tmux for tabs within a window.
- Karabiner: pybash1's Caps Lock → Command+Option+Control mapping, F4 → Escape, and Caps+D/N macros. His hardware-specific device entry is omitted.
- SketchyBar: workspaces, current app, media, output device, volume, battery and clock. Dark gray translucent styling follows bfpimentel's current Halo palette; his current repo does not contain a SketchyBar config.
- JankyBorders: bfpimentel's thin rounded white active borders.

The native macOS menu bar automatically hides to make room for SketchyBar; move the pointer to the top edge to access it.

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

The desktop bar is a SketchyBar adaptation of bfpimentel's current Halo palette, not an exact copy of a historical desktop screenshot. Wallpaper, desktop widgets and Ghostty's native titlebar are independent visual settings.

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
