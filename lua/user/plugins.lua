
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
return require("lazy").setup({
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  -- Useful lua functions used by lots of plugins (often needed early)
  { "nvim-lua/plenary.nvim", lazy = false },

  -- Autopairs, integrates with both cmp and treesitter
  { "windwp/nvim-autopairs"},
  { "numToStr/Comment.nvim"},
  { "JoosepAlviste/nvim-ts-context-commentstring"},

  -- Icons
  { "kyazdani42/nvim-web-devicons", lazy = false }, -- Often needed early for UI elements

  -- File Explorer
  {
    "kyazdani42/nvim-tree.lua",
    cmd = "NvimTreeToggle",
  },

  -- UI/Navigation
  { "akinsho/bufferline.nvim" },
  { "moll/vim-bbye"},
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
  }, -- Lualine can be lazy loaded
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
  },
  { "ahmedkhalf/project.nvim"},
  { "lewis6991/impatient.nvim"}, -- Needs to load early for performance
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
  { "folke/tokyonight.nvim"},
  { "lunarvim/darkplus.nvim"},
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
    cmd = "DapSetLogLevel", -- Example command to lazy load DAP
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" }, -- Ensures dap is loaded first
    cmd = "DapUiToggle",
  },
  {
    "ravenxrz/DAPInstall.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    cmd = "DAPInstall",
  },

  { "ThePrimeagen/vim-be-good" }, -- No explicit lazy loading, will load on first use
  { "tktr/nvim-ansible", ft = { "yaml", "ansible" } }, -- Load only for Ansible-related files

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
    "yetone/avante.nvim",
    -- mode = "legacy",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make", -- ⚠️ must add this line! ! !
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    event = "VeryLazy",
    version = "v0.0.25", -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- debug = true,
      behavior = {
        enable_token_counting = false,
        auto_suggestions = false, -- disable auto suggestions
      },
      -- add any opts here
      -- for example
      provider = "copilot",
      -- provider = "gemini",
      providers = {
        -- copilot = {
        --   -- disable_tools = true,
        --   endpoint = "https://api.githubcopilot.com",
        --   insecure = true,
        --   proxy = "http://xpxiap.inprod.ept.lu:8080",
        --   model = "gpt-4o",
        --   -- model = "gpt-4.1",
        -- },
        -- gemini = {
        --   -- disable_tools = true,
        --   insecure = true,
        --   proxy = "http://xpxiap.inprod.ept.lu:8080",
        --   -- model = "gpt-4.1",
        -- },
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}, {
  -- Optional: Global settings for Lazy.nvim
  -- performance = {
  --   rtp = {
  --     -- disable some rtp plugins
  --     disabled_plugins = {
  --       "netrw",
  --       "netrwPlugin",
  --       "netrwSettings",
  --       "netrwFileHandlers",
  --       "gzip",
  --       "zipPlugin",
  --       "tarPlugin",
  --       "getscript",
  --       "getscriptPlugin",
  --       "vimball",
  --       "vimballPlugin",
  --       "matchit",
  --       "tutor",
  --       "rplugin",
  --       "rrhelper",
  --       "syntax",
  --       "synmenu",
  --       "menu",
  --       "ins_expand",
  --       "health",
  --       "tohtml",
  --       "fixindir",
  --       "2html",
  --       "logiPat",
  --       "nvim",
  --     },
  --   },
  -- },
})

-- You no longer need the PACKER_BOOTSTRAP check.
-- Lazy.nvim handles its own syncing automatically on first run.
