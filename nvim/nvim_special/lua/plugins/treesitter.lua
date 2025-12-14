-- treesitter.lua
-- Lazy.nvim + LazyVim safe configuration
-- CTF / CP / Red Team / Pentesting / Networking ready

return {

------------------------------------------------------------
-- Playground (query debugging)
------------------------------------------------------------
{
  "nvim-treesitter/playground",
  cmd = "TSPlaygroundToggle",
},

------------------------------------------------------------
-- Treesitter core
------------------------------------------------------------
{
  "nvim-treesitter/nvim-treesitter",

  build = ":TSUpdate",

  opts = {

    --------------------------------------------------------
    -- Parsers
    --------------------------------------------------------
    ensure_installed = {
      -- Core
      "c",
      "cpp",
      "lua",
      "vim",
      "vimdoc",
      "query",

      -- CP
      "cmake",
      "java",
      "python",
      "rust",
      "go",

      -- Web
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "json",
      "jsonc",
      "yaml",
      "toml",
      "graphql",
      "http",
      "scss",
      "svelte",
      "astro",

      -- Shell / scripting
      "bash",
      "fish",
      "powershell",

      -- Infra / security
      "dockerfile",
      "terraform",
      "nginx",
      "sql",

      -- Misc
      "gitignore",
      "regex",
      "markdown",
      "markdown_inline",
    },

    --------------------------------------------------------
    -- Highlight
    --------------------------------------------------------
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    --------------------------------------------------------
    -- Indent
    --------------------------------------------------------
    indent = {
      enable = true,
      disable = { "python", "yaml" },
    },

    --------------------------------------------------------
    -- Incremental selection
    --------------------------------------------------------
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },

    --------------------------------------------------------
    -- Textobjects
    --------------------------------------------------------
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },

    --------------------------------------------------------
    -- Playground
    --------------------------------------------------------
    playground = {
      enable = true,
      updatetime = 25,
      persist_queries = true,
    },

    --------------------------------------------------------
    -- Query linter
    --------------------------------------------------------
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },

    --------------------------------------------------------
    -- Performance: disable on large files
    --------------------------------------------------------
    disable = function(_, buf)
      local max = 100 * 1024
      local ok, stat = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok and stat and stat.size > max
    end,
  },

  ----------------------------------------------------------
  -- Minimal config hook
  -- DO NOT call configs.setup again
  ----------------------------------------------------------
  config = function()
    -- extra filetypes
    vim.filetype.add({
      extension = {
        mdx = "mdx",
      },
    })

    vim.treesitter.language.register("markdown", "mdx")
  end,
},

}
