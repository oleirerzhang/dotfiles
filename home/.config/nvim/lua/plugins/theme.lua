-- Start page art. Trailing spaces don't need to line up here: the lines are
-- padded to one width below, because the dashboard centres each line on its own.
local header = [[
                                    ,-,
   *        .         *            /.(     .
       .          .          .     \ {
  .          /\        *            `-`
            /  \   /\        .    /\      *
     /\    /    \ /  \     /\    /  \
    /  \  /      V    \   /  \  /    \
   /    \/             \_/    \/      \
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 ██████╗ ██╗     ██╗██╗   ██╗███████╗██████╗
██╔═══██╗██║     ██║██║   ██║██╔════╝██╔══██╗
██║   ██║██║     ██║██║   ██║█████╗  ██████╔╝
██║   ██║██║     ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗
╚██████╔╝███████╗██║ ╚████╔╝ ███████╗██║  ██║
 ╚═════╝ ╚══════╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝]]

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      -- Let pop-ups share Kitty's transparent, blurred background, with line borders.
      float = {
        transparent = true,
        solid = false,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      -- Hover docs (K) and signature help are borderless by default.
      presets = { lsp_doc_border = true },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local lines = vim.split(header, "\n")
      local width = 0
      for _, line in ipairs(lines) do
        width = math.max(width, vim.api.nvim_strwidth(line))
      end
      for i, line in ipairs(lines) do
        lines[i] = line .. string.rep(" ", width - vim.api.nvim_strwidth(line))
      end
      opts.dashboard.preset.header = table.concat(lines, "\n")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
