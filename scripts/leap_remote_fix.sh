#!/usr/bin/env bash
set -euo pipefail

# Fix leap.nvim remote after move to Codeberg.
# Usage:
#   ./scripts/leap_remote_fix.sh
#   ./scripts/leap_remote_fix.sh /custom/path/to/nvim/data

NVIM_DATA_DIR="${1:-${XDG_DATA_HOME:-$HOME/.local/share}/nvim}"
LEAP_DIR="$NVIM_DATA_DIR/lazy/leap.nvim"
TARGET_URL="https://codeberg.org/andyg/leap.nvim"

if [[ ! -d "$LEAP_DIR/.git" ]]; then
  echo "leap.nvim checkout not found at: $LEAP_DIR"
  echo "Install/update plugins first (e.g. :Lazy sync), then run this script again."
  exit 1
fi

echo "Updating leap.nvim remote in: $LEAP_DIR"
git -C "$LEAP_DIR" remote set-url origin "$TARGET_URL"
git -C "$LEAP_DIR" remote -v

echo "Done. Leap origin now points to Codeberg."
