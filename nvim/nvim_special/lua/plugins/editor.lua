-- editor.lua
-- Editor/UI plugins
-- Optimized for CTF, CP, Red Teaming, Pentesting, Networking
-- Stable. Defensive. No conflicts.

return {

------------------------------------------------------------
-- Flash navigation (disabled safely)
------------------------------------------------------------
{
  "folke/flash.nvim",
  enabled = false,
},

------------------------------------------------------------
-- Highlight colors (CSS, config, payloads)
------------------------------------------------------------
{
  "brenoprata10/nvim-highlight-colors",
  event = "BufReadPre",
  opts = {
    render = "background",
    enable_hex = true,
    enable_short_hex = true,
    enable_rgb = true,
    enable_hsl = true,
    enable_hsl_without_function = true,
    enable_ansi = true,
    enable_var_usage = true,
    enable_tailwind = true,
  },
},

------------------------------------------------------------
-- Git utilities
------------------------------------------------------------
{
  "dinhhuy258/git.nvim",
  event = "BufReadPre",
  opts = {
    keymaps = {
      blame = "<leader>gb",
      browse = "<leader>go",
    },
  },
},

------------------------------------------------------------
-- Telescope (core navigation & analysis)
------------------------------------------------------------
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {

    {
      "<leader>ff",
      function()
        pcall(function()
          require("telescope.builtin").find_files({ hidden = true })
        end)
      end,
      desc = "Find files",
    },

    {
      "<leader>fg",
      function()
        pcall(function()
          require("telescope.builtin").live_grep({
            additional_args = { "--hidden" },
          })
        end)
      end,
      desc = "Live grep",
    },

    {
      "<leader>fb",
      function()
        pcall(function()
          require("telescope.builtin").buffers()
        end)
      end,
      desc = "Buffers",
    },

    {
      "<leader>fh",
      function()
        pcall(function()
          require("telescope.builtin").help_tags()
        end)
      end,
      desc = "Help",
    },

    {
      "<leader>fd",
      function()
        pcall(function()
          require("telescope.builtin").diagnostics()
        end)
      end,
      desc = "Diagnostics",
    },

    {
      "<leader>fs",
      function()
        pcall(function()
          require("telescope.builtin").treesitter()
        end)
      end,
      desc = "Symbols",
    },

    {
      "<leader>fe",
      function()
        pcall(function()
          require("telescope.builtin").lsp_incoming_calls()
        end)
      end,
      desc = "Incoming calls",
    },

    {
      "<leader>fB",
      function()
        pcall(function()
          local telescope = require("telescope")
          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = vim.fn.expand("%:p:h"),
            hidden = true,
            grouped = true,
            respect_gitignore = false,
            previewer = false,
            initial_mode = "normal",
          })
        end)
      end,
      desc = "File browser",
    },
  },

  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local fb_actions = require("telescope").extensions.file_browser.actions

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      prompt_prefix = "   ",
      selection_caret = "❯ ",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
      },
      wrap_results = true,
      winblend = 0,
      mappings = {
        i = {
          ["<C-u>"] = false,
          ["<C-d>"] = false,
        },
      },
    })

    opts.extensions = {
      file_browser = {
        hijack_netrw = false,
        theme = "dropdown",
        mappings = {
          n = {
            ["N"] = fb_actions.create,
            ["h"] = fb_actions.goto_parent_dir,
            ["<PageUp>"] = actions.preview_scrolling_up,
            ["<PageDown>"] = actions.preview_scrolling_down,
          },
        },
      },
    }

    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "file_browser")
  end,
},

------------------------------------------------------------
-- Buffer cleanup
------------------------------------------------------------
{
  "kazhala/close-buffers.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>bh",
      function()
        pcall(function()
          require("close_buffers").delete({ type = "hidden" })
        end)
      end,
      desc = "Close hidden buffers",
    },
    {
      "<leader>bn",
      function()
        pcall(function()
          require("close_buffers").delete({ type = "nameless" })
        end)
      end,
      desc = "Close nameless buffers",
    },
  },
},

------------------------------------------------------------
-- Completion UI tweaks
------------------------------------------------------------
{
  "saghen/blink.cmp",
  opts = {
    completion = {
      menu = {
        winblend = vim.o.pumblend,
      },
    },
    signature = {
      window = {
        winblend = vim.o.pumblend,
      },
    },
  },
},

}
