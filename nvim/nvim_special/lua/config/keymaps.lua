-- keymaps.lua
-- Stable, conflict-free keymaps for CTF, CP, Red Team, Pentesting
-- Defensive requires. No overrides of core motions. No duplication.

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

------------------------------------------------------------
-- Discipline. Safe load
------------------------------------------------------------
pcall(function()
  require("craftzdog.discipline").cowboy()
end)

------------------------------------------------------------
-- Register safety. Do not pollute registers
------------------------------------------------------------
map("n", "x", '"_x')
map("v", "x", '"_x')

map("n", "<leader>d", '"_d')
map("n", "<leader>D", '"_D')
map("v", "<leader>d", '"_d')
map("v", "<leader>D", '"_D')

map("n", "<leader>c", '"_c')
map("n", "<leader>C", '"_C')
map("v", "<leader>c", '"_c')
map("v", "<leader>C", '"_C')

------------------------------------------------------------
-- Paste behavior
-- <leader>p   paste last yank
-- <leader>P   paste before
-- <leader>y   system clipboard
------------------------------------------------------------
map("n", "<leader>p", '"0p')
map("n", "<leader>P", '"0P')
map("v", "<leader>p", '"0p')

map({ "n", "v" }, "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')
map({ "n", "v" }, "<leader>pp", '"+p')

------------------------------------------------------------
-- Increment / decrement
-- Do NOT override <C-a> globally. Safe keys only
------------------------------------------------------------
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

------------------------------------------------------------
-- Selection helpers
------------------------------------------------------------
map("n", "<leader>a", "ggVG", opts)

------------------------------------------------------------
-- Line control. No comment continuation
------------------------------------------------------------
map("n", "<leader>o", "o<Esc>^Da", opts)
map("n", "<leader>O", "O<Esc>^Da", opts)

------------------------------------------------------------
-- Jumplist fix
------------------------------------------------------------
map("n", "<C-m>", "<C-i>", opts)

------------------------------------------------------------
-- Tabs
------------------------------------------------------------
map("n", "te", "<cmd>tabedit<cr>", opts)
map("n", "<Tab>", "<cmd>tabnext<cr>", opts)
map("n", "<S-Tab>", "<cmd>tabprev<cr>", opts)

------------------------------------------------------------
-- Window management
------------------------------------------------------------
map("n", "ss", "<cmd>split<cr>", opts)
map("n", "sv", "<cmd>vsplit<cr>", opts)

map("n", "sh", "<C-w>h", opts)
map("n", "sj", "<C-w>j", opts)
map("n", "sk", "<C-w>k", opts)
map("n", "sl", "<C-w>l", opts)

map("n", "<C-w><Left>", "<C-w><", opts)
map("n", "<C-w><Right>", "<C-w>>", opts)
map("n", "<C-w><Up>", "<C-w>+", opts)
map("n", "<C-w><Down>", "<C-w>-", opts)

------------------------------------------------------------
-- Buffers
------------------------------------------------------------
map("n", "<leader>bn", "<cmd>bnext<cr>", opts)
map("n", "<leader>bp", "<cmd>bprev<cr>", opts)
map("n", "<leader>bd", "<cmd>bdelete<cr>", opts)

------------------------------------------------------------
-- Files
------------------------------------------------------------
map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>q", "<cmd>q<cr>", opts)
map("n", "<leader>Q", "<cmd>qa!<cr>", opts)
map("n", "<leader>e", "<cmd>e .<cr>", opts)

------------------------------------------------------------
-- Search hygiene
------------------------------------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<cr>", opts)
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

------------------------------------------------------------
-- Diagnostics
------------------------------------------------------------
map("n", "<leader>dn", vim.diagnostic.goto_next, opts)
map("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
map("n", "<leader>df", vim.diagnostic.open_float, opts)
map("n", "<leader>dl", vim.diagnostic.setloclist, opts)

------------------------------------------------------------
-- LSP core. No plugin assumptions
------------------------------------------------------------
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gD", vim.lsp.buf.declaration, opts)
map("n", "gr", vim.lsp.buf.references, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, opts)

------------------------------------------------------------
-- Optional helpers. Safe requires
------------------------------------------------------------
map("n", "<leader>r", function()
  pcall(function()
    require("craftzdog.hsl").replaceHexWithHSL()
  end)
end, opts)

map("n", "<leader>i", function()
  pcall(function()
    require("craftzdog.lsp").toggleInlayHints()
  end)
end, opts)

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  pcall(function()
    require("craftzdog.lsp").toggleAutoformat()
  end)
end, {})

------------------------------------------------------------
-- Terminal
------------------------------------------------------------
map("n", "<leader>tt", "<cmd>terminal<cr>", opts)
map("t", "<Esc>", "<C-\\><C-n>", opts)

------------------------------------------------------------
-- Quick execution. Safe defaults
------------------------------------------------------------
map("n", "<leader>sh", "<cmd>w<cr><cmd>!bash %<cr>", opts)
map("n", "<leader>py", "<cmd>w<cr><cmd>!python3 %<cr>", opts)
map("n", "<leader>js", "<cmd>w<cr><cmd>!node %<cr>", opts)
map("n", "<leader>c", "<cmd>w<cr><cmd>!gcc % -o %:r && ./%:r<cr>", opts)
map("n", "<leader>cpp", "<cmd>w<cr><cmd>!g++ -std=gnu++20 % -O2 -o %:r && ./%:r<cr>", opts)

------------------------------------------------------------
-- Shell escape
------------------------------------------------------------
map("n", "<leader>!", "<cmd>!<space>", { noremap = true })
