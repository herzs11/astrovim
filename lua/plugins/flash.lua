return {
  "folke/flash.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          x = {
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["R"] = {
              function() require("flash").treesitter_search() end,
              desc = "Treesitter Search",
            },
            ["S"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
          },
          o = {
            ["r"] = {
              function() require("flash").remote() end,
              desc = "Remote Flash",
            },
            ["R"] = {
              function() require("flash").treesitter_search() end,
              desc = "Treesitter Search",
            },
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["S"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
          },
          n = {
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["S"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
            ["<leader>j"] = {
              function()
                require("flash").jump {
                  search = { mode = "search", max_length = 0 },
                  label = { after = { 0, 0 } },
                  pattern = "^",
                }
              end,
              desc = "Flash Line",
            },
          },
        },
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      optional = true,
      opts = function(_, opts)
        local function flash(prompt_bufnr)
          require("flash").jump {
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
              mode = "search",
              exclude = {
                function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults" end,
              },
            },
            action = function(match)
              local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              picker:set_selection(match.pos[1] - 1)
            end,
          }
        end
        opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
          mappings = {
            n = { s = flash },
            i = { ["<c-s>"] = flash },
          },
        })
      end,
    },
  },
  opts = {
    modes = {
      char = {
        jump_labels = false,
      },
    },
  },
}
