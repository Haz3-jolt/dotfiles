#!/usr/bin/env zsh
# Plugin Configuration

# Initialize completion system
autoload -Uz compinit

mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# --- Zoxide (smarter cd) ---
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh --cmd cd --hook prompt)"
fi

# --- FZF ---
if command -v fzf >/dev/null; then
  source <(fzf --zsh 2>/dev/null) || { [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh; }
fi

# --- Mise (runtime manager - replaces nvm/pyenv/rbenv) ---
if command -v mise >/dev/null; then
  eval "$(mise activate zsh)"
fi

# --- Direnv (auto-load project environments) ---
if command -v direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi

# --- Atuin (shell history sync & search) ---
if command -v atuin >/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# --- Antidote Plugin Manager ---
# Install if missing
if [[ ! -d "$ZDOTDIR/.antidote" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ZDOTDIR/.antidote"
fi

# Source antidote
source "$ZDOTDIR/.antidote/antidote.zsh"

# Load plugins
antidote load "$ZDOTDIR/.zsh_plugins.txt"
