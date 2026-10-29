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
