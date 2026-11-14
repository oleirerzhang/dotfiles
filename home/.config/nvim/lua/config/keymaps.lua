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

-- Cmd+/ toggles comments, as in LeetCode and VS Code: the current line in
-- Normal and Insert mode (the cursor stays on the same character), or every
-- selected line in Visual mode (the selection is kept, so a second Cmd+/
-- undoes the first). Uses Neovim's built-in gc/gcc, so each filetype gets its
-- own comment style: "# " for Python, "// " for C++.
local function toggle_comment_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local before = #vim.api.nvim_get_current_line()
  vim.cmd.normal("gcc")
  local delta = #vim.api.nvim_get_current_line() - before
  vim.api.nvim_win_set_cursor(0, { row, math.max(0, col + delta) })
end
vim.keymap.set({ "n", "i" }, "<D-/>", toggle_comment_line, { desc = "Toggle Comment" })
vim.keymap.set("x", "<D-/>", "gcgv", { remap = true, desc = "Toggle Comment" })

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

-- Shift+Tab dedents by one 'shiftwidth'. Once blink.cmp loads, its buffer-local
-- insert mapping (plugins/completion.lua) takes over so snippets still work;
-- this global one covers the moment before. Visual mode keeps the selection.
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Dedent Line" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Dedent Line" })
vim.keymap.set("x", "<S-Tab>", "<gv", { desc = "Dedent Selection" })

-- In Neovim's own terminal, pass the shell the readline keys it expects.
vim.keymap.set("t", "<M-Left>", "<M-b>")
vim.keymap.set("t", "<M-Right>", "<M-f>")
vim.keymap.set("t", "<D-Left>", "<C-a>")
vim.keymap.set("t", "<D-Right>", "<C-e>")

-- Run a command in the same terminal as <C-/>, so input works, the output stays
-- visible, and ↑ Enter in the shell re-runs it.
local function run_in_terminal(cmd)
  local term = Snacks.terminal.get(nil, { cwd = LazyVim.root() })
  if not term then
    return
  end
  term:show()
  term:focus()
  vim.api.nvim_chan_send(vim.bo[term.buf].channel, cmd .. "\r")
  vim.cmd.startinsert()
end

-- <leader>r saves and runs the current file.
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
  run_in_terminal(runner(file) .. " " .. vim.fn.shellescape(vim.fs.relpath(root, file) or file))
end, { desc = "Run File" })

-- <leader>t saves and runs the project's tests with pytest (or, for a loose
-- script outside a project, pytest on the current file).
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("silent! write")
  local file = vim.fn.expand("%:p")
  if vim.fs.root(file, "pyproject.toml") then
    run_in_terminal("uv run pytest")
  else
    local rel = vim.fs.relpath(LazyVim.root(), file) or file
    run_in_terminal("uv run --python '>=3.12' --with pytest pytest " .. vim.fn.shellescape(rel))
  end
end, { desc = "Run Tests" })
