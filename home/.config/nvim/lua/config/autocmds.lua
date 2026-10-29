-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- `nvim some/folder` otherwise keeps the shell's directory as the working
-- directory, so file search and grep cover that instead of the project.
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
  local dir = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
  -- LazyVim loads this file during startup when nvim is given an argument, but
  -- the dashboard only checks that argument on UIEnter. A relative path like
  -- `sumba` stops resolving once we've moved, so change directory only after
  -- every UIEnter handler has run.
  if vim.v.vim_did_enter == 1 then
    vim.fn.chdir(dir)
  else
    vim.api.nvim_create_autocmd("UIEnter", {
      once = true,
      callback = vim.schedule_wrap(function()
        vim.fn.chdir(dir)
      end),
    })
  end
end

-- Autosave: write a file a second after you stop editing (leaving insert mode
-- or a normal-mode change), and straight away when you switch to another
-- window, such as the <C-/> terminal, or away from Kitty. Autosaves skip
-- format-on-save so code doesn't shift while you're thinking; :w and Cmd+S
-- still format.
local function autosave(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local bo = vim.bo[buf]
  if bo.buftype ~= "" or bo.readonly or not bo.modifiable or not bo.modified then
    return
  end
  if vim.api.nvim_buf_get_name(buf) == "" then
    return
  end
  vim.api.nvim_buf_call(buf, function()
    local autoformat = vim.b.autoformat
    vim.b.autoformat = false
    vim.cmd("silent! update")
    vim.b.autoformat = autoformat
  end)
end

local autosave_group = vim.api.nvim_create_augroup("autosave", { clear = true })
local autosave_timers = {}
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = autosave_group,
  callback = function(args)
    local timer = autosave_timers[args.buf]
    if timer then
      timer:stop()
      timer:close()
    end
    autosave_timers[args.buf] = vim.defer_fn(function()
      autosave_timers[args.buf] = nil
      autosave(args.buf)
    end, 1000)
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "FocusLost" }, {
  group = autosave_group,
  callback = function(args)
    autosave(args.buf)
  end,
})
