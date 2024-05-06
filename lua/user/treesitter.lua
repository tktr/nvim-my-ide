local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup {
    -- make sure  "c", "vim", "lua", "help" are excluded from section below
    -- see  https://github.com/nvim-treesitter/nvim-treesitter/issues/3970
    ensure_installed = {"markdown", "markdown_inline", "bash", "python"}, -- put the language you want in this array
    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
