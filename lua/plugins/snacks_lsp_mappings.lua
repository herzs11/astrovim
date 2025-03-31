return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    if opts.mappings.n.gd then opts.mappings.n.gd[1] = function() require("snacks.picker").lsp_definitions() end end
    if opts.mappings.n.gI then opts.mappings.n.gI[1] = function() require("snacks.picker").lsp_implementations() end end
    if opts.mappings.n.gy then
      opts.mappings.n.gy[1] = function() require("snacks.picker").lsp_type_definitions() end
    end
    if opts.mappings.n.gs then
      opts.mappings.n.gs[1] = function() require("snacks.picker").lsp_workspace_symbols() end
    end
    if opts.mappings.n.gr then opts.mappings.n.gr[1] = function() require("snacks.picker").lsp_references() end end
  end,
}
