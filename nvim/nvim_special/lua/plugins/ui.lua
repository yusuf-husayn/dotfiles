-- ui.lua
-- Unified UI layer
-- CTF / CP / Red Team / Bug Bounty / Pentesting / Networking
-- Lazy.nvim + LazyVim safe
-- No missing repos, no invalid requires, no conflicts

return {

------------------------------------------------------------
-- Noice: messages, cmdline, LSP UI
------------------------------------------------------------
{
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.routes = opts.routes or {}

    -- Drop useless notifications
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        find = "No information available",
      },
      opts = { skip = true },
    })

    -- Send notifications when unfocused
    local focused = true
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function() focused = true end,
    })
    vim.api.nvim_create_autocmd("FocusLost", {
      callback = function() focused = false end,
    })

    table.insert(opts.routes, 1, {
      filter = { cond = function() return not focused end },
      view = "notify_send",
      opts = { stop = false },
    })

    opts.commands = {
      all = {
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
    }

    opts.presets = opts.presets or {}
    opts.presets.lsp_doc_border = true

    -- Markdown rendering inside Noice
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(ev)
        vim.schedule(function()
          pcall(require, "noice.text.markdown").keys(ev.buf)
        end)
      end,
    })
  end,
},

------------------------------------------------------------
-- Notifications
------------------------------------------------------------
{
  "rcarriga/nvim-notify",
  opts = {
    timeout = 4000,
    stages = "fade",
    max_width = 80,
    max_height = 20,
  },
},

------------------------------------------------------------
-- Snacks (correct repo)
------------------------------------------------------------
{
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = false, -- IMPORTANT: disable Snacks dashboard
    },
    bigfile = { enabled = true },
    explorer = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    notifier = { enabled = true },
    input = { enabled = true },
    picker = { enabled = false }, -- keep Telescope
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    image = { enabled = false }, -- safe for terminals / SSH
  },
},


------------------------------------------------------------
-- Bufferline (tabs, not buffers)
------------------------------------------------------------
{
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
  },
  opts = {
    options = {
      mode = "tabs",
      show_buffer_close_icons = false,
      show_close_icon = false,
      diagnostics = "nvim_lsp",
    },
  },
},

------------------------------------------------------------
-- Filename bar (Incline)
------------------------------------------------------------
{
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 1200,
  dependencies = {
    "craftzdog/solarized-osaka.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local colors = require("solarized-osaka.colors").setup()

    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = {
            guibg = colors.magenta500,
            guifg = colors.base04,
          },
          InclineNormalNC = {
            guibg = colors.base03,
            guifg = colors.violet500,
          },
        },
      },
      window = { margin = { vertical = 0, horizontal = 1 } },
      hide = { cursorline = true },
      render = function(props)
        local name = vim.fn.fnamemodify(
          vim.api.nvim_buf_get_name(props.buf),
          ":t"
        )
        if vim.bo[props.buf].modified then
          name = "[+] " .. name
        end
        local icon, color =
          require("nvim-web-devicons").get_icon_color(name)
        return { { icon, guifg = color }, { " " }, { name } }
      end,
    })
  end,
},

------------------------------------------------------------
-- Statusline
------------------------------------------------------------
{
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local LazyVim = require("lazyvim.util")
    opts.sections.lualine_c[4] = {
      LazyVim.lualine.pretty_path({
        length = 0,
        relative = "cwd",
        modified_hl = "MatchParen",
        directory_hl = "",
        filename_hl = "Bold",
        modified_sign = "",
        readonly_icon = " 󰌾 ",
      }),
    }
  end,
},

------------------------------------------------------------
-- Zen mode (focus during contests / audits)
------------------------------------------------------------
{
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
  opts = {
    plugins = {
      gitsigns = true,
      tmux = true,
      kitty = { enabled = false },
    },
  },
},

------------------------------------------------------------
-- Markdown renderer (off by default)
------------------------------------------------------------
{
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = false,
},

------------------------------------------------------------
-- Dashboard (Alpha)
------------------------------------------------------------
{
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {
    "MaximilianLloyd/ascii.nvim",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local ok1, alpha = pcall(require, "alpha")
    local ok2, dashboard = pcall(require, "alpha.themes.dashboard")
    local ok3, ascii = pcall(require, "ascii")
    if not (ok1 and ok2 and ok3) then
      return
    end

    dashboard.section.header.val = ascii.get_random_global()
    alpha.setup(dashboard.opts)
  end,
},

}
