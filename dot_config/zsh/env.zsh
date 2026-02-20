#!/usr/bin/env zsh
# Environment Variables & PATH

# --- XDG Base Directories ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"

mkdir -p "$XDG_STATE_HOME/zsh"
mkdir -p "$HOME/.local/bin"

# --- ZSH History ---
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=50000
export SAVEHIST=50000
setopt EXTENDED_HISTORY          # Record timestamp
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicates
setopt HIST_FIND_NO_DUPS         # Don't show duplicates in search
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates
setopt SHARE_HISTORY             # Share history between sessions

# --- Editors ---
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"

# --- FZF Configuration ---
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --info=inline
  --color=fg:#c0caf5,bg:#1a1b26,hl:#7aa2f7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# --- Mise (runtime manager) ---
export MISE_CONFIG_DIR="$XDG_CONFIG_HOME/mise"

# --- Bun (JavaScript runtime) ---
export BUN_INSTALL="$HOME/.bun"

# --- SSH Agent (systemd-managed) ---
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# --- GPG ---
export GPG_TTY=$(tty)

# --- PATH ---
typeset -U PATH path  # Remove duplicates
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$BUN_INSTALL/bin"
  "$XDG_DATA_HOME/mise/shims"
  $path
)
export PATH
