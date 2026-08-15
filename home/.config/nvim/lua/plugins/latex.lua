return {
  {
    "lervag/vimtex",
    -- VimTeX 2.18+ requires Neovim 0.12.4; Homebrew currently provides 0.11.
    tag = "v2.17",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_automatic = 1
      vim.g.vimtex_view_skim_activate = 0
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_no_select = 1
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1,
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      -- Start the continuous compiler as soon as VimTeX initializes a project.
      local group = vim.api.nvim_create_augroup("latex_live_preview", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "VimtexEventInitPost",
        callback = function()
          vim.cmd("VimtexCompile")
        end,
      })

      -- Overleaf-like autosave: after a short pause, save the TeX buffer.
      -- latexmk notices the write, recompiles, and Skim reloads the PDF.
      local save_timers = {}
      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = group,
        pattern = "*.tex",
        callback = function(args)
          local existing = save_timers[args.buf]
          if existing then
            existing:stop()
            existing:close()
          end

          save_timers[args.buf] = vim.defer_fn(function()
            save_timers[args.buf] = nil
            if vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].modified then
              vim.api.nvim_buf_call(args.buf, function()
                vim.cmd("silent update")
              end)
            end
          end, 800)
        end,
      })
    end,
    keys = {
      { "<leader>cp", "<cmd>VimtexView<cr>", ft = "tex", desc = "LaTeX PDF Preview" },
    },
  },
}
