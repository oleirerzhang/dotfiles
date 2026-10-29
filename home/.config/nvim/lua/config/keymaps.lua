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

-- Other macOS editing shortcuts. Kitty forwards Cmd and Option keys to Neovim
-- (see kitty.conf and pass_keys.py), where they arrive as <D-…> and <M-…>.
vim.keymap.set("n", "<D-z>", "u", { desc = "Undo" })
vim.keymap.set("x", "<D-z>", "<Esc>u", { desc = "Undo" })
vim.keymap.set("i", "<D-z>", "<C-o>u", { desc = "Undo" })
vim.keymap.set("n", "<D-Z>", "<C-r>", { desc = "Redo" })
vim.keymap.set("i", "<D-Z>", "<C-o><C-r>", { desc = "Redo" })
vim.keymap.set({ "n", "i", "x" }, "<D-s>", "<Cmd>write<CR>", { desc = "Save File" })
vim.keymap.set({ "n", "i", "x" }, "<D-a>", "<Esc>ggVG", { desc = "Select All" })
vim.keymap.set("x", "<D-x>", '"+d', { desc = "Cut selection to macOS clipboard" })
vim.keymap.set("n", "<D-x>", '"+dd', { desc = "Cut line to macOS clipboard" })

-- Option+Left/Right: jump to the start of the previous word or the end of the
-- next one, as in macOS text fields.
vim.keymap.set({ "n", "x" }, "<M-Left>", "b", { desc = "Word Left" })
vim.keymap.set({ "n", "x" }, "<M-Right>", "e", { desc = "Word Right" })
vim.keymap.set("i", "<M-Left>", function()
  vim.fn.search([[\<]], "bW")
end, { desc = "Word Left" })
vim.keymap.set("i", "<M-Right>", function()
  vim.fn.search([[\>]], "W")
end, { desc = "Word Right" })

-- Cmd+Left/Right: line start/end. Line start goes to the first non-blank
-- character first, then to column 0 on a second press, like most code editors.
local function line_start()
  local first = vim.fn.match(vim.fn.getline("."), [[\S]])
  local col = vim.fn.col(".") - 1
  vim.fn.cursor(vim.fn.line("."), (col == first or first < 0) and 1 or first + 1)
end
vim.keymap.set({ "n", "x", "i" }, "<D-Left>", line_start, { desc = "Line Start" })
vim.keymap.set({ "n", "x" }, "<D-Right>", "$", { desc = "Line End" })
vim.keymap.set("i", "<D-Right>", "<End>", { desc = "Line End" })

-- In Neovim's own terminal, pass the shell the readline keys it expects.
vim.keymap.set("t", "<M-Left>", "<M-b>")
vim.keymap.set("t", "<M-Right>", "<M-f>")
vim.keymap.set("t", "<D-Left>", "<C-a>")
vim.keymap.set("t", "<D-Right>", "<C-e>")

-- Save and run the current file in the same terminal as <C-/>, so input works,
-- the output stays visible, and ↑ Enter in the shell re-runs it.
local runners = {
  python = function(file)
    -- Inside a project, use its environment. For loose scripts, uv would pick
    -- macOS's /usr/bin/python3 (3.9) first, so ask for a current Python.
    if vim.fs.root(file, "pyproject.toml") then
      return "uv run"
    end
    return "uv run --python '>=3.12'"
  end,
}
vim.keymap.set("n", "<leader>r", function()
  local runner = runners[vim.bo.filetype]
  if not runner then
    vim.notify("No runner for filetype '" .. vim.bo.filetype .. "'", vim.log.levels.WARN)
    return
  end
  vim.cmd("write")
  local file = vim.fn.expand("%:p")
  local root = LazyVim.root()
  local cmd = runner(file) .. " " .. vim.fn.shellescape(vim.fs.relpath(root, file) or file)

  local term = Snacks.terminal.get(nil, { cwd = root })
  if not term then
    return
  end
  term:show()
  term:focus()
  vim.api.nvim_chan_send(vim.bo[term.buf].channel, cmd .. "\r")
  vim.cmd.startinsert()
end, { desc = "Run File" })
