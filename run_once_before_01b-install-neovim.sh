#!/bin/bash
set -euo pipefail

REQUIRED="0.11.2"

current_ver() {
  nvim --version 2>/dev/null | head -1 | grep -oP 'v\K[0-9]+\.[0-9]+\.[0-9]+'
}

version_ge() {
  printf '%s\n%s' "$1" "$2" | sort -V | head -1 | grep -qx "$2"
}

CURRENT=$(current_ver || echo "0.0.0")

if version_ge "$CURRENT" "$REQUIRED"; then
  echo "✔ Neovim $CURRENT already meets requirement (>= $REQUIRED)"
  exit 0
fi

echo "⬆️  Neovim $CURRENT is too old, installing >= $REQUIRED..."

ARCH=$(uname -m)
OS=$(uname -s)

if [ "$OS" = "Linux" ]; then
  TARBALL="nvim-linux-${ARCH}.tar.gz"
  curl -Lo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/${TARBALL}"
  sudo rm -rf /opt/nvim
  sudo tar xzf /tmp/nvim.tar.gz -C /opt
  sudo mv /opt/nvim-linux-${ARCH} /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm /tmp/nvim.tar.gz
elif [ "$OS" = "Darwin" ]; then
  brew install neovim --HEAD || brew upgrade neovim
fi

echo "✅ Neovim $(current_ver) installed"
