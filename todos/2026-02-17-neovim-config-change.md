# TODO: neovim-config-change

## P3 - Deferred maintenance
- [ ] Unpin `leap.nvim` in `lua/user/plugins.lua` after upstream move/redirect noise is fully resolved.
  - Current temporary state: `pin = true` is set for `https://codeberg.org/ggandor/leap.nvim`.
  - Validation when unpinning: run `:Lazy sync` and confirm no recurring move/redirect warning.

## Applied patch (repeat on other machines)
- Git remote patch for installed plugin checkout:
  - `git -C ~/.local/share/nvim/lazy/leap.nvim remote set-url origin https://codeberg.org/ggandor/leap.nvim`
- Script alternative from this repo:
  - `./scripts/leap_remote_fix.sh`
