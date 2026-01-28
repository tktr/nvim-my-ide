vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
-- Automatically close tab/vim when nvim-tree is the last window in the tab
vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.py" },
  callback = function()
    vim.lsp.buf.format { async = false }
    vim.lsp.buf.code_action {
      apply = true,
      context = {
        only = { "source.organizeImports" },
        diagnostics = {},
      },
    }
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd "hi link illuminatedWord LspReferenceText"
  end,
})

-- DAP REPL uses a prompt buffer; avoid attaching LSP clients to it.
-- Neovim 0.11.x has known changetracking crashes when LSP operates on prompt buffers.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bt = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
    if bt ~= "prompt" and ft ~= "dap-repl" then
      return
    end

    -- Detach whatever attached here (copilot, etc.)
    local client_id = args.data and args.data.client_id or nil
    if not client_id then
      return
    end

    vim.schedule(function()
      pcall(vim.lsp.buf_detach_client, args.buf, client_id)
    end)
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count >= 5000 then
      vim.cmd "IlluminatePauseBuf"
    end
  end,
})
