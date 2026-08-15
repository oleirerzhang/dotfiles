# LazyVim quick start

This is the official [LazyVim starter](https://github.com/LazyVim/starter), kept deliberately close to the defaults.

## Start

- In Kitty, press `Cmd+Option+E` to open `nvim .` in a new tab at the current directory.
- From a shell, run `nvim .` for a project or `nvim path/to/file` for one file.
- Press `Space` and pause: WhichKey shows the available leader-key commands.

## First keys to learn

- `i` enters Insert mode; `Esc` returns to Normal mode.
- `:w` saves, `:q` quits, and `:wq` saves and quits.
- `Space f f` finds files; `Space /` searches project text.
- `Space e` toggles the file explorer.
- `Space g g` opens Lazygit.
- `gd` goes to a definition, `gr` shows references, and `K` shows documentation.
- `Space c a` shows code actions and `Space c r` renames a symbol.
- `[d` and `]d` move between diagnostics.
- `Ctrl+h/j/k/l` moves between Neovim windows and matches the Kitty navigation keys.

## Maintenance

- `:Lazy` manages plugins.
- `:LazyExtras` enables maintained language/framework integrations when needed.
- `:checkhealth lazyvim` checks the installation.

Full documentation: https://www.lazyvim.org/
