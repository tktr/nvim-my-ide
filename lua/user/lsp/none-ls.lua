local none_ls_status_ok, none_ls = pcall(require, "null-ls")
if not none_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = none_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = none_ls.builtins.diagnostics

-- https://github.com/prettier-solidity/prettier-plugin-solidity
none_ls.setup {
  debug = false,
  sources = {
    formatting.prettier.with {
      extra_filetypes = { "toml" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    },
    -- ruff should be called before black i.e. for cleanup of blank lines
    -- after removing unused imports.
    -- Note that ruff-lsp is also registered. Still required here
    -- for synchronous autocommands on save (curently not possible with LSP)
    formatting.black.with { extra_args = { "--fast" } },
    formatting.stylua,
    formatting.google_java_format,
    --formatting.trim_newlines,
    --formatting.trim_whitespace
  },
}
