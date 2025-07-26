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
  jq \
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
  liblzma-dev \
  xclip \
  keychain

# --- 2. Rust ---
if ! command -v rustc >/dev/null 2>&1; then
  echo "[*] Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  echo "[*] Rust already installed. Skipping."
fi

# --- 3. eza ---
if ! command -v eza >/dev/null 2>&1; then
  echo "[*] Installing eza via apt..."
  if sudo apt install -y eza; then
    echo "[*] eza installed successfully."
  else
    echo "[!] apt install failed for eza. Will notify at end."
    EZA_FAILED=1
  fi
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

# --- 4.1 pyenv-virtualenv plugin ---
if [ ! -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
  echo "[*] Installing pyenv-virtualenv plugin..."
  git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
else
  echo "[*] pyenv-virtualenv already installed. Skipping."
fi

export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"  # this will now work

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

if [ "$EZA_FAILED" -eq 1 ]; then
  echo "[!] Warning: eza failed to install. You can try installing manually from https://github.com/eza-community/eza"
fi
