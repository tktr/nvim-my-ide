local opts = { noremap = true, silent = true }

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}

-- Now the '+' register will copy to system clipboard using OSC52
vim.keymap.set('n', '<leader>Y', '"+y')
vim.keymap.set('n', '<leader>YY', '"+yy')
vim.keymap.set('v', '<leader>Y', '"+y')

vim.keymap("n", "<C-d>", "<C-d>zz", opts)
vim.keymap("n", "<C-u>", "<C-u>zz", opts)
