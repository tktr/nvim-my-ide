# Solution: Handle Codeberg-moved Neovim plugins (lazy.nvim)

## Problem
Some Neovim plugins (e.g. `leap.nvim`) move from GitHub to Codeberg. If your config still points at the old repo (or if you pinned to work around redirects), plugin updates can produce warnings/errors or require manual cache/remote fixes.

## Approach
1. Update the plugin spec to the canonical upstream repository (prefer the project’s official “moved to …” destination).
2. Remove temporary pinning/workarounds once the canonical URL is in use.
3. If a machine has an existing plugin checkout with the old remote, update its `origin` URL once.

## Example (this repo)
- Update plugin URL to Codeberg canonical:
  - `lua/user/plugins.lua` → `https://codeberg.org/andyg/leap.nvim`
- One-time local checkout fix (if needed):
  - `./scripts/leap_remote_fix.sh`

## Verification
- Run `:Lazy sync` (or equivalent) and ensure no recurring move/redirect warnings.
- Confirm startup is stable and `:checkhealth lazy` is not reporting plugin-specific issues.
