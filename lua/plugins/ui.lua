return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset theme here, or create your own theme using circles style tables
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "tokyonight",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          -- close_command = "Bdelete! %d",
          -- right_mouse_command = "Bdelete! %d",
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          -- separator_style = "slant",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },

  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua <CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      alpha.setup(dashboard.opts)
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      local status_ok, which_key = pcall(require, "which-key")
      if not status_ok then
        return
      end

      local setup = {
        plugins = {
          marks = true, -- shows a list of your marks on ' and `
          registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20,
          },
        },
        key_labels = {},
        icons = {
          breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
          separator = "➜", -- symbol used between a key and it's label
          group = "+", -- symbol prepended to a group
        },
        popup_mappings = {
          scroll_down = "<c-d>", -- scroll down in the popup
          scroll_up = "<c-u>", -- scroll up in the popup
        },
        window = {
          border = "rounded", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
        ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        triggers_blacklist = {
          i = { "j", "k" },
          v = { "j", "k" },
        },
      }

      local opts = {
        mode = "n", -- NORMAL mode
        prefix = "<leader>",
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = true, -- use `nowait` when creating keymaps
      }

      local mappings = {
        ["e"] = { "<cmd>NeotreeToggle<cr>", "Explorer" },
        ["w"] = { "<cmd>w!<CR>", "Save" },
        ["q"] = { "<cmd>q!<CR>", "Quit" },
        ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
        ["h"] = { "<cmd>nohl<CR>", "No Highlight" },

        f = {
          name = "Find",
          f = { "<cmd>Telescope find_files<cr>", "Find File" },
          c = { "<cmd>Telescope git_files<cr>", "Find Git File" },
        },

        g = {
          name = "Git",
          g = { "<cmd>Neogit<CR>", "Neogit" },
          j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
          k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
          l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
          p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
          r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
          R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
          s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
          u = {
            "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
            "Undo Stage Hunk",
          },
          o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
          d = {
            "<cmd>Gitsigns diffthis HEAD<cr>",
            "Diff",
          },
        },

        l = {
          name = "LSP",
          a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
          d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
          f = { "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format" },
          i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
          r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
          s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
          t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
          w = {
            "<cmd>lua vim.diagnostic.open_float()<CR>",
            "Line Diagnostics",
          },
        },
        s = {
          name = "Search",
          g = { "<cmd>Telescope live_grep<cr>", "Grep" },
          b = { "<cmd>Telescope grep_string<cr>", "Grep Buffer" },
        },
        t = {
          name = "Terminal",
          n = { "<cmd>lua _NODE_TERM()<cr>", "Node" },
          u = { "<cmd>lua _NCDU_TERM()<cr>", "NCDU" },
          t = { "<cmd>lua _HTOP_TERM()<cr>", "Htop" },
          p = { "<cmd>lua _PYTHON_TERM()<cr>", "Python" },
          f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
          h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
          v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
        },
      }
      which_key.setup(setup)
      which_key.register(mappings, opts)
    end,
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  { "lunarvim/darkplus.nvim" },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
}
