-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Kitty translates Cmd+C/Cmd+V to otherwise-unused function keys while
-- Neovim is focused. This gives each mode predictable macOS clipboard actions.
vim.keymap.set({ "x", "s" }, "<F29>", '"+y', { desc = "Copy selection to macOS clipboard" })
vim.keymap.set("n", "<F29>", '"+yy', { desc = "Copy line to macOS clipboard" })
vim.keymap.set("i", "<F29>", "<Nop>", { desc = "Copy requires selected text" })

vim.keymap.set("i", "<F30>", '<C-r><C-o>+', { desc = "Paste macOS clipboard" })
vim.keymap.set("n", "<F30>", '"+p', { desc = "Paste macOS clipboard" })
vim.keymap.set({ "x", "s" }, "<F30>", '"+P', { desc = "Replace with macOS clipboard" })
vim.keymap.set("c", "<F30>", '<C-r>+', { desc = "Paste macOS clipboard" })
