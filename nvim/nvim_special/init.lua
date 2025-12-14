------------------------------------------------------------
-- init.lua
-- Entry point for Neovim configuration
-- CTF / CP / Red Team / Pentesting / Networking ready
------------------------------------------------------------

------------------------------------------------------------
-- Fast startup (Lua module loader)
------------------------------------------------------------
if vim.loader then
  vim.loader.enable()
end

------------------------------------------------------------
-- Early safety guards
------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Disable built-in plugins that cause slowdown or conflicts
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1

------------------------------------------------------------
-- Safe debug utilities
------------------------------------------------------------
-- Provide dd() only if debug module exists
local function safe_dd(...)
  local ok, dbg = pcall(require, "util.debug")
  if not ok or type(dbg.dump) ~= "function" then
    return
  end
  dbg.dump(...)
end

-- Expose debug helpers without crashing Neovim
_G.dd = safe_dd

-- Make :lua print() route to safe inspector
vim.print = safe_dd

------------------------------------------------------------
-- Better error visibility during startup
------------------------------------------------------------
local function safe_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.schedule(function()
      vim.notify(
        ("Failed loading %s\n%s"):format(mod, err),
        vim.log.levels.ERROR,
        { title = "init.lua" }
      )
    end)
  end
end

------------------------------------------------------------
-- Core bootstrap (Lazy.nvim)
------------------------------------------------------------
safe_require("config.lazy")

------------------------------------------------------------
-- Final sanity checks
------------------------------------------------------------
-- Ensure filetype detection is on
vim.cmd.filetype("plugin indent on")

-- Ensure syntax highlighting fallback
vim.cmd.syntax("enable")
