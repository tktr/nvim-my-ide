local fn = vim.fn

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
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

-- Setup lazy.nvim
-- require("lazy").setup({
--   spec = {
--     -- import your plugins
--     { import = "plugins" },
--   },
--   -- Configure any other settings here. See the documentation for more details.
--   -- colorscheme that will be used when installing plugins.
--   install = { colorscheme = { "habamax" } },
--   -- automatically check for plugin updates
--   checker = { enabled = true },
-- })

-- Main Lazy.nvim setup call
return require("lazy").setup({
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  -- Useful lua functions used by lots of plugins (often needed early)
  { "nvim-lua/plenary.nvim",                       commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7", lazy = false },

  -- Autopairs, integrates with both cmp and treesitter
  { "windwp/nvim-autopairs",                       commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347" },
  { "numToStr/Comment.nvim",                       commit = "97a188a98b5a3a6f9b1b850799ac078faa17ab67" },
  { "JoosepAlviste/nvim-ts-context-commentstring", commit = "32d9627123321db65a4f158b72b757bcaef1a3f4" },

  -- Icons
  { "kyazdani42/nvim-web-devicons",                commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352", lazy = false }, -- Often needed early for UI elements

  -- File Explorer
  { "kyazdani42/nvim-tree.lua",                    commit = "7282f7de8aedf861fe0162a559fc2b214383c51c", cmd = "NvimTreeToggle" },

  -- UI/Navigation
  { "akinsho/bufferline.nvim" },
  { "moll/vim-bbye",                               commit = "25ef93ac5a87526111f43e5110675032dbcacf56" },
  { "nvim-lualine/lualine.nvim",                   commit = "a52f078026b27694d2290e34efa61a6e4a690621", event = "VeryLazy" }, -- Lualine can be lazy loaded
  { "akinsho/toggleterm.nvim",                     commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda", cmd = "ToggleTerm" },
  { "ahmedkhalf/project.nvim",                     commit = "628de7e433dd503e782831fe150bb750e56e55d6" },
  { "lewis6991/impatient.nvim",                    commit = "b842e16ecc1a700f62adb9802f8355b99b52a5a6", lazy = false }, -- Needs to load early for performance
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPost" },
  { "goolord/alpha-nvim",                  commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31", event = "VimEnter" }, -- Loads on Neovim startup
  { "folke/which-key.nvim",                tag = "v2.1.0",                                      event = "VeryLazy" }, -- Often configured to load on specific key presses

  -- Colorschemes
  { "folke/tokyonight.nvim",               commit = "66bfc2e8f754869c7b651f3f47a2ee56ae557764" },
  { "lunarvim/darkplus.nvim",              commit = "13ef9daad28d3cf6c5e793acfc16ddbf456e1c83" },
  -- { "rmehri01/onenord.nvim" },

  -- cmp plugins (often loaded on InsertEnter or when LSP attaches)
  {
    "hrsh7th/nvim-cmp",
    commit = "b0dff0ec4f2748626aae13f011d1a47071fe9abc",
    dependencies = {
      { "hrsh7th/cmp-buffer",           commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" },
      { "hrsh7th/cmp-path",             commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1" },
      { "saadparwaiz1/cmp_luasnip",     commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" },
      { "hrsh7th/cmp-nvim-lsp",         commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" },
      { "hrsh7th/cmp-nvim-lua",         commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" },
      -- Snippet engine for cmp
      { "L3MON4D3/LuaSnip",             commit = "8f8d493e7836f2697df878ef9c128337cbf2bb84" },
      { "rafamadriz/friendly-snippets", commit = "2be79d8a9b03d4175ba6b3d14b082680de1b31b1" },
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
  { "RRethy/vim-illuminate",         commit = "a2e8476af3f3e993bb0d6477438aad3096512e42", event = "BufReadPost" },
  { "nvimtools/none-ls.nvim",        event = "BufReadPre" },

  -- Telescope
  { "nvim-telescope/telescope.nvim", cmd = "Telescope" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Run this command after install/update
    event = "VeryLazy",  -- Load treesitter when Neovim is nearly done starting up
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
    commit = "6b12294a57001d994022df8acbe2ef7327d30587",
    cmd = "DapSetLogLevel", -- Example command to lazy load DAP
  },
  {
    "rcarriga/nvim-dap-ui",
    commit = "1cd4764221c91686dcf4d6b62d7a7b2d112e0b13",
    dependencies = { "mfussenegger/nvim-dap" }, -- Ensures dap is loaded first
    cmd = "DapUiToggle",
  },
  {
    "ravenxrz/DAPInstall.nvim",
    commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de",
    dependencies = { "mfussenegger/nvim-dap" },
    cmd = "DAPInstall",
  },

  { "ThePrimeagen/vim-be-good" },                            -- No explicit lazy loading, will load on first use
  { "tktr/nvim-ansible",       ft = { "yaml", "ansible" } }, -- Load only for Ansible-related files

  -- AI
  -- { "codota/tabnine-nvim", build = "./dl_binaries.sh" }, -- Use 'build' for post-clone commands
  { "github/copilot.vim" }, -- Will typically load on demand if configured
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
