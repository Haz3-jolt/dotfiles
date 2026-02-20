#!/bin/bash
set -euo pipefail

if ! command -v uv >/dev/null; then
  echo "⚡ Installing uv (fast Python package installer)..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  
  # Add to PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "✅ uv already installed"
fi