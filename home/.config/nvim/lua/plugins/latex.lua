return {
  {
    "lervag/vimtex",
    -- VimTeX 2.18+ requires Neovim 0.12.4; Homebrew currently provides 0.11.
    tag = "v2.17",
    lazy = false,
    init = function()
      -- GUI-launched Neovim does not always inherit the interactive shell PATH
      -- (e.g. Kitty's `launch nvim .` mapping), and then latexmk isn't found.
      for _, dir in ipairs({ "/Library/TeX/texbin", vim.fn.expand("$HOME/.local/bin") }) do
        if not vim.env.PATH:find(dir, 1, true) then
          vim.env.PATH = dir .. ":" .. vim.env.PATH
        end
      end

      -- Skim, because VimTeX can only make MuPDF reload through xdotool (X11),
      -- so on macOS MuPDF never showed the new PDF. Skim reloads after every
      -- build without taking focus, and `sync` scrolls it to the cursor's line.
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_automatic = 1
      -- Only pop the quickfix list open for errors; warnings are still in it
      -- (\le or <leader>xq), they just don't interrupt every rebuild.
      vim.g.vimtex_quickfix_open_on_warning = 0
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
          -- The viewer only opens by itself after a build, and latexmk skips the
          -- build when the PDF is already up to date, so open it now.
          if vim.fn.filereadable(vim.fn.eval("b:vimtex.viewer.out()")) == 1 then
            vim.cmd("VimtexView")
          end
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
