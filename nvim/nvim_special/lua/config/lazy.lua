-- lazy.lua
-- Unified, stable plugin bootstrap
-- CTF / CP / Red Team / Pentesting ready
-- No duplicated LSP. No conflicting extras. No unsafe overrides.

------------------------------------------------------------
-- Bootstrap lazy.nvim
------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------
-- Setup
------------------------------------------------------------
require("lazy").setup({

  ----------------------------------------------------------
  -- Plugin specification
  ----------------------------------------------------------
  spec = {

    --------------------------------------------------------
    -- Core LazyVim
    --------------------------------------------------------
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "solarized-osaka",
        news = {
          lazyvim = true,
          neovim = true,
        },
      },
    },

    --------------------------------------------------------
    -- Language support (safe subset, no duplication)
    --------------------------------------------------------
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },

    --------------------------------------------------------
    -- Formatting / linting
    --------------------------------------------------------
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.linting.eslint" },

    --------------------------------------------------------
    -- Utilities
    --------------------------------------------------------
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },

    --------------------------------------------------------
    -- Your plugins
    --------------------------------------------------------
    { import = "plugins" },
  },

  ----------------------------------------------------------
  -- Defaults
  ----------------------------------------------------------
  defaults = {
    lazy = false,
    version = false,
  },

  ----------------------------------------------------------
  -- Development
  ----------------------------------------------------------
  dev = {
    path = vim.fn.expand("~/.ghq/github.com"),
  },

  ----------------------------------------------------------
  -- Update checker
  ----------------------------------------------------------
  checker = {
    enabled = true,
    notify = false,
  },

  ----------------------------------------------------------
  -- Performance
  ----------------------------------------------------------
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrwPlugin",
      },
    },
  },

  ----------------------------------------------------------
  -- UI
  ----------------------------------------------------------
  ui = {
    border = "rounded",
    custom_keys = {
      ["<localleader>d"] = function(plugin)
        pcall(vim.notify, vim.inspect(plugin), vim.log.levels.INFO)
      end,
    },
  },

  ----------------------------------------------------------
  -- Debug
  ----------------------------------------------------------
  debug = false,
})
