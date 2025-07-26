#!/usr/bin/env bash

set -euo pipefail

# --- Config ---
PYTHON_VERSION="3.13.5"
DOTFILES_DIR="$HOME/dotfiles"
ZSHRC="$HOME/.zshrc"
CONFIG_DIR="$HOME/.config"
PYENV_ROOT="$HOME/.pyenv"

# --- 1. System Packages ---
echo "[*] Installing system packages..."
sudo apt update
sudo apt install -y \
  build-essential \
  curl \
  git \
  zsh \
  bat \
  fd-find \
  ripgrep \
  unzip \
  xz-utils \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  llvm \
  libncursesw5-dev \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev

# --- 2. Rust ---
if ! command -v rustc >/dev/null 2>&1; then
  echo "[*] Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  export PATH="$HOME/.cargo/bin:$PATH"
else
  echo "[*] Rust already installed. Skipping."
fi

# --- 3. eza ---
if ! command -v eza >/dev/null 2>&1; then
  echo "[*] Installing eza..."
  URL=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
    | jq -r '.assets[] | select(.name | endswith("_amd64.deb")) | .browser_download_url')
  curl -LO "$URL"
  sudo apt install -y ./eza_*_amd64.deb
  rm ./eza_*_amd64.deb
else
  echo "[*] eza already installed. Skipping."
fi

# --- 4. pyenv + Python ---
if [ ! -d "$PYENV_ROOT" ]; then
  echo "[*] Installing pyenv..."
  git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
else
  echo "[*] pyenv already installed. Skipping."
fi

export PATH="$PYENV_ROOT/bin:$PATH"

if ! command -v pyenv >/dev/null 2>&1; then
  echo "[!] pyenv not found in PATH after install. Check manually."
  exit 1
fi

if ! pyenv versions --bare | grep -q "^${PYTHON_VERSION}\$"; then
  echo "[*] Installing Python $PYTHON_VERSION via pyenv..."
  pyenv install "$PYTHON_VERSION"
else
  echo "[*] Python $PYTHON_VERSION already installed via pyenv. Skipping."
fi

pyenv global "$PYTHON_VERSION"

# --- 5. Zsh ---
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "[*] Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
fi

# --- 6. Dotfiles Linking ---
echo "[*] Linking dotfiles..."
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$ZSHRC"

mkdir -p "$CONFIG_DIR"
ln -snf "$DOTFILES_DIR/config" "$CONFIG_DIR"

# --- Done ---
echo "[✔] Installation complete. Restart terminal or run: exec zsh"
