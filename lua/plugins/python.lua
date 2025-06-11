local ts_utils = require "nvim-treesitter.ts_utils"

toggle_fstring = function()
  local winnr = 0
  local cursor = vim.api.nvim_win_get_cursor(winnr)
  local node = ts_utils.get_node_at_cursor()

  while (node ~= nil) and (node:type() ~= "string") do
    node = node:parent()
  end
  if node == nil then
    print "f-string: not in string node :("
    return
  end

  local srow, scol, ecol, erow = ts_utils.get_vim_range { node:range() }
  vim.fn.setcursorcharpos(srow, scol)
  local char = vim.api.nvim_get_current_line():sub(scol, scol)
  local is_fstring = (char == "f")

  if is_fstring then
    vim.cmd "normal x"
    -- if cursor is in the same line as text change
    if srow == cursor[1] then
      cursor[2] = cursor[2] - 1 -- negative offset to cursor
    end
  else
    vim.cmd "normal if"
    -- if cursor is in the same line as text change
    if srow == cursor[1] then
      cursor[2] = cursor[2] + 1 -- positive offset to cursor
    end
  end
  vim.api.nvim_win_set_cursor(winnr, cursor)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "py" },
  callback = function()
    vim.schedule(function() vim.keymap.set("n", "F", toggle_fstring, { noremap = true, buffer = true }) end)
  end,
})

return {
  { import = "astrocommunity.pack.python" },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "ruff" })
    end,
  },
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
        ruff = { on_attach = function(client) client.server_capabilities.hoverProvider = false end },
        basedpyright = {
          before_init = function(_, c)
            if not c.settings then c.settings = {} end
            if not c.settings.python then c.settings.python = {} end
            c.settings.python.pythonPath = vim.fn.exepath "python"
          end,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "none",
                  reportUnusedFunction = "information",
                  reportUnusedVariable = "information",
                  --   reportGeneralTypeIssues = false,
                  --   reportOptionalMemberAccess = "none",
                  --   reportOptionalSubscript = false,
                  --   reportPrivateImportUsage = false,
                  --   reportArgumentType = "hint",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(
        function(v) return not vim.tbl_contains({ "black", "isort" }, v) end,
        opts.ensure_installed
      )
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "ruff" })
      opts.ensure_installed = vim.tbl_filter(
        function(v) return not vim.tbl_contains({ "black", "isort" }, v) end,
        opts.ensure_installed
      )
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      opts.capabilities = require("blink.cmp").get_lsp_capabilities(opts.capabilities)

      -- disable AstroLSP signature help if `blink.cmp` is providing it
      local blink_opts = require("astrocore").plugin_opts "blink.cmp"
      if vim.tbl_get(blink_opts, "signature", "enabled") == true then
        if not opts.features then opts.features = {} end
        opts.features.signature_help = false
      end
    end,
  },
}
