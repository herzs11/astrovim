return {
  "folke/snacks.nvim",
  specs = {
    {
      "AstroNvim/astroui",
      ---@param opts AstroUIOpts
      opts = function(_, opts)
        if not opts.highlights then opts.highlights = {} end
        local original_init = opts.highlights.init
        local init_function
        if type(original_init) == "table" then
          init_function = function() return original_init end
        else
          init_function = original_init
        end
        opts.highlights.init = require("astrocore").patch_func(init_function, function(orig, colors_name)
          local highlights = orig(colors_name) or {}

          local get_hlgroup = require("astroui").get_hlgroup
          -- get highlights from highlight groups
          local bg = get_hlgroup("Normal").bg
          local bg_alt = get_hlgroup("Visual").bg
          local green = get_hlgroup("String").fg
          local red = get_hlgroup("Error").fg
          local blue = get_hlgroup("Question").fg
          -- return a table of highlights for telescope based on
          -- colors gotten from highlight groups
          highlights.SnacksPickerBorder = { fg = bg_alt, bg = bg }
          highlights.SnacksPickerPreviewBorder = { fg = blue, bg = bg }
          highlights.SnacksPickerPreview = { bg = bg }
          highlights.SnacksPickerPreviewTitle = { fg = bg, bg = blue }
          highlights.SnacksPickerBoxBorder = { fg = blue, bg = bg }
          highlights.SnacksPickerInputBorder = { fg = blue, bg = bg }
          highlights.SnacksPickerInputSearch = { fg = blue, bg = bg }
          highlights.SnacksPickerListBorder = { fg = bg, bg = bg }
          highlights.SnacksPickerList = { bg = bg }
          highlights.SnacksPickerListTitle = { fg = blue, bg = bg }
          return highlights
        end)
      end,
    },
  },
  opts = {
    indent = {
      enabled = true,
      chunk = {
        enabled = true,
        char = {
          corner_top = "╭",
          corner_bottom = "╰",
          horizontal = "─",
          vertical = "│",
          arrow = ">",
        },
      },
    },
    picker = {
      win = {
        input = {
          keys = {
            ["<a-s>"] = { "flash", mode = { "n", "i" } },
            ["s"] = { "flash" },
          },
        },
      },
      actions = {
        flash = function(picker)
          require("flash").jump {
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
              mode = "search",
              exclude = {
                function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list" end,
              },
            },
            action = function(match)
              local idx = picker.list:row2idx(match.pos[1])
              picker.list:_move(idx, true, true)
            end,
          }
        end,
      },
    },
  },
}
