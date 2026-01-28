local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")

local function first_exepath(candidates)
  for _, candidate in ipairs(candidates) do
    local resolved = vim.fn.exepath(candidate)
    if resolved ~= nil and resolved ~= "" then
      return resolved
    end
  end
end

local dap_python_status_ok, dap_python = pcall(require, "dap-python")
-- Keep the rest of DAP working even if python bits are unavailable.

local dap_virtual_text_ok, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if dap_virtual_text_ok then
  dap_virtual_text.setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
    commented = true,
    only_first_definition = true,
    all_references = false,
    clear_on_continue = false,
  }
end

local function project_root()
  local markers = { "pyproject.toml", ".git" }
  if vim.fs and vim.fs.root then
    return vim.fs.root(0, markers) or vim.fn.getcwd()
  end

  -- fallback for older Neovim
  local buf = vim.api.nvim_buf_get_name(0)
  local start = (buf ~= "" and vim.fn.fnamemodify(buf, ":p:h")) or vim.fn.getcwd()
  local found = vim.fn.findfile("pyproject.toml", start .. ";")
  if found ~= "" then
    return vim.fn.fnamemodify(found, ":p:h")
  end
  local gitdir = vim.fn.finddir(".git", start .. ";")
  if gitdir ~= "" then
    return vim.fn.fnamemodify(gitdir, ":p:h")
  end
  return vim.fn.getcwd()
end

if dap_python_status_ok then
  -- Use pytest for dap-python test helpers.
  dap_python.test_runner = "pytest"

  -- Ensure the debuggee uses the uv-managed project venv.
  -- This is separate from the adapter runtime.
  dap_python.resolve_python = function()
    local root = project_root()
    local uv_python = root .. "/.venv/bin/python"
    if vim.fn.executable(uv_python) == 1 then
      return uv_python
    end
    return first_exepath { "python3", "python" } or "python3"
  end

  -- Run the adapter through uv so debugpy is provisioned via `uv run --with debugpy ...`.
  -- Debuggee python is controlled via `dap_python.resolve_python` (above).
  dap_python.setup("uv", {
    pythonPath = function()
      return dap_python.resolve_python()
    end,
  })

  -- Run pytest under the debugger (matches `uv run pytest`).
  -- This avoids relative-import issues that happen when tests are launched
  -- as standalone scripts (`program = "${file}"`).
  dap.configurations.python = dap.configurations.python or {}
  table.insert(dap.configurations.python, 1, {
    type = "python",
    request = "launch",
    name = "Pytest: current file",
    module = "pytest",
    args = { "${file}" },
    cwd = project_root(),
    pythonPath = function()
      return dap_python.resolve_python()
    end,
  })
end

if dap_ui_status_ok then
  dapui.setup {
    expand_lines = true,
    icons = { expanded = "", collapsed = "", circular = "" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.33 },
          { id = "breakpoints", size = 0.17 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        size = 0.33,
        position = "right",
      },
      {
        elements = {
          { id = "repl", size = 0.45 },
          { id = "console", size = 0.55 },
        },
        size = 0.27,
        position = "bottom",
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.5, -- Floats will be treated as percentage of your screen.
      border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
  }
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.before.attach.dapui_config = function()
  if dap_ui_status_ok then
    dapui.open()
  end
end

dap.listeners.before.launch.dapui_config = function()
  if dap_ui_status_ok then
    dapui.open()
  end
end

dap.listeners.before.event_terminated.dapui_config = function()
  if dap_ui_status_ok then
    dapui.close()
  end
end

dap.listeners.before.event_exited.dapui_config = function()
  if dap_ui_status_ok then
    dapui.close()
  end
end
