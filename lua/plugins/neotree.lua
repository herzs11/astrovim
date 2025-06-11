return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    -- Others dependencies
    "saifulapm/neotree-file-nesting-config", -- add plugin as dependency. no need any other config or setup call
  },
  opts = {
    -- recommanded config for better UI
    hide_root_node = true,
    retain_hidden_root_indent = true,
    filesystem = {
      components = {
        harpoon_index = function(config, node, _)
          local harpoon_list = require("harpoon"):list()
          local path = node:get_id()
          local harpoon_key = vim.uv.cwd()

          for i, item in ipairs(harpoon_list.items) do
            local value = item.value
            if string.sub(item.value, 1, 1) ~= "/" then value = harpoon_key .. "/" .. item.value end

            if value == path then
              vim.print(path)
              return {
                text = string.format(" ⥤ %d", i), -- <-- Add your favorite harpoon like arrow here
                highlight = config.highlight or "NeoTreeDirectoryIcon",
              }
            end
          end
          return {}
        end,
      },
      filtered_items = {
        show_hidden_count = false,
        visible = true,
        never_show = {
          ".DS_Store",
        },
      },
      renderers = {
        file = {
          { "icon" },
          { "name", use_git_status_colors = true },
          { "harpoon_index" }, --> This is what actually adds the component in where you want it
          { "diagnostics" },
          { "git_status", highlight = "NeoTreeDimText" },
        },
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function() vim.api.nvim_set_hl(0, "MiniAnimateCursor", { blend = 100, force = true }) end,
      },
      {
        event = "neo_tree_buffer_leave",
        handler = function() vim.api.nvim_set_hl(0, "MiniAnimateCursor", { blend = 0, force = true }) end,
      },
      {
        event = "file_open_requested",
        handler = function()
          -- auto close
          -- vim.cmd("Neotree close")
          -- OR
          require("neo-tree.command").execute { action = "close" }
        end,
      },
    },
  },
  config = function(_, opts)
    -- Adding rules from plugin
    opts.nesting_rules = require("neotree-file-nesting-config").nesting_rules
    require("neo-tree").setup(opts)
  end,
}
