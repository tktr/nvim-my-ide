return {
  { "nvim-lua/plenary.nvim", lazy = false },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  { "numToStr/Comment.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  { "moll/vim-bbye" },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({})
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  { "RRethy/vim-illuminate" },
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
  { "ravenxrz/DAPInstall.nvim", dependencies = { "mfussenegger/nvim-dap" } },
  { "ThePrimeagen/vim-be-good" },
  { "tktr/nvim-ansible", ft = { "yaml", "ansible" } },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
    dependencies = {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    },
  },
  {
    "aweis89/ai-terminals.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminals = {
        goose = {
          cmd = function()
            return string.format("GOOSE_CLI_THEME=%s goose", vim.o.background)
          end,
          path_header_template = "@%s", -- Default: @ prefix
        },
        aichat = {
          cmd = function()
            return string.format(
              "AICHAT_LIGHT_THEME=%s aichat -r %%functions%% --session",
              -- Convert boolean to string "true" or "false"
              tostring(vim.o.background == "light")
            )
          end,
          path_header_template = "@file %s", -- Default: @ prefix
        },
        claude = {
          cmd = function()
            return string.format("claude config set -g theme %s && claude", vim.o.background)
          end,
          path_header_template = "@%s", -- Default: @ prefix
        },
        aider = {
          cmd = function()
            return string.format("aider --watch-files --%s-mode", vim.o.background)
          end,
          path_header_template = "`%s`", -- Special: backticks for Aider
        },
      },
    },
    keys = {
      {
        "<leader>dvo",
        function()
          require("ai-terminals").diff_changes()
        end,
        desc = "Show diff (vimdiff)",
      },
      {
        "<leader>dvD",
        function()
          require("ai-terminals").diff_changes({ delta = true })
        end,
        desc = "Show diff (delta)",
      },
      {
        "<leader>dvr",
        function()
          require("ai-terminals").revert_changes()
        end,
        desc = "Revert changes from backup",
      },
      {
        "<leader>af", -- Mnemonic: Add Files
        function()
          require("ai-terminals").add_files_to_terminal("aichat", { vim.fn.expand("%") })
        end,
        desc = "Add current file to Claude",
      },
      {
        "<leader>aF", -- Mnemonic: Add Files (all buffers)
        function()
          require("ai-terminals").add_buffers_to_terminal("aichat")
        end,
        desc = "Add all buffers to Claude",
      },
      {
        "<leader>ati",
        function()
          require("ai-terminals").toggle("aichat")
        end,
        mode = { "n", "v" },
        desc = "Toggle AI Chat terminal (sends selection in visual mode)",
      },
      {
        "<leader>adi",
        function()
          require("ai-terminals").send_diagnostics("aichat")
        end,
        mode = { "n", "v" },
        desc = "Send diagnostics to AI Chat",
      },
      {
        "<leader>ar", -- Mnemonic: AI Run command (prompts)
        function()
          require("ai-terminals").send_command_output()
        end,
        desc = "Run command (prompts) and send output to active AI terminal",
      },
      {
        "<leader>aj", -- Mnemonic: AI Jira (example fixed command)
        function()
          require("ai-terminals").send_command_output("jira issue view YOUR-TICKET-ID --plain")
        end,
        desc = "Send Jira ticket (example) to active AI terminal",
      },
      {
        "<leader>ax", -- Mnemonic: AI eXterminate
        function()
          require("ai-terminals").destroy_all()
        end,
        desc = "Destroy all AI terminals (closes windows, stops processes)",
      },
      {
        "<leader>aT", -- Mnemonic: AI Focus
        function()
          require("ai-terminals").focus()
        end,
        desc = "Focus the last used AI terminal window",
      },
    },
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    keys = {
      { "<leader>ot", function() require("opencode").toggle() end, desc = "Toggle opencode" },
      { "<leader>oA", function() require("opencode").ask() end, desc = "Ask opencode" },
      { "<leader>oa", function() require("opencode").ask("@cursor: ") end, desc = "Ask opencode about this" },
      { "v", "<leader>oa", function() require("opencode").ask("@selection: ") end, desc = "Ask opencode about selection" },
      { "<leader>on", function() require("opencode").command("session_new") end, desc = "New opencode session" },
      { "<leader>oy", function() require("opencode").command("messages_copy") end, desc = "Copy last opencode response" },
      { "<S-C-u>", function() require("opencode").command("messages_half_page_up") end, desc = "Messages half page up" },
      { "<S-C-d>", function() require("opencode").command("messages_half_page_down") end, desc = "Messages half page down" },
      { { "n", "v" }, "<leader>os", function() require("opencode").select() end, desc = "Select opencode prompt" },
      { "<leader>oe", function() require("opencode").prompt("Explain @cursor and its context") end, desc = "Explain this code" },
    },
    config = function()
      vim.g.opencode_opts = {
        port = 32443,
        auto_reload = true,
      }

      vim.opt.autoread = true
    end,
  },
  { "folke/zen-mode.nvim" },
}
