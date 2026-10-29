-- LeetCode-style diagnostics: problems are only underlined. Read a message on
-- demand with K (on the squiggle), ]d / [d (jump and show), or <leader>cd.
-- The statusline still counts errors and warnings.
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = false,
        signs = false,
      })

      -- K shows the problem under the cursor if there is one, otherwise the
      -- usual docs, like hovering a squiggle in an IDE.
      table.insert(opts.servers["*"].keys, {
        "K",
        function()
          if not vim.diagnostic.open_float({ scope = "cursor" }) then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Hover / Diagnostic",
      })
    end,
  },
}
