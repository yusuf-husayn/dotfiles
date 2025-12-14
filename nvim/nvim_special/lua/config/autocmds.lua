-- autocmds.lua
-- Stable, defensive, competition-ready autocmds
-- Works with LazyVim and custom configs
-- No conflicts. No duplicates. No surprises.

local api = vim.api

------------------------------------------------------------
-- Helper. Safe augroup creator
------------------------------------------------------------
local function augroup(name)
  return api.nvim_create_augroup("user_" .. name, { clear = true })
end

------------------------------------------------------------
-- Insert mode hygiene
------------------------------------------------------------
api.nvim_create_autocmd("InsertLeave", {
  group = augroup("insert_cleanup"),
  callback = function()
    if vim.o.paste then
      vim.o.paste = false
    end
  end,
})

------------------------------------------------------------
-- Conceal control
-- Avoid hidden characters in security and config files
------------------------------------------------------------
api.nvim_create_autocmd("FileType", {
  group = augroup("conceal_control"),
  pattern = {
    "json",
    "jsonc",
    "yaml",
    "yml",
    "toml",
    "markdown",
    "md",
    "conf",
    "ini",
    "env",
  },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

------------------------------------------------------------
-- Large file protection
-- Prevent freezes during CTF / log analysis
------------------------------------------------------------
api.nvim_create_autocmd("BufReadPre", {
  group = augroup("large_file"),
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, args.file)
    if not ok or not stats then
      return
    end

    if stats.size > 2 * 1024 * 1024 then
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.syntax = "off"
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.lazyredraw = true
    end
  end,
})

------------------------------------------------------------
-- Binary / unknown file safety
------------------------------------------------------------
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("binary_guard"),
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.binary = false
      vim.opt_local.wrap = false
    end
  end,
})

------------------------------------------------------------
-- Auto filetype detection for security / networking
------------------------------------------------------------
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("custom_filetypes"),
  pattern = {
    "*.conf",
    "*.cfg",
    "*.cnf",
    "*.env",
    "*.service",
    "*.timer",
    "*.mount",
    "*.socket",
  },
  callback = function()
    vim.bo.filetype = "conf"
  end,
})

api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("script_filetypes"),
  pattern = {
    "*.ps1",
    "*.psm1",
  },
  callback = function()
    vim.bo.filetype = "powershell"
  end,
})

------------------------------------------------------------
-- Networking / log files
------------------------------------------------------------
api.nvim_create_autocmd("FileType", {
  group = augroup("logs"),
  pattern = {
    "log",
    "messages",
    "syslog",
  },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

------------------------------------------------------------
-- Terminal behavior
------------------------------------------------------------
api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

------------------------------------------------------------
-- Auto reload files changed outside Neovim
------------------------------------------------------------
api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup("autoread"),
  callback = function()
    if vim.o.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

------------------------------------------------------------
-- Trailing whitespace warning
-- Do NOT auto-delete. Safe for exploits and payloads
------------------------------------------------------------
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("whitespace_warn"),
  callback = function()
    if vim.bo.filetype ~= "markdown" then
      vim.fn.matchadd("ErrorMsg", [[\s\+$]])
    end
  end,
})

------------------------------------------------------------
-- Restore cursor position
------------------------------------------------------------
api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function()
    local row, _ = unpack(vim.api.nvim_buf_get_mark(0, '"'))
    if row > 1 and row <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, { row, 0 })
    end
  end,
})

------------------------------------------------------------
-- End of file
------------------------------------------------------------
