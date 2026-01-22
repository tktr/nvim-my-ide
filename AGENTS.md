# AGENTS.md

Agent-facing notes for this Neovim config repository.

## Repository shape

- Entry point: `init.lua` requires modules under `lua/user/*`.
- Primary languages: Lua (Neovim config). No automated test suite.

## Commands

### Run Neovim (local)

- Start Neovim with this config:
  - `nvim`

### Health / diagnostics

This repo has no automated test suite. The closest thing to a “test suite” is running `:checkhealth`.

#### Inside Neovim (interactive)

- Run built-in health checks:
  - `:checkhealth`

#### Headless (CI / scripting)

Neovim's health UI can be written to a file using `:w!`.

```sh
nvim --headless -u ~/.config/nvim/init.lua +"checkhealth" +"w! health.log" +"qa"
```

You can do the same for a specific section:

```sh
nvim --headless -u ~/.config/nvim/init.lua +"checkhealth dap" +"w! health-dap.log" +"qa"
nvim --headless -u ~/.config/nvim/init.lua +"checkhealth mason" +"w! health-mason.log" +"qa"
nvim --headless -u ~/.config/nvim/init.lua +"checkhealth lazy" +"w! health-lazy.log" +"qa"
```

Note: `vim.ui_attach(...)` is not available in headless mode here (it errors with `invalid ns_id`).

### Build Neovim (if you need the pinned baseline)

Documented in `README.md` for Neovim 0.8:

```sh
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout release-0.8
make CMAKE_BUILD_TYPE=Release
sudo make install
```

### Plugin / runtime build steps (inside Neovim)

- Tree-sitter parser update (also used as a plugin `build` hook):
  - `:TSUpdate`

### Formatters/linters used by this config

This repo does **not** have Make/Just/npm/python command runners. Formatting and
linting are primarily driven via Neovim tooling:

- Lua formatting: `stylua`
  - Config: `.stylua.toml`
- null-ls/none-ls configured formatters (see `lua/user/lsp/none-ls.lua`):
  - `prettier` (with extra args `--no-semi --single-quote --jsx-single-quote`)
  - `black --fast`
  - `stylua`
  - `google-java-format`

Notes:
- Python “organize imports” on save is implemented via an LSP code action on
  `BufWritePre *.py` (see `lua/user/autocommands.lua`).
- Pyright is configured for strict type checking but with several diagnostics
  downgraded/suppressed (see `lua/user/lsp/settings/pyright.lua`).

### Running a single test

There is no test runner and no `tests/` / `spec/` directory. If you need
verification, use:

1. `nvim` and ensure startup is clean.
2. `:checkhealth`
3. Reproduce the scenario manually in Neovim.

If you introduce tests later (e.g., Plenary/Busted), also add a documented
single-test command here.

## Code style guidelines

### Lua formatting (authoritative)

Follow `.stylua.toml`:

- Indentation: 2 spaces
- Line endings: Unix
- `column_width = 120`
- Quote style: prefer double quotes
- `no_call_parentheses = true` (omit parentheses on no-arg calls)

If you touch Lua, run:

- `stylua .`

### Indentation and editor behavior

Repo defaults (see `lua/user/options.lua`):

- `expandtab = true`, `shiftwidth = 2`, `tabstop = 2`
- `wrap = false` by default

### Imports / module structure

- Root module loading is explicit in `init.lua` using:
  - `require "user.<module>"`
- Prefer a stable module structure:
  - `local M = {}` then `return M` for modules exporting functions/tables.
- Prefer `local x = ...` for locals; keep globals to a minimum.

### Defensive requires / optional dependencies

This repo regularly guards optional plugins/modules:

```lua
local ok, mod = pcall(require, "some.module")
if not ok then
  return
end
```

Use this pattern when integrating optional plugins, so Neovim startup remains
resilient.

### Types

- This is Lua; type checking is mostly via language servers.
- When editing LSP settings, follow existing table-based configuration patterns
  in `lua/user/lsp/settings/*`.

### Naming conventions

- Use descriptive snake_case for locals (`lazypath`, `status_ok`, `bufnr`).
- Keep mapping/function names consistent with Neovim conventions.

### Error handling

- Prefer returning early on non-critical failures (optional plugins).
- For hard failures during bootstrapping, use `vim.api.nvim_echo` and exit, as
  done in `lua/user/plugins.lua` when cloning `lazy.nvim` fails.

### Autocommands

- Prefer `vim.api.nvim_create_autocmd` with Lua callbacks.
- Keep patterns scoped (`pattern = {"*.py"}` etc.) and avoid expensive work on
  every event. See `lua/user/autocommands.lua` for examples.

## Cursor / Copilot rules

- No `.cursorrules`, `.cursor/rules/`, or `.github/copilot-instructions.md`
  exist in this repo at time of writing.

## What to do when changing behavior

- Make the smallest change that solves the problem.
- Keep startup stable: avoid introducing new hard dependencies without guarding
  them.
- Prefer adding new formatters/linters via `lua/user/lsp/none-ls.lua` rather
  than adding external scripts.
