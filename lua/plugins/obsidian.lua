return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  ft = "markdown",
  keys = {
    {
      "<leader>Ob",
      "<cmd>:ObsidianBacklinks<cr>",
      desc = "Getting a location list of references for current buffers",
    },
    {
      "<leader>Od",
      "<cmd>:ObsidianToday<cr>",
      desc = "Create Daily Note",
    },
    {
      "<leader>Oy",
      "<cmd>:ObsidianYesterday<cr>",
      desc = "Open Yesterday's Daily Note",
    },
    {
      "<leader>Oo",
      "<cmd>:ObsidianOpen<cr>",
      desc = "Open Note in Obsidian App",
    },
    {
      "<leader>On",
      "<cmd>:ObsidianNew<cr>",
      desc = "Create a New Note",
    },
    {
      "<leader>Os",
      "<cmd>:ObsidianSearch<cr>",
      desc = "Search Notes in your vault",
    },
    {
      "<leader>Of",
      "<cmd>:ObsidianQuickSwitch<cr>",
      desc = "Quick Switch to another Note in your vault",
    },
    {
      "<leader>Oll",
      "<cmd>:ObsidianLink<cr>",
      desc = "To link an in-line visual selection of text to a note.",
    },
    {
      "<leader>Oln",
      "<cmd>:ObsidianLinkNew<cr>",
      desc = "To create a new note and link it to an in-line visual selection of text.",
    },
    {
      "<leader>Olf",
      "<cmd>:ObsidianFollowLink<cr>",
      desc = "To follow a note reference under the cursor.",
    },
    {
      "<leader>OT",
      "<cmd>:ObsidianTemplate<cr>",
      desc = "To insert a template from the templates folder",
    },
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- Optional, for completion.
    "hrsh7th/nvim-cmp",

    -- Optional, for search and quick-switch functionality.
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    dir = "~/Documents/MORSE/", -- no need to call 'vim.fn.expand' here

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "Dailies/",
      -- Optional, if you want to change the date format for daily notes.
      date_format = "%Y-%m-%d",
      template = "daily.md",
    },
    completion = {
      nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
      blink = false,
    },

    -- Optional, set to true if you don't want Obsidian to manage frontmatter.
    disable_frontmatter = false,

    -- Optional, alternatively you can customize the frontmatter data.
    note_frontmatter_func = function(note)
      -- This is equivalent to the default frontmatter function.
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function() return require("obsidian").util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function() return require("obsidian").util.toggle_checkbox() end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function() return require("obsidian").util.smart_action() end,
        opts = { buffer = true, expr = true },
      },
    },

    -- Optional, for templates (see below).
    templates = {
      subdir = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-_]", "")
    end,
    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart { "open", url } -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,

    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = false,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = false,

    -- Optional, by default commands like `:ObsidianSearch` will attempt to use
    -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
    -- first one they find. By setting this option to your preferred
    -- finder you can attempt it first. Note that if the specified finder
    -- is not installed, or if it the command does not support it, the
    -- remaining finders will be attempted in the original order.
    finder = "telescope.nvim",
  },
}
