-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Kitty translates Cmd+C to F29 while Neovim is focused. This keeps macOS's
-- familiar shortcut without relying on terminal applications receiving Cmd.
vim.keymap.set("x", "<F29>", '"+y', { desc = "Copy selection to macOS clipboard" })
vim.keymap.set("n", "<F29>", '"+yy', { desc = "Copy line to macOS clipboard" })
