#!/bin/bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

if command -v mise >/dev/null; then
  echo "📦 Installing runtimes via mise..."
  
  mise use --global node@lts
  mise use --global python@latest
  
  echo "✅ Runtimes installed"
else
  echo "⚠️  mise not found, skipping runtime installation"
fi