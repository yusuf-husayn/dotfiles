-- colorscheme.lua
-- Stable colorscheme configuration
-- Optimized for CTF, CP, Red Teaming, Pentesting, Networking
-- No flicker. No override. LazyVim-safe.

return {

  {
    "craftzdog/solarized-osaka.nvim",

    -- Colorscheme must load early
    lazy = false,
    priority = 1000,

    opts = {
      transparent = true,

      terminal_colors = true,

      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = { bold = true },
        variables = {},
        types = { bold = true },
      },

      sidebars = {
        "qf",
        "help",
        "terminal",
        "packer",
        "neo-tree",
      },

      on_highlights = function(hl, c)
        -- Diagnostics
        hl.DiagnosticError = { fg = c.red500 }
        hl.DiagnosticWarn  = { fg = c.orange500 }
        hl.DiagnosticInfo  = { fg = c.blue500 }
        hl.DiagnosticHint  = { fg = c.cyan500 }

        -- Security / logs
        hl.ErrorMsg        = { fg = c.red500, bold = true }
        hl.WarningMsg      = { fg = c.orange500, bold = true }

        -- Cursor and selection
        hl.CursorLine      = { bg = c.base02 }
        hl.Visual          = { bg = c.base03 }

        -- Search
        hl.Search          = { fg = c.base01, bg = c.yellow500 }
        hl.IncSearch       = { fg = c.base01, bg = c.orange500 }

        -- Line numbers
        hl.LineNr          = { fg = c.base04 }
        hl.CursorLineNr    = { fg = c.yellow500, bold = true }

        -- Git
        hl.DiffAdd         = { fg = c.green500 }
        hl.DiffDelete      = { fg = c.red500 }
        hl.DiffChange      = { fg = c.blue500 }
      end,
    },

    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },

}
