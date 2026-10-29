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
