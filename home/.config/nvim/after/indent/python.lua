-- Replaces Neovim's built-in Python indent (tree-sitter's is disabled for
-- Python in plugins/treesitter.lua). See lua/config/python_indent.lua.
vim.bo.indentexpr = "v:lua.require'config.python_indent'.indentexpr()"
-- Only work out the indent when opening a line, never re-indent text already
-- typed, so a line dedented with Shift+Tab stays put when you type ":".
vim.bo.indentkeys = "o,O"
