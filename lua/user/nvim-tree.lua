local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local api_status_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
if not api_status_ok then
  return
end

nvim_tree.setup {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  git = {
    enable = false,
  },
  view = {
    width = 30,
    side = "left",
  },
  on_attach = function(bufnr)
    nvim_tree_api.config.mappings.default_on_attach(bufnr)

    local function opts(desc)
      return { buffer = bufnr, desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set("n", "l", nvim_tree_api.node.open.edit, opts "Open")
    vim.keymap.set("n", "<CR>", nvim_tree_api.node.open.edit, opts "Open")
    vim.keymap.set("n", "o", nvim_tree_api.node.open.edit, opts "Open")
    vim.keymap.set("n", "h", nvim_tree_api.node.navigate.parent_close, opts "Close Directory")
    vim.keymap.set("n", "v", nvim_tree_api.node.open.vertical, opts "Open: Vertical Split")
  end,
}
