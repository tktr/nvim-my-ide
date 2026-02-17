# Review: neovim-config-change

## Objective
Resolve `leap.nvim` upstream move noise by removing pinning and pointing the plugin spec at the canonical Codeberg repository.

## Changes Reviewed
- `lua/user/plugins.lua`: updated `leap.nvim` URL to Codeberg canonical repo and removed pin.
- `scripts/leap_remote_fix.sh`: update remote-fix target URL.
- `todos/2026-02-17-neovim-config-change.md`: close deferred item and update remediation instructions.

## Verification
- `nvim --headless +checkhealth` (captured in `health.log`).
- Verified Codeberg canonical upstream: `https://codeberg.org/andyg/leap.nvim`.

## Findings
- The prior pin/remote workaround is no longer needed when using the canonical Codeberg repo URL.
- `:checkhealth` shows several unrelated tooling warnings (luarocks, prettier, etc.) but nothing specific to `leap.nvim`.

## Risks / Regressions
- If a machine has an existing `~/.local/share/nvim/lazy/leap.nvim` checkout with an old remote, it may still need a one-time remote update (script provided).

## Follow-ups
- None for this topic.
