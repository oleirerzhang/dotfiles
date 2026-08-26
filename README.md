# macOS dotfiles

Private, reproducible setup for Oliver's Macs.

This repository is the recovery and clean-install layer. For the current Mac-to-Mac move, use Migration Assistant first: it transfers applications, the user account, documents, and many settings in one pass. Then use this repository to audit what arrived and to rebuild command-line tools or shell configuration later.

## What is included

- `Brewfile`: Homebrew taps, formulae, casks, VS Code extensions and Mac App Store apps. Generated; edit `Brewfile.extra` instead.
- `Brewfile.extra`: entries `brew bundle dump` cannot produce on this Mac, merged in by `scripts/capture`.
- `home/`: shell settings, LazyVim, Kitty, fish, fastfetch, Hammerspoon, and yabai/skhd configuration.
- `macos/defaults.sh`: the macOS preferences this Mac differs from stock on.
- `macos/capture-defaults`: prints the current value of every tracked preference.
- `macos/defaults-snapshot.txt`: the audit record those two are compared against.
- `macos/applications.txt`: inventory of applications found on the source Mac.
- `scripts/bootstrap`: installs Homebrew dependencies, links the dotfiles, applies the macOS defaults.
- `scripts/capture`: refreshes every snapshot in this repository.
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

`yabai` runs in floating mode and `skhd` provides the shortcuts. There is no
automatic tiling and no special handling for Quick Look: nothing moves unless
a shortcut moves it.

### One window at a time

| Shortcut | Action |
| --- | --- |
| `Cmd+Option+Left` | Left half |
| `Cmd+Option+Right` | Right half |
| `Cmd+Option+Up` | Top half |
| `Cmd+Option+Down` | Bottom half |
| `Cmd+Option+F` | Full screen area |
| `Cmd+Option+H` | Top-left quadrant |
| `Cmd+Option+J` | Bottom-left quadrant |
| `Cmd+Option+K` | Top-right quadrant |
| `Cmd+Option+L` | Bottom-right quadrant |

Quadrant assignments are remembered per display and Space. When a window's
minimum size exceeds one quarter of the screen, its row or column expands and
an adjacent assigned window receives the remaining room. If two minimum sizes
cannot fit simultaneously, the windows remain anchored to opposite edges and
overlap only by the unavoidable amount.

### Every window on the Space

Add `Shift` to arrange the whole Space at once. Windows fill the layout's
slots in yabai's front-to-back order, so the window used most recently takes
the main slot. Layouts hold at most four windows; anything further back is
left where it is. Pressing the same layout twice rotates the placed windows
through the slots.

| Shortcut | Layout |
| --- | --- |
| `Cmd+Option+Shift+Left` | Main window left, the rest stacked right |
| `Cmd+Option+Shift+Right` | Main window right, the rest stacked left |
| `Cmd+Option+Shift+H` | Halves |
| `Cmd+Option+Shift+Q` | Quadrants |
| `Cmd+Option+Shift+C` | Equal columns |
| `Cmd+Option+Shift+R` | Equal rows |

Sizes are negotiated rather than imposed. Each window is asked for its share
and then measured, because an application may refuse to shrink below its own
minimum; whatever it refuses to give up is taken off its neighbours. When the
minimums cannot fit at all, the windows sit at those minimums and overlap.
On a laptop display that is the normal outcome for four equal columns or rows.

### Spaces

| Shortcut | Action |
| --- | --- |
| `Cmd+Option+1`..`4` | Focus that Space |
| `Cmd+Option+[` / `]` | Previous / next Space |
| `Cmd+Option+Tab` | The Space you came from |
| `Cmd+Option+Shift+1`..`4` | Send the focused window to that Space |

These call yabai directly instead of going through Mission Control, which
skips the slide animation. Two preferences make that work, both applied by
`macos/defaults.sh`: **Reduce Motion** turns the remaining transition into a
quick crossfade, and **mru-spaces** off keeps Spaces in a fixed order so the
numbered shortcuts keep pointing at the same Space. Reduce Motion has to be
set by hand in System Settings; see the note at the end of `defaults.sh`.

On a clean install, `scripts/bootstrap` starts both launch agents. Grant both
executables access in **System Settings > Privacy & Security > Accessibility**,
then run `yabai --restart-service` and `skhd --restart-service`. If the bootstrap
changed **Displays have separate Spaces**, log out once before using yabai.

## Refresh snapshots on this Mac

```sh
cd ~/dotfiles
./scripts/capture
```

This rewrites `Brewfile`, `macos/applications.txt` and
`macos/defaults-snapshot.txt`. Review the diff before committing: a capture
records whatever happens to be installed today, including things installed by
accident.

`brew bundle dump` is not reliably complete on this Mac. A circular dependency
between `libtiff` and `webp` in the installed keg tabs can abort its sort
part-way, and it cannot see App Store apps at all unless `mas` is installed.
Anything it misses lives in `Brewfile.extra`, which `scripts/capture` appends
to the dump while dropping any line the dump already covers. If something you
rely on disappears from `Brewfile` after a capture, add it to `Brewfile.extra`
rather than editing `Brewfile`.

## Migration checklist

See [macos/MIGRATION.md](macos/MIGRATION.md) before wiping or trading in the old Mac.
