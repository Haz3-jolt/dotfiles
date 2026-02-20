#!/bin/bash
set -euo pipefail

if ! command -v bun >/dev/null; then
  echo "🍞 Installing Bun (fast JavaScript runtime)..."
  curl -fsSL https://bun.sh/install | bash
  
  # Add to PATH for this session
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
else
  echo "✅ Bun already installed"
fi