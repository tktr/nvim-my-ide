-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Main Lazy.nvim setup call
return require("lazy").setup {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  -- Useful lua functions used by lots of plugins (often needed early)
  { "nvim-lua/plenary.nvim", lazy = false },

  -- Autopairs, integrates with both cmp and treesitter
  { "windwp/nvim-autopairs" },
  { "numToStr/Comment.nvim" },

  -- Icons
  { "kyazdani42/nvim-web-devicons", lazy = false }, -- Often needed early for UI elements

  -- File Explorer
  {
    "kyazdani42/nvim-tree.lua",
    cmd = "NvimTreeToggle",
  },

  -- UI/Navigation
  { "akinsho/bufferline.nvim" },
  { "moll/vim-bbye" },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
  }, -- Lualine can be lazy loaded
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
  },
  { "ahmedkhalf/project.nvim" },
  { "lewis6991/impatient.nvim" }, -- Needs to load early for performance
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    event = "BufReadPost",
  },
  { "goolord/alpha-nvim", event = "VimEnter" }, -- Loads on Neovim startup
  { "folke/which-key.nvim", tag = "v2.1.0", event = "VeryLazy" }, -- Often configured to load on specific key presses

  -- Colorschemes
  { "folke/tokyonight.nvim" },
  { "lunarvim/darkplus.nvim" },
  -- { "rmehri01/onenord.nvim" },

  -- cmp plugins (often loaded on Insermter or when LSP attaches)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      -- Snippet engine for cmp
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    },
    -- Example of lazy loading cmp on Insert mode
    event = "InsertEnter",
    -- Or you might set up an autocommand for when LSP attaches
    -- event = "LspAttach",
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    -- Load LSP when a buffer is read
    event = "BufReadPre",
  },
  { "RRethy/vim-illuminate", event = "BufReadPost" },
  { "nvimtools/none-ls.nvim", event = "BufReadPre" },

  -- Telescope
  { "nvim-telescope/telescope.nvim", cmd = "Telescope" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Run this command after install/update
    event = "VeryLazy", -- Load treesitter when Neovim is nearly done starting up
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
  },

  -- Git
  { "lewis6991/gitsigns.nvim" },

  -- DAP
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
      },
      { "mfussenegger/nvim-dap-python" },
      { "theHamsta/nvim-dap-virtual-text" },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
          ensure_installed = { "python" },
          -- Let nvim-dap-python own the python adapter definition.
          -- mason-nvim-dap's default python adapter uses:
          --   command = vim.fn.exepath('debugpy-adapter')
          -- If this runs before mason has prepended its bin dir to $PATH, that resolves
          -- to an empty string, resulting in:
          --   Executable `` not found
          handlers = {
            function(config)
              require("mason-nvim-dap").default_setup(config)
            end,
            python = function(_)
              -- no-op
            end,
          },
        },
      },
    },
    config = function()
      require "user.dap"
    end,
  },

  -- DAP plugins are now declared as nvim-dap dependencies (see above).

  { "ThePrimeagen/vim-be-good" }, -- No explicit lazy loading, will load on first use
  { "tktr/nvim-ansible", ft = { "yaml", "ansible" } }, -- Load only for Ansible-related files
  {
    "folke/snacks.nvim",

    ---@type snacks.Config
    opts = {
      input = {
        enabled = true, -- Enable the input UI
        border = "rounded", -- Border style for the input window
      },
      picker = {
        -- your picker configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
  },

  -- AI
  --{ "codota/tabnine-nvim", build = "./dl_binaries.sh" }, -- Use 'build' for post-clone commands
  --{ "github/copilot.vim" }, -- Will typically load on demand if configured
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
        require("copilot").setup {
          suggestion = { enabled = false },
          panel = { enabled = false },
        }
      end,
    },
  },
  {
    "aweis89/ai-terminals.nvim",
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
      -- You can also set window, default_position, enable_diffing here
    },
    keys = {
      -- Diff Tools
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
          require("ai-terminals").diff_changes { delta = true }
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
      -- Example Keymaps (using default terminal names: 'claude', 'goose',
      -- 'aider', 'aichat')
      -- Generic File Management (works with any terminal)
      {
        "<leader>af", -- Mnemonic: Add Files
        function()
          -- Add current file to Claude using generic function
          require("ai-terminals").add_files_to_terminal("aichat", { vim.fn.expand "%" })
        end,
        desc = "Add current file to Claude",
      },
      {
        "<leader>aF", -- Mnemonic: Add Files (all buffers)
        function()
          -- Add all buffers to Claude using generic function
          require("ai-terminals").add_buffers_to_terminal "aichat"
        end,
        desc = "Add all buffers to Claude",
      },
      -- aichat Keymaps
      {
        "<leader>ati",
        function()
          require("ai-terminals").toggle "aichat"
        end,
        mode = { "n", "v" },
        desc = "Toggle AI Chat terminal (sends selection in visual mode)",
      },
      {
        "<leader>adi",
        function()
          require("ai-terminals").send_diagnostics "aichat"
        end,
        mode = { "n", "v" },
        desc = "Send diagnostics to AI Chat",
      },
      -- Run Command and Send Output
      {
        "<leader>ar", -- Mnemonic: AI Run command (prompts)
        function()
          -- Prompts user for a command, then sends its output to the active/last-focused AI terminal.
          require("ai-terminals").send_command_output()
        end,
        desc = "Run command (prompts) and send output to active AI terminal",
      },
      {
        "<leader>aj", -- Mnemonic: AI Jira (example fixed command)
        function()
          -- Sends output of a fixed command to the active/last-focused AI terminal.
          -- Replace with your actual command, e.g., dynamically get ticket ID.
          require("ai-terminals").send_command_output "jira issue view YOUR-TICKET-ID --plain"
        end,
        desc = "Send Jira ticket (example) to active AI terminal",
      },
      -- Destroy All Terminals
      {
        "<leader>ax", -- Mnemonic: AI eXterminate
        function()
          require("ai-terminals").destroy_all()
        end,
        desc = "Destroy all AI terminals (closes windows, stops processes)",
      },
      -- Focus Terminal
      {
        "<leader>af", -- Mnemonic: AI Focus
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
      -- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    config = function()
      vim.g.opencode_opts = {
        auto_reload = true, -- Auto-reload files when changed externally
        -- Your configuration, if any — see `lua/opencode/config.lua`
      }

      -- Required for `opts.auto_reload`
      vim.opt.autoread = true

      -- Recommended keymaps
      vim.keymap.set("n", "<leader>ot", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })
      vim.keymap.set("n", "<leader>oA", function()
        require("opencode").ask()
      end, { desc = "Ask opencode" })
      vim.keymap.set("n", "<leader>oa", function()
        require("opencode").ask "@cursor: "
      end, { desc = "Ask opencode about this" })
      vim.keymap.set("v", "<leader>oa", function()
        require("opencode").ask "@selection: "
      end, { desc = "Ask opencode about selection" })
      vim.keymap.set("n", "<leader>on", function()
        require("opencode").command "session_new"
      end, { desc = "New opencode session" })
      vim.keymap.set("n", "<leader>oy", function()
        require("opencode").command "messages_copy"
      end, { desc = "Copy last opencode response" })
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command "messages_half_page_up"
      end, { desc = "Messages half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command "messages_half_page_down"
      end, { desc = "Messages half page down" })
      vim.keymap.set({ "n", "v" }, "<leader>os", function()
        require("opencode").select()
      end, { desc = "Select opencode prompt" })

      -- Example: keymap for custom prompt
      vim.keymap.set("n", "<leader>oe", function()
        require("opencode").prompt "Explain @cursor and its context"
      end, { desc = "Explain this code" })
    end,
  },
}

-- You no longer need the PACKER_BOOTSTRAP check.
-- Lazy.nvim handles its own syncing automatically on first run.
