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

`yabai` provides BSP tiling and animation-free Space switching; `skhd` owns the
keyboard shortcuts. System Integrity Protection stays enabled, so the optional
yabai scripting addition is not installed.

The existing Rectangle placements are preserved:

| Shortcut | Action |
| --- | --- |
| `Cmd+Option+Arrow` | Float and place the window in that screen half |
| `Cmd+Option+F` | Maximize |
| `Cmd+Option+D` | Almost maximize |
| `Cmd+Option+C` | Center at half width and height |
| `Control+1` ... `Control+9` | Focus a Space instantly |
| `Control+Shift+1` ... `Control+Shift+9` | Send the window to a Space and follow it |
| `Control+Command+Left/Right` | Focus the previous/next Space instantly |
| `Control+Option+B` | Snap eligible windows into a balanced BSP layout |
| `Control+Option+Tab` | Cycle focus to the next visible or stacked window |
| `Control+Option+Shift+Tab` | Cycle focus to the previous visible or stacked window |
| `Control+Option+H/J/K/L` | Focus the window to the west/south/north/east |
| `Control+Option+Shift+H/J/K/L` | Swap with the window in that direction |
| `Control+Option+S` | Use a stacked layout |
| `Control+Option+F` | Toggle the focused window between floating and tiled |

For mouse control, hold `Control` and left-drag to move a window, or hold
`Control` and right-drag to resize from the corner under the pointer. yabai
supports one mouse modifier rather than Rectangle Pro's distinct modifier sets.

Finder Quick Look previews, including PDFs opened with `Space`, use macOS's
native behavior. yabai leaves the preview panel unmanaged so it floats above
the existing layout without moving or retiling other windows.

The Rectangle-style `Cmd+Option` grid shortcuts intentionally make a window
float. Press `Control+Option+B` whenever you want to bring the current Space
back under automatic tiling; focus, swap, zoom, and balance commands operate on
that managed BSP tree.

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
