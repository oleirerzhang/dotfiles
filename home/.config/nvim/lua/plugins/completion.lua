return {
  {
    "saghen/blink.cmp",
    opts = {
      -- Quiet, LeetCode-style typing: no completion menu, docs window or ghost
      -- text while you type. Ctrl+N opens the menu on demand (Ctrl+Space is
      -- taken by macOS for switching input sources).
      completion = {
        menu = { auto_show = false },
        documentation = { auto_show = false },
        ghost_text = { enabled = false },
      },
      keymap = {
        -- First press opens the menu, later presses move down it.
        ["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
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
