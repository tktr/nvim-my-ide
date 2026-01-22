local status_ok, tabnine = pcall(require, "tabnine")
if not status_ok then
  vim.notify "Unable to load tabnine"
  return
end
tabnine.setup {
  disable_auto_comment = true,
  accept_keymap = "<C-x>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 500,
  suggestion_color = { gui = "#808080", cterm = 244 },
  exclude_filetypes = { "TelescopePrompt", "NvimTree" },
  log_file_path = "/tmp/tabnine.log", -- absolute path to Tabnine log file
}
