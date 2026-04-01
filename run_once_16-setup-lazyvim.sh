#!/bin/bash
set -euo pipefail

LAZY_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/lazy.nvim"

if [ -d "$LAZY_DIR" ]; then
  echo "✔ LazyVim already bootstrapped"
  exit 0
fi

echo "🚀 Setting up LazyVim..."

# Ensure neovim is available
if ! command -v nvim >/dev/null 2>&1; then
  echo "⚠️  neovim not found, skipping LazyVim setup"
  exit 0
fi

# Run nvim headless to trigger lazy.nvim bootstrap and plugin install
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo "✅ LazyVim setup complete"
