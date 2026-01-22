local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
  return
end

-- lua/plugins/indentline.lua (or wherever you define this)
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl", -- this line is crucial for the new naming convention
  opts = {
    -- Old: char = "▏"
    -- New: `char` is now part of `scope.char` or `indent.char`
    -- If you want a consistent char for all indentation, use `indent.char`
    indent = {
      char = "▏",
      -- You can also specify icons for different indent levels if you want, e.g.:
      -- chars = { "▏", "▕" },
    },

    -- Old: show_trailing_blankline_indent = false
    -- This option is removed. Blank lines will not show indent by default.

    -- Old: show_first_indent_level = true
    -- This option is also removed. First indent level is usually shown if you have `indent.char` set.

    -- Old: use_treesitter = true
    -- This is now the default behavior and is controlled by `scope.enabled`.
    -- If you want to explicitly enable or disable the context feature (which relies on Treesitter):
    scope = {
      enabled = true,
      -- Old: show_current_context = true
      -- New: `show_current_context` is part of `scope`.
      show_start = true, -- Shows the starting line of the current scope
      show_end = true, -- Shows the ending line of the current scope (optional, often less useful)
      -- highlight = "IndentBlanklineContext", -- You might want to define a highlight group for the context
      -- context_patterns = { "class", "function", "for", "if", "while", "do", "begin", "end" },
      -- If you had `context_patterns` in your old config, you'd add them here.
      -- The default context patterns usually cover common use cases.
    },

    -- Old: buftype_exclude = { "terminal", "nofile" }
    -- New: `exclude.buftypes`
    exclude = {
      buftypes = { "terminal", "nofile" },
      filetypes = {
        "help",
        "packer",
        "NvimTree",
        "Lazy", -- Add Lazy.nvim's buffer if you want to exclude it
        "alpha", -- If you're using alpha-nvim dashboard
        "TelescopePrompt", -- For Telescope's prompt
        "lspinfo", -- LSP info buffers
        "toggleterm", -- Toggleterm terminal buffers
        "DapUi_*", -- DAP UI buffers if you use nvim-dap-ui
      },
    },

    -- Other common options you might consider (these are new or changed defaults):
    -- space_char_blankline = " ", -- Set to " " to show spaces on blank lines (default is no char)
    -- max_indent_level = -1,      -- -1 means no limit
    -- level_indent = 1,           -- How many spaces per indent level (usually corresponds to your tabstop)
  },
  -- If you are defining this within your lazy.nvim setup:
  event = "BufReadPre", -- or "BufReadPost", "VeryLazy"
  -- Or for more fine-grained control:
  -- config = function()
  --   require("ibl").setup {
  --     -- your new config here
  --   }
  -- end
}
