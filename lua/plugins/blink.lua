return { -- override blink.cmp plugin
  "Saghen/blink.cmp",
  opts = {
    sources = {
      providers = {
        path = { score_offset = 3 },
        lsp = { score_offset = 0 },
        snippets = { score_offset = -1 },
        buffer = { score_offset = -3 },
      },
    },
    enabled = function() return not vim.tbl_contains({ "markdown" }, vim.bo.filetype) end,
    keymap = {
      ["<Tab>"] = {},
    },
  },
}
