# Brainstorm: neovim-config-change

## Objective
Plan a targeted change to this Neovim configuration repository using the compound workflow.

## Candidate Change Areas
1. LSP ergonomics
   - tune diagnostics, inlay hints, server defaults, or formatting flow
   - key files: `lua/user/lsp/*.lua`, `lua/user/lsp/settings/*.lua`
2. Editing UX and keymaps
   - streamline mappings, reduce conflicts, improve discoverability
   - key files: `lua/user/keymaps.lua`, `lua/user/whichkey.lua`
3. Performance and startup
   - plugin lazy-load boundaries, startup sequencing, optional dependency guards
   - key files: `lua/user/plugins.lua`, `init.lua`, `lua/user/impatient.lua`
4. Navigation and search
   - telescope, project switching, tree behavior, file discovery defaults
   - key files: `lua/user/telescope.lua`, `lua/user/project.lua`, `lua/user/nvim-tree.lua`

## Decision Inputs Needed
- Primary pain point to solve.
- Expected behavior after change.
- Whether this is a minimal tweak or broader refactor.

## Verification Strategy
- Start Neovim: `nvim` (ensure startup remains clean).
- Run health checks: `:checkhealth`.
- Manually validate changed workflow/key-paths in-editor.
