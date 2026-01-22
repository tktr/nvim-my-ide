local status_ok, ai_terminals = pcall(require, "ai-terminals")
if not status_ok then
  return
end

-- function _G.set_terminal_keymaps()
--   local opts = { noremap = true }
--     vim.keymap.set("n", "<leader>wa", function() require("ai-terminals").add_files_to_terminal("aichat", {vim.fn.expand("%")}) end, { desc = "Add current file to Aichat" })
--     vim.keymap.set("n", "<leader>wA", function() require("ai-terminals").add_buffers_to_terminal("aichat") end, { desc = "Add all buffers to Aichat" })
--     vim.keymap.set("n", "<leader>wr", function() require("ai-terminals").add_files_to_terminal("aichat", {vim.fn.expand("%")}, { read_only = true }) end, { desc = "Add current file to Aichat (read-only)" })
--     vim.keymap.set({"n", "v"}, "<leader>wda", function() require("ai-terminals").send_diagnostics("aichat") end, { desc = "Send diagnostics to Aichat" })
-- end

ai_terminals.setup {
  level = "info",
  backend = "tmux", -- Explicitly use tmux backend (auto-detected if in tmux)
  -- Optional tmux-specific configuration
  tmux = {
    width = 0.9, -- 90% of terminal width
    height = 0.9, -- 90% of terminal height
    flags = {
      close_on_exit = true, -- Close popup when command exits
      start_directory = function()
        return vim.fn.getcwd()
      end, -- Start in current working directory
    },
    -- Uncomment to add global toggle key for all tmux popups
    -- toggle = {
    --   key = "-n F1", -- Global F1 key to toggle
    --   mode = "force-close"
    -- },
  },

  -- Your existing configuration...
  terminals = {
    aichat = {
      cmd = function()
        return string.format(
          "aichat"
          -- "AICHAT_LIGHT_THEME=%s aichat -r %%functions%% --session",
          -- Convert boolean to string "true" or "false"
          -- tostring(vim.o.background == "light")
        )
      end,
      path_header_template = "@file %s --", -- Default: @ prefix
    },
    -- ... other terminals
  },
}
--       require("ai-terminals").setup(opts)
--       -- Define your keymaps here or in a separate keymap file
--
--       -- Diff Tools
