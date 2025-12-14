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
    "MaximilianLloyd/ascii.nvim",   -- Random ASCII Headers
    "MunifTanjim/nui.nvim",         -- UI Component Library
    "nvim-tree/nvim-web-devicons",  -- Icons
  },
  config = function()
    -- 1. Safety Checks (Prevent crashes if dependencies are missing)
    local ok_alpha, alpha = pcall(require, "alpha")
    local ok_dash, dashboard = pcall(require, "alpha.themes.dashboard")
    local ok_ascii, ascii = pcall(require, "ascii")

    if not (ok_alpha and ok_dash and ok_ascii) then
      return
    end

    -- 2. Header: Dynamic Hacker Art
    -- Fetches random ASCII art from the global pool to keep startup fresh
    dashboard.section.header.val = ascii.get_random_global()
    dashboard.section.header.opts.hl = "AlphaHeader"

    -- 3. Button Generator Helper
    local function button(sc, txt, keybind, keybind_opts)
      local b = dashboard.button(sc, txt, keybind, keybind_opts)
      b.opts.hl = "AlphaButtons"
      b.opts.hl_shortcut = "AlphaShortcut"
      return b
    end

    -- 4. Menu Definition
    dashboard.section.buttons.val = {
      -- Group 1: Core File Operations
      { type = "padding", val = 1 },
      { type = "text", val = "───  Files  ───", opts = { hl = "Comment", position = "center" } },
      { type = "padding", val = 1 },
      button("f", "🔍  Find File",          "<cmd>Telescope find_files<cr>"),
      button("n", "📄  New File",           "<cmd>ene <BAR> startinsert<cr>"),
      button("r", "🕒  Recent Files",       "<cmd>Telescope oldfiles<cr>"),
      button("p", "📁  Projects",           "<cmd>Telescope project<cr>"), -- Useful for switching CP/CTF folders

      -- Group 2: Analysis & CTF Tools
      { type = "padding", val = 1 },
      { type = "text", val = "───  Analysis & CTF  ───", opts = { hl = "Comment", position = "center" } },
      { type = "padding", val = 1 },
      button("g", "📝  Live Grep (Text)",   "<cmd>Telescope live_grep<cr>"),
      button("x", "🧬  Hex Editor",         "<cmd>HexToggle<cr>"),
      button("d", "🧪  Diagnostics",        "<cmd>Trouble diagnostics toggle<cr>"),
      button("k", "⌨️   Keymaps",            "<cmd>Telescope keymaps<cr>"),

      -- Group 3: Terminal & Version Control
      { type = "padding", val = 1 },
      { type = "text", val = "───  Shell & Git  ───", opts = { hl = "Comment", position = "center" } },
      { type = "padding", val = 1 },
      button("z", "💻  Terminal",           "<cmd>lua Snacks.terminal.toggle()<cr>"),
      button("v", "🌳  LazyGit",            "<cmd>lua Snacks.lazygit.toggle()<cr>"),

      -- Group 4: System & Configuration
      { type = "padding", val = 1 },
      { type = "text", val = "───  System  ───", opts = { hl = "Comment", position = "center" } },
      { type = "padding", val = 1 },
      button("s", "💾  Restore Session",    [[<cmd>lua require("persistence").load()<cr>]]),
      button("m", "🛠️   Mason (LSP/Tools)", "<cmd>Mason<cr>"),
      button("l", "📦  Lazy Plugins",       "<cmd>Lazy<cr>"),
      button("h", "🏥  Check Health",       "<cmd>checkhealth<cr>"),
      button("q", "🚪  Quit",               "<cmd>qa<cr>"),
    }

    -- 5. Enhanced Footer: Stats, Time, & Context
    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      local version = vim.version()
      local v_str = " v" .. version.major .. "." .. version.minor .. "." .. version.patch
      local date = os.date("%d-%m-%Y")
      local time = os.date("%I:%M %p")
      local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")

      return {
        " ",
        "⚡ Neovim" .. v_str .. " loaded " .. stats.count .. " plugins in " .. ms .. "ms",
        "📅 " .. date .. "  ⏰ " .. time,
        "📂 " .. cwd,
        " ",
        "🚩 Happy Hacking & Good Luck! 🚩"
      }
    end
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- 6. Layout Composition
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 2 },
      dashboard.section.footer,
    }

    -- 7. Initialize
    alpha.setup(dashboard.config)

    -- 8. Auto-Refresh Footer on Directory Change
    -- Keeps the CWD in the footer updated if you change folders inside Neovim
    vim.api.nvim_create_autocmd("DirChanged", {
      pattern = "*",
      group = vim.api.nvim_create_augroup("AlphaFooterUpdate", { clear = true }),
      callback = function()
        pcall(require("alpha").redraw)
      end,
    })
  end,
},
  }
