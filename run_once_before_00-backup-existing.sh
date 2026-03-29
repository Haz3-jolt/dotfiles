#!/bin/bash
set -euo pipefail

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
BACKED_UP=false

backup() {
  local src="$1"
  local dest="$BACKUP_DIR/$2"
  if [ -e "$src" ] && [ ! -L "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    mv "$src" "$dest"
    BACKED_UP=true
    echo "  📁 $src → $dest"
  fi
}

echo "🔍 Checking for existing dotfiles to back up..."

# Files chezmoi will manage
backup "$HOME/.zshenv"                    ".zshenv"
backup "$HOME/.zshrc"                     ".zshrc"
backup "$HOME/.bashrc"                    ".bashrc"
backup "$HOME/.bash_profile"              ".bash_profile"
backup "$HOME/.gitconfig"                 ".gitconfig"
backup "$HOME/.config/zsh"                ".config/zsh"
backup "$HOME/.config/starship.toml"      ".config/starship.toml"
backup "$HOME/.config/mise"               ".config/mise"

if [ "$BACKED_UP" = true ]; then
  echo "✅ Existing dotfiles backed up to $BACKUP_DIR"
else
  echo "✅ No existing dotfiles to back up — clean install"
fi
