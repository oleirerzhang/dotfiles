-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Share yanks and pastes with the macOS clipboard.
vim.opt.clipboard = "unnamedplus"

-- Let Kitty's blurred background show through every pop-up. Catppuccin only
-- clears the completion menu's background when it isn't blended, and a thin
-- rounded border keeps each see-through pop-up distinct from the code behind it.
vim.opt.pumblend = 0
vim.opt.winborder = "rounded"
