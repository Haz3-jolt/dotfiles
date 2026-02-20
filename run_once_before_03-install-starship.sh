#!/bin/bash
set -euo pipefail

if ! command -v starship >/dev/null; then
  echo "🚀 Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "✅ Starship already installed"
fi