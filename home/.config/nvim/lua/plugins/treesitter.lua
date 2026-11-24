return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Python uses the simpler LeetCode-style rule in after/indent/python.lua.
      indent = { disable = { "python" } },
    },
  },
}
