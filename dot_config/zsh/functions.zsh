#!/usr/bin/env zsh
# Custom Functions

# --- Yazi: cd to directory on exit ---
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --- Extract any archive ---
function extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.7z)      7z x "$1" ;;
      *.zst)     unzstd "$1" ;;
      *.rar)     unrar x "$1" ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a file"
  fi
}

# --- Quick HTTP server ---
function serve() {
  local port="${1:-8080}"
  echo "🌐 Serving on http://localhost:$port"
  python3 -m http.server "$port"
}

# --- Git quick commit ---
function gc() {
  git add -A && git commit -m "${1:-update}" && git push
}

# --- Find process on port ---
function port() {
  lsof -i ":${1}" | grep LISTEN
}

# --- Kill process on port ---
function killport() {
  lsof -ti ":${1}" | xargs kill -9
}

# --- Create dir and cd into it ---
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# --- Backup file ---
function backup() {
  cp "$1"{,.bak}
}

# --- Get weather ---
function weather() {
  curl "wttr.in/${1:-}"
}

# --- Cheat sheet ---
function cheat() {
  curl "cheat.sh/${1}"
}

# --- Search history ---
function hs() {
  history | grep "$1"
}

# --- Update all tools ---
function update-all() {
  echo "📦 Updating system packages..."
  if command -v apt >/dev/null; then
    sudo apt update && sudo apt upgrade -y
  elif command -v pacman >/dev/null; then
    sudo pacman -Syu --noconfirm
  elif command -v dnf >/dev/null; then
    sudo dnf upgrade -y
  fi

  echo "🦀 Updating Rust..."
  command -v rustup >/dev/null && rustup update

  echo "🚀 Updating Starship..."
  command -v starship >/dev/null && starship update

  echo "📦 Updating mise tools..."
  command -v mise >/dev/null && mise upgrade

  echo "🐚 Updating ZSH plugins..."
  antidote update

  echo "🔄 Updating chezmoi dotfiles..."
  chezmoi update --apply

  echo "✅ All updates complete!"
}

# --- Fuzzy cd into directory ---
function fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git | fzf --preview 'eza --tree --level=2 --icons {}')
  [ -n "$dir" ] && cd "$dir"
}

# --- Fuzzy edit file ---
function fe() {
  local file
  file=$(fd --type f --hidden --follow --exclude .git | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
  [ -n "$file" ] && $EDITOR "$file"
}

# --- Git checkout branch with fzf ---
function gcof() {
  local branch
  branch=$(git branch --all | grep -v HEAD | sed 's/^..//' | fzf --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {}')
  [ -n "$branch" ] && git checkout "$branch"
}

# --- Docker stop all containers ---
function docker-stop-all() {
  docker ps -q | xargs -r docker stop
}

# --- Docker remove all containers ---
function docker-rm-all() {
  docker ps -aq | xargs -r docker rm
}

# --- Show command execution time ---
function time-zsh() {
  time zsh -i -c exit
}

# --- Edit ZSH core files ---

function editzshrc() {
  $EDITOR "$ZDOTDIR/.zshrc"
}

function editenv() {
  $EDITOR "$ZDOTDIR/env.zsh"
}

function editaliases() {
  $EDITOR "$ZDOTDIR/aliases.zsh"
}

function editfunc() {
  $EDITOR "$ZDOTDIR/functions.zsh"
}

function editplugins() {
  $EDITOR "$ZDOTDIR/plugins.zsh"
}

function editprompt() {
  $EDITOR "$ZDOTDIR/prompt.zsh"
}

function editpluglist() {
  $EDITOR "$ZDOTDIR/.zsh_plugins.txt"
}
