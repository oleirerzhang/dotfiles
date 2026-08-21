# macOS dotfiles

Private, reproducible setup for Oliver's Macs.

This repository is the recovery and clean-install layer. For the current Mac-to-Mac move, use Migration Assistant first: it transfers applications, the user account, documents, and many settings in one pass. Then use this repository to audit what arrived and to rebuild command-line tools or shell configuration later.

## What is included

- `Brewfile`: current top-level Homebrew formulae and casks, plus detected Mac App Store apps.
- `home/`: portable shell settings, LazyVim, Kitty, and yabai/skhd configuration.
- `scripts/bootstrap`: installs Homebrew dependencies and links the reviewed dotfiles.
- `scripts/capture`: creates fresh application and Homebrew snapshots for review.
- `macos/applications.txt`: inventory of applications found on the source Mac.
- `alfred/README.md`: the supported Alfred migration procedure.

The live `Alfred.alfredpreferences` bundle is intentionally excluded. It may contain workflow credentials and executable files; Alfred's built-in sync is a better transport for it.

## Fast path on the new Mac

If you used Migration Assistant, first verify the migrated apps and Alfred. The bootstrap is mainly useful for missing tools or a future clean install.

```sh
git clone https://github.com/ZhangO999/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/bootstrap
```

The installer backs up an existing destination before replacing it with a symlink. It does not modify unrelated files.

## Neovim in Kitty

LazyVim is intentionally close to its official defaults. In Kitty, press `Cmd+Option+E` to open `nvim .` in a new tab at the current directory. Inside Neovim, press `Space` and pause to see the available commands. The editor-specific quick start is in `home/.config/nvim/README.md`.

## Window management

`yabai` runs in floating mode and `skhd` provides Rectangle-style placement
shortcuts. There is no automatic tiling, Space control, focus navigation, or
special handling for Quick Look.

| Shortcut | Action |
| --- | --- |
| `Cmd+Option+Left` | Place the focused window in the left half |
| `Cmd+Option+Right` | Place the focused window in the right half |
| `Cmd+Option+Up` | Place the focused window in the top half |
| `Cmd+Option+Down` | Place the focused window in the bottom half |
| `Cmd+Option+H` | Place the focused window in the top-left quadrant |
| `Cmd+Option+J` | Place the focused window in the bottom-left quadrant |
| `Cmd+Option+K` | Place the focused window in the top-right quadrant |
| `Cmd+Option+L` | Place the focused window in the bottom-right quadrant |
| `Cmd+Option+Shift+E` | Arrange up to eight windows in a 4-by-2 ultrawide grid |

Quadrant assignments are remembered per display and Space. When a window's
minimum size exceeds one quarter of the screen, its row or column expands and
an adjacent assigned window receives the remaining room. If two minimum sizes
cannot fit simultaneously, the windows remain anchored to opposite edges and
overlap only by the unavoidable amount.

On a clean install, `scripts/bootstrap` starts both launch agents. Grant both
executables access in **System Settings > Privacy & Security > Accessibility**,
then run `yabai --restart-service` and `skhd --restart-service`. If the bootstrap
changed **Displays have separate Spaces**, log out once before using yabai.

## Refresh snapshots on this Mac

```sh
cd ~/dotfiles
./scripts/capture
```

This refreshes `macos/applications.txt` and writes `Brewfile.generated` for inspection. Compare the generated file with the curated `Brewfile` before replacing anything.

## Migration checklist

See [macos/MIGRATION.md](macos/MIGRATION.md) before wiping or trading in the old Mac.
