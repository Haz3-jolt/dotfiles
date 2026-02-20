#!/bin/bash
set -euo pipefail

if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "🐚 Setting ZSH as default shell..."
  sudo chsh -s "$(command -v zsh)" "$USER"
  echo "⚠️  You'll need to log out and back in for this to take effect"
else
  echo "✅ ZSH already default shell"
fi