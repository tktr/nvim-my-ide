# TODO: neovim-config-change

## P3 - Deferred maintenance
- [x] Unpin `leap.nvim` and point to canonical upstream.
  - Updated plugin spec to `https://codeberg.org/andyg/leap.nvim`.
  - Note: `lazy-lock.json` should still pin a valid commit; update it via `:Lazy sync` if needed.

## Applied patch (repeat on other machines)
- Git remote patch for installed plugin checkout:
  - `git -C ~/.local/share/nvim/lazy/leap.nvim remote set-url origin https://codeberg.org/andyg/leap.nvim`
- Script alternative from this repo:
  - `./scripts/leap_remote_fix.sh`
