return {
  "cbochs/portal.nvim",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>i"] = { "<Cmd>Portal jumplist backward<CR>", desc = "Portal Jump backward" },
            ["<Leader>I"] = { "<Cmd>Portal jumplist forward<CR>", desc = "Portal Jump forward" },
          },
        },
      },
    },
  },
  cmd = "Portal",
  opts = {},
}
