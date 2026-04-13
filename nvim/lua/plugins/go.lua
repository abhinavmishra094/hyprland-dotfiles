return {
  -- Install Go LSP automatically via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "gopls", "delve" })
    end,
  },

  -- Setup LSP for Go
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                nilness = true,
              },
              staticcheck = true,
            },
          },
        },
      },
    },
  },

  -- Debugger (DAP)
  {
    "mfussenegger/nvim-dap",
    dependencies = { "leoluz/nvim-dap-go" },
    config = function()
      require("dap-go").setup()
    end,
    keys = {
      { "<leader>dnn", function() require("dap-go").debug_nearest() end, desc = "Debug nearest" },
      { "<leader>dnt", function() require("dap-go").debug_nearest_test() end, desc = "Debug test" },
      { "<leader>dnp", function() require("dap-go").debug_adaptive() end, desc = "Debug project (main)" },
      { "<leader>dcc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dso", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dsi", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>dsu", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dbp", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dbl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log breakpoint message: ")) end, desc = "Log breakpoint" },
      { "<leader>dre", function() require("dap").repl.open() end, desc = "REPL" },
      { "<leader>drl", function() require("dap").run_last() end, desc = "Run last" },
    },
  },
}
