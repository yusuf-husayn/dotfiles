-- options.lua
-- Stable, security-aware Neovim options
-- CTF / CP / Red Team / Pentesting / Networking ready

------------------------------------------------------------
-- Leader
------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = ","

------------------------------------------------------------
-- Encoding
------------------------------------------------------------
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "latin1" }

------------------------------------------------------------
-- UI
------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

------------------------------------------------------------
-- Editing behavior
------------------------------------------------------------
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.formatoptions:append({ "r" })
vim.opt.clipboard = "unnamedplus"

------------------------------------------------------------
-- Search
------------------------------------------------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

------------------------------------------------------------
-- Files
------------------------------------------------------------
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.autoread = true

------------------------------------------------------------
-- Shell
-- Use bash for compatibility with exploits and tools
------------------------------------------------------------
vim.opt.shell = "/usr/bin/env bash"

------------------------------------------------------------
-- Splits
------------------------------------------------------------
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"

------------------------------------------------------------
-- Mouse
-- Keep enabled for UI plugins, disable selection issues
------------------------------------------------------------
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"

------------------------------------------------------------
-- Performance
------------------------------------------------------------
vim.opt.lazyredraw = false
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400
vim.opt.redrawtime = 1000

------------------------------------------------------------
-- Completion
------------------------------------------------------------
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumblend = 0
vim.opt.winblend = 0

------------------------------------------------------------
-- Wildmenu and path
------------------------------------------------------------
vim.opt.path:append({ "**" })
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({
  "*/node_modules/*",
  "*/.git/*",
  "*/dist/*",
  "*/build/*",
})

------------------------------------------------------------
-- Folding
------------------------------------------------------------
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99

------------------------------------------------------------
-- Terminal
------------------------------------------------------------
vim.opt.termguicolors = true

------------------------------------------------------------
-- Underline / undercurl
------------------------------------------------------------
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

------------------------------------------------------------
-- Filetype detection
------------------------------------------------------------
vim.filetype.add({
  extension = {
    mdx = "mdx",
    astro = "astro",
    conf = "conf",
    env = "sh",
    service = "conf",
  },
  filename = {
    Podfile = "ruby",
  },
})

------------------------------------------------------------
-- LazyVim integration
------------------------------------------------------------
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_prettier_needs_config = true
