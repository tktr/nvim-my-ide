local none_ls_status_ok, none_ls = pcall(require, "null-ls")
if not none_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = none_ls.builtins.formatting

local sources = {
  formatting.stylua,
  formatting.google_java_format,
}

if vim.fn.executable "prettier" == 1 then
  table.insert(
    sources,
    formatting.prettier.with {
      extra_filetypes = { "toml" },
      extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    }
  )
end

none_ls.setup {
  debug = false,
  sources = sources,
}
