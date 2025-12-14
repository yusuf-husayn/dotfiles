-- coding.lua
-- Coding utilities for CTF, CP, Red Team, Pentesting
-- Stable. Conflict-free. Language-agnostic.

return {

------------------------------------------------------------
-- Competitive Programming
------------------------------------------------------------
{
  "xeluxee/competitest.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = {
    "CompetiTest",
  },
  keys = {
    { "<leader>cr", "<cmd>CompetiTest receive contest<cr>", desc = "CP receive contest" },
    { "<leader>cp", "<cmd>CompetiTest receive problem<cr>", desc = "CP receive problem" },
    { "<leader>ca", "<cmd>CompetiTest add_testcase<cr>", desc = "CP add testcase" },
    { "<leader>ce", "<cmd>CompetiTest edit_testcase<cr>", desc = "CP edit testcase" },
    { "<leader>ct", "<cmd>CompetiTest run<cr>", desc = "CP run" },
    { "<leader>cd", "<cmd>CompetiTest delete_testcase<cr>", desc = "CP delete testcase" },
  },
  config = function()
    require("competitest").setup({

      ------------------------------------------------------
      -- Compile commands
      ------------------------------------------------------
      compile_command = {
        c = {
          exec = "gcc",
          args = { "-O2", "-Wall", "-Wextra", "$(FNAME)", "-o", "$(FNOEXT)" },
        },
        cpp = {
          exec = "g++",
          args = { "-std=gnu++20", "-O2", "-Wall", "-Wextra", "$(FNAME)", "-o", "$(FNOEXT)" },
        },
        py = {
          exec = "python3",
          args = { "$(FNAME)" },
        },
        rust = {
          exec = "rustc",
          args = { "-O", "$(FNAME)" },
        },
        java = {
          exec = "javac",
          args = { "$(FNAME)" },
        },
      },

      ------------------------------------------------------
      -- Paths
      ------------------------------------------------------
      received_problems_path =
        "$(HOME)/Competitive Programming/$(JUDGE)/$(CONTEST)/$(PROBLEM).$(FEXT)",
      received_contests_directory =
        "$(HOME)/Competitive Programming/$(JUDGE)/$(CONTEST)",
      received_contests_problems_path = "$(PROBLEM).$(FEXT)",

      ------------------------------------------------------
      -- Behavior
      ------------------------------------------------------
      received_problems_prompt_path = false,
      received_contests_prompt_directory = false,
      received_contests_prompt_extension = false,
      open_received_contests = false,

      testcases_use_single_file = true,
      evaluate_template_modifiers = true,

      ------------------------------------------------------
      -- Defaults
      ------------------------------------------------------
      received_files_extension = "cpp",
      template_file = {
        cpp = "~/.config/nvim/template/CPP.cpp",
      },
    })
  end,
},

------------------------------------------------------------
-- Incremental rename
------------------------------------------------------------
{
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  config = true,
},

------------------------------------------------------------
-- Better motions with brackets
------------------------------------------------------------
{
  "nvim-mini/mini.bracketed",
  event = "BufReadPost",
  config = function()
    require("mini.bracketed").setup({
      file = { suffix = "" },
      window = { suffix = "" },
      quickfix = { suffix = "" },
      yank = { suffix = "" },
      treesitter = { suffix = "n" },
    })
  end,
},

------------------------------------------------------------
-- Smarter increment / decrement
-- Does NOT override global <C-a>/<C-x>
------------------------------------------------------------
{
  "monaqa/dial.nvim",
  keys = {
    { "<leader>+", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
    { "<leader>-", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
  },
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.constant.new({ elements = { "let", "const", "var" } }),
      },
    })
  end,
},

------------------------------------------------------------
-- Copilot
-- Disabled by default. Safe toggle.
------------------------------------------------------------
{
  "zbirenbaum/copilot.lua",
  enabled = false,
  cmd = "Copilot",
  opts = {
    suggestion = {
      auto_trigger = false,
      keymap = {
        accept = "<C-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      markdown = true,
      help = true,
      gitcommit = true,
    },
  },
},

}
