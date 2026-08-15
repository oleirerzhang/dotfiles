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

## LaTeX live preview

Open a project from the directory containing its main TeX file:

```sh
nvim main.tex
```

VimTeX starts `latexmk` in continuous mode automatically. TeX buffers save
after an 800 ms typing pause, the PDF recompiles, and Skim reloads it. Press
`Space c p` to open the PDF or forward-search from the current source line.

Useful VimTeX defaults use the local leader (`\\`):

- `\\lv` opens or forward-searches in the PDF viewer.
- `\\ll` starts or toggles continuous compilation.
- `\\le` shows compiler errors.
- `\\lq` stops the compiler.
- `\\lc` removes generated auxiliary files.

Skim remains in the background while compiling, so it does not steal focus
from Neovim. The current setup uses VimTeX 2.17 because Neovim 0.11 does not
meet VimTeX 2.18's Neovim 0.12.4 requirement.

Full documentation: https://www.lazyvim.org/
