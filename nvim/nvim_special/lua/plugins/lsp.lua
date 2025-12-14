-- lsp.lua
-- Mason-safe, LazyVim-safe, conflict-free
-- CTF / CP / Red Team / Pentesting ready

return {

------------------------------------------------------------
-- Mason
------------------------------------------------------------
{
  "mason-org/mason.nvim",
  opts = function(_, opts)
    opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, {

      -- Lua
      "lua-language-server",
      "stylua",
      "selene",
      "luacheck",

      -- C / C++
      "clangd",
      "codelldb",

      -- Python
      "pyright",

      -- Web
      "typescript-language-server",
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",
      "json-lsp",

      -- Shell / Security
      "bash-language-server",
      "shellcheck",
      "shfmt",

      -- Infra / Config
      "yaml-language-server",
      "dockerfile-language-server",
      "terraform-ls",
      "ansible-language-server",

      -- Data / Docs
      "marksman",
      "taplo",
      "sqlfluff",
    })
  end,
},

------------------------------------------------------------
-- LSPConfig
------------------------------------------------------------
{
  "neovim/nvim-lspconfig",

  opts = {

    diagnostics = {
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = {
        spacing = 2,
        prefix = "●",
      },
    },

    inlay_hints = { enabled = false },

    servers = {

      ------------------------------------------------------
      -- C / C++
      ------------------------------------------------------
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=never",
        },
      },

      ------------------------------------------------------
      -- Python
      ------------------------------------------------------
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      },

      ------------------------------------------------------
      -- TypeScript / JavaScript
      ------------------------------------------------------
      tsserver = {
        root_dir = require("lspconfig.util").root_pattern(".git"),
        single_file_support = false,
      },

      ------------------------------------------------------
      -- Web
      ------------------------------------------------------
      html = {},
      cssls = {},
      tailwindcss = {},

      jsonls = {},
      yamlls = {
        settings = {
          yaml = { keyOrdering = false },
        },
      },

      taplo = {},

      ------------------------------------------------------
      -- Shell
      ------------------------------------------------------
      bashls = {},

      ------------------------------------------------------
      -- Infrastructure
      ------------------------------------------------------
      dockerfile_language_server = {},
      terraformls = {},
      ansiblels = {},

      ------------------------------------------------------
      -- Markdown
      ------------------------------------------------------
      marksman = {},

      ------------------------------------------------------
      -- Lua
      ------------------------------------------------------
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            format = { enable = false },
          },
        },
      },
    },

    setup = {
      ["*"] = function(_, opts)
        local caps = vim.lsp.protocol.make_client_capabilities()
        local ok, cmp = pcall(require, "cmp_nvim_lsp")
        if ok then
          caps = cmp.default_capabilities(caps)
        end
        opts.capabilities = caps
      end,
    },
  },
},

}
