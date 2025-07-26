# --- Pyenv Setup ---
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
fi
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# --- NVM (Node Version Manager) ---
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- Keychain ---
if ! command -v keychain >/dev/null; then
  echo "keychain not found. Install it via your package manager (e.g. brew, apt)."
else
  eval $(keychain --quiet --eval id_ed25519)
fi

# --- Zoxide (smarter cd) ---
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

# --- FZF (fuzzy finder) ---
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi
