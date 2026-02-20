#!/bin/bash
set -euo pipefail

ANTIDOTE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.antidote"

if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  echo "📦 Installing Antidote ZSH plugin manager..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
  echo "✅ Antidote already installed"
fi