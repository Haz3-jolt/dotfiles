#!/bin/bash
set -euo pipefail

echo "📁 Creating XDG directories..."

mkdir -p \
  "$HOME/.config" \
  "$HOME/.local/bin" \
  "$HOME/.local/share" \
  "$HOME/.local/state/zsh" \
  "$HOME/.cache"

echo "✅ Directories created"