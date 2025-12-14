-- ui.lua
-- Ultimate UI Layer for CTF / CP / Red Team / Bug Bounty
-- Includes Dashboard, Hex Editor, Todo Highlighting, and Visual Aids
-- No conflicts, optimized for performance.

return {

  ------------------------------------------------------------
  -- 1. Noice: Modern UI for messages, cmdline & popupmenu
  ------------------------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.routes = opts.routes or {}

      -- Filter out spammy notification messages
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      table.insert(opts.routes, {
        filter = {
          event = "msg_show",
          find = "written",
        },
        opts = { skip = true },
      })

      -- Route notifications to split when focused (prevents overlay blocking code)
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", { callback = function() focused = true end })
      vim.api.nvim_create_autocmd("FocusLost", { callback = function() focused = false end })

      table.insert(opts.routes, 1, {
        filter = { cond = function() return not focused end },
        view = "notify_send",
        opts = { stop = false },
      })

      -- Enable useful presets
      opts.presets = opts.presets or {}
      opts.presets.lsp_doc_border = true
      opts.presets.bottom_search = true
      opts.presets.command_palette = true
    end,
  },

  ------------------------------------------------------------
  -- 2. Notifications: Sleek & Transparent
  ------------------------------------------------------------
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_width = 80,
      render = "wrapped-compact",
      stages = "static", -- Static is faster/snappier than fade
    },
  },

  ------------------------------------------------------------
  -- 3. Snacks: Tools & Utils (Dashboard Disabled)
  ------------------------------------------------------------
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = { enabled = false }, -- DISABLED to use Alpha-nvim
      bigfile = { enabled = true },
      explorer = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
      words = { enabled = true },
    },
  },

  ------------------------------------------------------------
  -- 4. Bufferline: Tabs with DevIcons
  ------------------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
      { "<leader>bp", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
    },
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
      },
    },
  },

  ------------------------------------------------------------
  -- 5. Incline: Floating Filename (Theme Independent)
  ------------------------------------------------------------
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1200,
    config = function()
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then filename = "[No Name]" end
          
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified and { " ● ", guifg = "#d19a66" } or ""

          return {
            { (ft_icon or "") .. " ", guifg = ft_color, guibg = "#282c34" },
            { filename, gui = "bold", guifg = "#abb2bf", guibg = "#282c34" },
            modified,
          }
        end,
      })
    end,
  },

  ------------------------------------------------------------
  -- 6. Lualine: Statusline + Macro Recording
  ------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      
      -- Helper: Show recording status (Critical for CP speed)
      local function show_macro_recording()
        local recording_register = vim.fn.reg_recording()
        if recording_register == "" then
            return ""
        else
            return "  @" .. recording_register
        end
      end

      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          readonly_icon = " 󰌾 ",
        }),
      }
      
      -- Add Macro status to section X
      table.insert(opts.sections.lualine_x, 1, {
        show_macro_recording,
        color = { fg = "#ff9e64", gui = "bold" },
      })
    end,
  },

  ------------------------------------------------------------
  -- 7. Zen Mode & Twilight: Focus Mode
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
        twilight = { enabled = true },
      },
    },
  },
  {
    "folke/twilight.nvim",
    opts = { dimming = { alpha = 0.5 } },
  },

  ------------------------------------------------------------
  -- 8. Hex Editor (Essential for CTF/Reverse Engineering)
  ------------------------------------------------------------
  {
    "RaafatTurki/hex.nvim",
    cmd = { "HexDump", "HexAssemble", "HexToggle" },
    config = function()
      require("hex").setup()
    end,
    keys = {
      { "<leader>h", "<cmd>HexToggle<cr>", desc = "Toggle Hex View" },
    },
  },

  ------------------------------------------------------------
  -- 9. Todo Comments (Flag FIXME/HACK/TODO)
  ------------------------------------------------------------
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    },
  },

  ------------------------------------------------------------
  -- 10. Colorizer (View Hex Colors for Web Pentest)
  ------------------------------------------------------------
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({ "*", css = { rgb_fn = true }, html = { names = false } })
    end,
  },

  ------------------------------------------------------------
  -- 11. Indent Blankline (Visual Structure)
  ------------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },

  ------------------------------------------------------------
  -- 12. Dashboard (Alpha): Hacker Theme + 12h Clock
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
      dashboard.section.header.val = ascii.get_random_global()
      dashboard.section.header.opts.hl = "AlphaHeader"

      -- 3. Button Helper
      local function button(sc, txt, keybind, keybind_opts)
        local b = dashboard.button(sc, txt, keybind, keybind_opts)
        b.opts.hl = "AlphaButtons"
        b.opts.hl_shortcut = "AlphaShortcut"
        return b
      end

      -- 4. Menu Definition
      dashboard.section.buttons.val = {
        -- Group 1: Files
        { type = "padding", val = 1 },
        { type = "text", val = "───  Files  ───", opts = { hl = "Comment", position = "center" } },
        { type = "padding", val = 1 },
        button("f", "🔍  Find File",          "<cmd>Telescope find_files<cr>"),
        button("n", "📄  New File",           "<cmd>ene <BAR> startinsert<cr>"),
        button("r", "🕒  Recent Files",       "<cmd>Telescope oldfiles<cr>"),
        button("p", "📁  Projects",           "<cmd>Telescope project<cr>"),

        -- Group 2: CTF / Analysis
        { type = "padding", val = 1 },
        { type = "text", val = "───  Analysis & CTF  ───", opts = { hl = "Comment", position = "center" } },
        { type = "padding", val = 1 },
        button("g", "📝  Live Grep (Text)",   "<cmd>Telescope live_grep<cr>"),
        button("x", "🧬  Hex Editor",         "<cmd>HexToggle<cr>"),
        button("d", "🧪  Diagnostics",        "<cmd>Trouble diagnostics toggle<cr>"),
        button("k", "⌨️   Keymaps",            "<cmd>Telescope keymaps<cr>"),

        -- Group 3: System
        { type = "padding", val = 1 },
        { type = "text", val = "───  System  ───", opts = { hl = "Comment", position = "center" } },
        { type = "padding", val = 1 },
        button("z", "💻  Terminal",           "<cmd>lua Snacks.terminal.toggle()<cr>"),
        button("s", "💾  Restore Session",    [[<cmd>lua require("persistence").load()<cr>]]),
        button("m", "🛠️   Mason (Tools)",      "<cmd>Mason<cr>"),
        button("l", "📦  Lazy Plugins",       "<cmd>Lazy<cr>"),
        button("q", "🚪  Quit",               "<cmd>qa<cr>"),
      }

      -- 5. Footer: Stats with 12-hour Clock
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        local version = vim.version()
        local v_str = " v" .. version.major .. "." .. version.minor .. "." .. version.patch
        local date = os.date("%d-%m-%Y")
        -- 12-Hour Format Fix:
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

      -- 6. Layout
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        dashboard.section.footer,
      }

      -- 7. Init & Refresh Hook
      alpha.setup(dashboard.config)
      vim.api.nvim_create_autocmd("DirChanged", {
        pattern = "*",
        group = vim.api.nvim_create_augroup("AlphaFooterUpdate", { clear = true }),
        callback = function() pcall(require("alpha").redraw) end,
      })
    end,
  },
}
