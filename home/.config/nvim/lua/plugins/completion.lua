return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- Shift+Tab still jumps back through snippet placeholders; otherwise it
        -- dedents the current line by one 'shiftwidth', like a code editor.
        ["<S-Tab>"] = {
          "snippet_backward",
          function()
            vim.api.nvim_feedkeys(vim.keycode("<C-d>"), "n", false)
            return true
          end,
        },
      },
    },
  },
}
