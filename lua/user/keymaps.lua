-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
-- Jump to whitespace
keymap("n", "<leader>.", "f ", opts)
keymap("n", "<leader>,", "F ", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope git_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)

keymap("n", "<leader>dR", function()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end

  dap.repl.open({ height = 12 }, "vsplit")
end, opts)

keymap("n", "<leader>dF", function()
  local ok, dapui = pcall(require, "dapui")
  if ok and dapui and dapui.float_element then
    dapui.float_element("repl", {
      enter = true,
      width = 120,
      height = 25,
      position = "center",
    })
    return
  end

  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end

  dap.repl.open({ height = 12 }, "belowright split")
end, opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)

keymap("n", "<leader>dP", function()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end

  local configs = dap.configurations and dap.configurations.python or nil
  if not configs or not configs[1] then
    return
  end

  -- Runs the highest-priority python config, which we insert as:
  -- "Pytest: current file" (see lua/user/dap.lua)
  dap.run(configs[1])
end, opts)

keymap("n", "<leader>dTm", function()
  local status_ok, dap_python = pcall(require, "dap-python")
  if not status_ok then
    return
  end

  dap_python.test_method()
end, opts)

keymap("n", "<leader>dTc", function()
  local status_ok, dap_python = pcall(require, "dap-python")
  if not status_ok then
    return
  end

  dap_python.test_class()
end, opts)

keymap("n", "<leader>dTf", function()
  local status_ok, dap_python = pcall(require, "dap-python")
  if not status_ok then
    return
  end

  dap_python.test_file()
end, opts)

-- Clipboard
-- '+' register will copy to system clipboard using OSC52 - natively supported since neovim 10.0
keymap("n", "<leader>Y", '"+y', opts)
keymap("n", "<leader>YY", '"+yy', opts)
keymap("v", "<leader>Y", '"+y', opts)

-- Copilot
keymap("i", "<C-x>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

-- Pyright
keymap("n", "<leader>lD", function()
  local clients = vim.lsp.get_clients { name = "pyright" }
  if not clients or #clients == 0 then
    return
  end

  local client = clients[1]
  local settings = client.config.settings or {}
  settings.python = settings.python or {}
  settings.python.analysis = settings.python.analysis or {}

  local current = settings.python.analysis.diagnosticMode or "openFilesOnly"
  local next_mode = (current == "workspace") and "openFilesOnly" or "workspace"
  settings.python.analysis.diagnosticMode = next_mode

  -- Persist back onto the client config and notify.
  client.config.settings = settings
  client.notify("workspace/didChangeConfiguration", { settings = settings })

  vim.notify("Pyright diagnosticMode: " .. next_mode, vim.log.levels.INFO)
end, opts)
