return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-telescope/telescope-zoxide" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {

        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules" },

        mappings = {
          i = {
            ["<Down>"] = actions.cycle_history_next,
            ["<Up>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
    })

    require("telescope").load_extension("zoxide")
  end,
}
