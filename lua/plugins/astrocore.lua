-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = false, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    diagnostics = {
      float = false,
      virtual_lines = false,
      virtual_text = false,
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    autocmds = {
      restore_session = {
        {
          event = "VimEnter",
          desc = "Restore previous directory session if neovim opened with no arguments",
          nested = true, -- trigger other autocommands as buffers open
          callback = function()
            -- Only load the session if nvim was started with no args
            if vim.fn.argc(-1) == 0 then
              -- try to load a directory session using the current working directory
              require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            end
          end,
        },
      },
    },
    -- passed to `vim.filetype.add`
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        shiftwidth = 4,
        tabstop = 4,
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        ["<Leader>O"] = { desc = "Obsidian" },
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["gra"] = false,
        ["grn"] = false,
        ["grr"] = false,
        ["gri"] = false,
        ["gO"] = false,

        ["<Leader>a"] = { function() vim.lsp.buf.hover() end, desc = "Hover" },
        ["<Leader>Al"] = { ":AstroReload<cr>", desc = "Astro Reload" },
        ["<Leader>w"] = { function() vim.lsp.buf.code_action() end, desc = "Code action" },
        ["<Leader>]"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<Leader>["] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["gbc"] = false,
        ["gb"] = { "<C-o>", desc = "Go back" },
        ["gf"] = { "<C-i>", desc = "Go forward" },
        ["gr"] = { function() require("snacks.picker").lsp_references() end, desc = "GoTo References" },
        ["gd"] = { function() require("snacks.picker").lsp_definitions() end, desc = "GoTo Definitions" },
        ["gD"] = { function() require("snacks.picker").lsp_declarations() end, desc = "GoTo Declarations" },
        ["gy"] = { function() require("snacks.picker").lsp_type_definitions() end, desc = "GoTo Type Definitions" },
        ["gI"] = { function() require("snacks.picker").lsp_implementations() end, desc = "GoTo Implementations" },
        ["gs"] = { function() require("snacks.picker").lsp_symbols() end, desc = "GoTo Symbols" },
        ["gS"] = { function() require("snacks.picker").lsp_workspace_symbols() end, desc = "GoTo Workspace Symbols" },
        ["gq"] = { function() require("snacks.picker").qflist() end, desc = "GoTo Quickfix list" },
        ["<Leader>fj"] = { function() require("snacks.picker").jumps() end, desc = "Find jumps" },
        ["<Leader>fi"] = { function() require("snacks.picker").diagnostics() end, desc = "Find diagnostics" },

        -- mappings seen under group name "buffer"
        ["<leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "close buffer from tabline",
        },
        ["<Leader>c"] = {
          function()
            local bufs = vim.fn.getbufinfo { buflisted = 1 }
            require("astrocore.buffer").close(0)
            if not bufs[2] then require("snacks").dashboard() end
          end,
          desc = "Close buffer",
        },
        ["<Leader>lp"] = { ":Hypersonic<cr>", desc = "Explain Regex" },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        ["<Leader>uz"] = { ":ZenMode<cr>", desc = "Toggle zen mode" },
      },
      v = {

        ["<Leader>lp"] = { ":Hypersonic<cr>", desc = "Explain Regex" },
      },
    },
    rooter = {
      -- list of detectors in order of prevalence, elements can be:
      --   "lsp" : lsp detection
      --   string[] : a list of directory patterns to look for
      --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
      enabled = true,
      detector = {
        { "~/repos/*", ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
        { "lua", "MakeFile", "package.json", ".venv", "pyproject.toml", "go.sum" }, -- lastly check for known project root files
        "lsp", -- highest priority is getting workspace from running language servers
      },
      -- ignore things from root detection
      ignore = {
        servers = {}, -- list of language server names to ignore (Ex. { "efm" })
        dirs = {}, -- list of directory patterns (Ex. { "~/.cargo/*" })
      },
      autochdir = true,
      -- scope of working directory to change ("global"|"tab"|"win")
      scope = "tab",
      -- show notification on every working directory change
      notify = true,
    },
  },
}
