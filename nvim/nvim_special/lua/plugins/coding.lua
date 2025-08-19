return {
	-- competitest
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    keys = {
      { " rc", "<cmd>CompetiTest receive contest <CR>", { desc = "receive contest" } },
      { " rp", "<cmd>CompetiTest receive problem <CR>", { desc = "receive problem" } },
      { " ra", "<cmd>CompetiTest add_testcase <CR>", { desc = "add testcase" } },
      { " re", "<cmd>CompetiTest edit_testcase <CR>", { desc = "edit testcase" } },
      { " rr", "<cmd>CompetiTest run <CR>", { desc = "run code" } },
      { " rd", "<cmd>CompetiTest delete_testcase <CR>", { desc = "delete testcase" } },
    },
    config = function()
      require("competitest").setup({
        compile_command = {
          c = { exec = "gcc", args = { "-DMOHAMED", "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
          cpp = {
            exec = "g++",
            args = { "-std=c++20", "-DMOHAMED", "-Wall", "$(FNAME)", "-o", "$(FNOEXT)", "-g" },
          },
          py = { exec = "python", args = { "$(FNAME)" } },
          rust = { exec = "rustc", args = { "$(FNAME)" } },
          java = { exec = "javac", args = { "$(FNAME)" } },
        },
        received_problems_path = "$(HOME)/Competitive Programming/$(JUDGE)/$(CONTEST)/$(PROBLEM).$(FEXT)",
        received_contests_directory = "$(HOME)/Competitive Programming/$(JUDGE)/$(CONTEST)",
        received_contests_problems_path = "$(PROBLEM).$(FEXT)",
        received_problems_prompt_path = false,
        testcases_use_single_file = true,
        evaluate_template_modifiers = true,
        received_contests_prompt_directory = false,
        received_contests_prompt_extension = false,
        open_received_contests = false,
        received_files_extension = "cpp",
        template_file = {
          cpp = "~/.config/nvim/template/CPP.cpp",
        },
      })
    end,
  },
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	-- Better increase/descrease
	{
		"monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
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
					augend.constant.new({ elements = { "let", "const" } }),
				},
			})
		end,
	},

	-- copilot
	{
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  opts = {
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<C-l>",
        accept_word = "<M-l>",
        accept_line = "<M-S-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      markdown = true,
      help = true,
      lua = true,
      python = true,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
  end,
}

}
