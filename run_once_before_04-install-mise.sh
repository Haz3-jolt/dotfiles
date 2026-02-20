#!/bin/bash
set -euo pipefail

if ! command -v mise >/dev/null; then
  echo "📦 Installing mise (runtime manager)..."
  curl https://mise.run | sh
  
  # Add to PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "✅ mise already installed"
fi