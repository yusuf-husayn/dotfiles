-- Neovim Debugger (DAP) – FINAL STABLE
-- Zero mouse. Vim-style. CTF / CP / Pentest ready.

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      ------------------------------------------------------------------
      -- DAP UI
      ------------------------------------------------------------------
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 10,
            position = "bottom",
          },
        },
        controls = { enabled = false },
      })

      dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
      end

      ------------------------------------------------------------------
      -- Keymaps (Leader = Space)
      ------------------------------------------------------------------
      local map = vim.keymap.set
      local opts = { silent = true }

      map("n", "<leader>db", dap.toggle_breakpoint, opts)
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, opts)

      map("n", "<leader>dc", dap.continue, opts)
      map("n", "<leader>dn", dap.step_over, opts)
      map("n", "<leader>di", dap.step_into, opts)
      map("n", "<leader>do", dap.step_out, opts)
      map("n", "<leader>dq", dap.terminate, opts)

      map("n", "<leader>dr", dap.repl.open, opts)
      map("n", "<leader>dl", dap.run_last, opts)

      map("n", "<leader>du", dapui.toggle, opts)
      map("n", "<leader>dh", function()
        dapui.eval(nil, { enter = true })
      end, opts)

      ------------------------------------------------------------------
      -- C / C++ / Rust (gdb via lldb-vscode)
      ------------------------------------------------------------------
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb",
      }

      dap.configurations.c = {
        {
          name = "Launch (C/C++)",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = dap.configurations.c

      ------------------------------------------------------------------
      -- Python (debugpy)
      ------------------------------------------------------------------
      dap.adapters.python = {
        type = "executable",
        command = "python3",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return "python3"
          end,
        },
      }

      ------------------------------------------------------------------
      -- Visual signs
      ------------------------------------------------------------------
      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "Error",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "▶",
        texthl = "String",
        linehl = "Visual",
        numhl = "",
      })
    end,
  },
}
