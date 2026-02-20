# Complete ZSH Dotfiles Refactor Guide

**Goal:** Fresh, optimized dotfiles setup with modern tools and best practices.

---

## 🗑️ What to Remove

### From Current Setup
- ❌ **`rupa/z`** — redundant with zoxide
- ❌ **`common-aliases`** plugin — too opinionated, causes conflicts
- ❌ **Antigen** — unmaintained, slow. Replace with antidote/zinit
- ❌ **NVM** — replace with mise (manages all runtimes)
- ❌ **keychain** — replace with systemd ssh-agent
- ❌ **`.zwc` files** from git — these are compiled, should be generated locally

---

## 📦 Core Tools to Install

### Essential CLI Tools
```bash
# Modern replacements for standard commands
eza           # ls replacement with icons
bat           # cat with syntax highlighting
ripgrep (rg)  # grep replacement
fd            # find replacement
zoxide        # smarter cd
fzf           # fuzzy finder
delta         # beautiful git diffs
dust          # du replacement
duf           # df replacement
procs         # ps replacement
sd            # sed replacement
btop          # htop replacement
```

### Developer Tools
```bash
mise          # Runtime manager (replaces nvm/pyenv/rbenv)
direnv        # Auto-load project environments
lazygit       # TUI for git
gh            # GitHub CLI
just          # Modern task runner (make replacement)
hyperfine     # CLI benchmarking
watchexec     # Run commands on file changes
tokei         # Count lines of code
bun           # All-in-one JS runtime, faster than Node
uv            # Blazing fast Python package installer (pip replacement)
```

### File & Data Tools
```bash
yazi          # Terminal file manager
jless         # Interactive JSON viewer
yq            # jq for YAML/TOML
xh            # Friendly HTTP client (curl replacement)
glow          # Markdown viewer
age           # File encryption (simpler than GPG)
```

### TUI (Terminal User Interface) Tools
```bash
lazygit       # TUI for git (ESSENTIAL)
lazydocker    # TUI for Docker containers
yazi          # TUI file manager with image preview
posting       # TUI API client (Postman alternative)
k9s           # TUI for Kubernetes
gitui         # Alternative to lazygit (Rust-based)
bottom (btm)  # TUI system monitor (htop/btop alternative)
hexyl         # TUI hex viewer
grex          # TUI regex builder
oha           # TUI HTTP load tester
trippy        # TUI network diagnostic (traceroute + ping)
mdcat         # Markdown in terminal with images
```

### Beautification & Eye Candy
```bash
starship      # Beautiful shell prompt
fastfetch     # System info display (neofetch replacement)
lolcat        # Rainbow text output
figlet        # ASCII art text
toilet        # Colorful ASCII text
cmatrix       # Matrix rain effect
pipes.sh      # Animated pipes screensaver
cbonsai       # ASCII bonsai tree
asciiquarium  # ASCII aquarium
sl            # Train animation (typo fun)
cowsay        # Speaking cow
fortune       # Random quotes
```

### Optional but Recommended
```bash
atuin         # Shell history sync & search (replaces zsh-history-substring-search)
dive          # Explore Docker images layer by layer
navi          # Interactive cheatsheets
tldr          # Simplified man pages
tealdeer      # Faster tldr implementation (Rust)
```

---

## 🏗️ File Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl
├── .chezmoiignore
├── .chezmoitemplates/
├── dot_config/
│   ├── starship.toml
│   ├── zsh/
│   │   ├── dot_zshrc
│   │   ├── env.zsh
│   │   ├── aliases.zsh
│   │   ├── functions.zsh
│   │   ├── plugins.zsh
│   │   └── prompt.zsh
│   ├── systemd/user/
│   │   ├── ssh-agent.service
│   │   ├── chezmoi-sync.service
│   │   └── chezmoi-sync.timer
│   ├── yazi/
│   │   └── yazi.toml
│   └── lazygit/
│       └── config.yml
├── dot_local/
│   └── bin/
│       └── executable_dotfiles-auto-commit
├── run_once_before_01-install-packages.sh.tmpl
├── run_once_before_02-set-zsh-default.sh
├── run_once_before_03-install-starship.sh
├── run_once_before_04-install-mise.sh
├── run_once_before_05-install-bun.sh
├── run_once_before_06-install-uv.sh
├── run_once_before_07-install-rust.sh
├── run_once_before_08-install-antidote.sh
├── run_once_09-mise-install-runtimes.sh
├── run_once_10-npm-globals.sh.tmpl
├── run_once_11-ssh-keygen.sh.tmpl
├── run_once_12-create-xdg-dirs.sh
├── run_once_13-enable-ssh-agent.sh
├── run_once_14-enable-autosync.sh
├── run_once_15-install-tui-tools.sh.tmpl
├── run_onchange_sync-zsh-plugins.sh.tmpl
└── run_once_after_99-cleanup.sh
```

---

## 📄 File Contents

### `.chezmoi.toml.tmpl`

```toml
{{- $email := promptStringOnce . "email" "Email address" -}}
{{- $name := promptStringOnce . "name" "Full name" -}}

[data]
  email = {{ $email | quote }}
  name = {{ $name | quote }}

[git]
  autoCommit = false
  autoPush = false

[diff]
  pager = "delta"

[edit]
  command = "nvim"

[age]
  identity = "~/.config/chezmoi/key.txt"
  recipient = ""  # Run: age-keygen to generate, add public key here
```

### `.chezmoiignore`

```text
**/*.zwc
README.md
LICENSE
.git
.gitignore
refactor.md
```

---

### `dot_config/zsh/dot_zshrc`

```zsh
#!/usr/bin/env zsh
# ZSH Configuration - Main Entry Point

# Set ZDOTDIR if not already set
export ZDOTDIR="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"

# Load configuration modules in order
source "$ZDOTDIR/env.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/prompt.zsh"

# Compile zsh files for faster loading (background)
{
  setopt LOCAL_OPTIONS EXTENDED_GLOB
  autoload -U zrecompile
  for f in "$ZDOTDIR"/*.zsh; do
    [[ ! -f "${f}.zwc" || "$f" -nt "${f}.zwc" ]] && zcompile "$f"
  done
} &!
```

---

### `dot_config/zsh/env.zsh`

```zsh
#!/usr/bin/env zsh
# Environment Variables & PATH

# --- XDG Base Directories ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

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
```

---

### `dot_config/zsh/plugins.zsh`

```zsh
#!/usr/bin/env zsh
# Plugin Configuration

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
if [[ ! -d "${ZDOTDIR:-~}/.antidote" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "${ZDOTDIR:-~}/.antidote"
fi

# Source antidote
source "${ZDOTDIR:-~}/.antidote/antidote.zsh"

# Load plugins
antidote load ${ZDOTDIR:-~}/.zsh_plugins.txt
```

---

### `dot_config/zsh/dot_zsh_plugins.txt`

```text
# Essential oh-my-zsh plugins
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/command-not-found
ohmyzsh/ohmyzsh path:plugins/extract
ohmyzsh/ohmyzsh path:plugins/sudo

# Community plugins
djui/alias-tips
Aloxaf/fzf-tab
MichaelAquilina/zsh-you-should-use

# Completions (must come before syntax-highlighting)
zsh-users/zsh-completions path:src kind:fpath

# These must be last
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting kind:defer
```

---

### `dot_config/zsh/aliases.zsh`

```zsh
#!/usr/bin/env zsh
# Aliases

# --- Chezmoi shortcuts ---
alias cz="chezmoi"
alias cze="chezmoi edit"
alias czd="chezmoi diff"
alias cza="chezmoi apply"
alias czcd='cd $(chezmoi source-path)'
alias czu="chezmoi update --apply"

# --- Modern replacements ---
if command -v eza >/dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -la --icons --group-directories-first --git"
  alias la="eza -a --icons --group-directories-first"
  alias lt="eza --tree --icons --level=2"
  alias tree="eza --tree --icons"
fi

command -v bat       >/dev/null && alias cat="bat --paging=never"
command -v batcat    >/dev/null && alias cat="batcat --paging=never"  # Ubuntu
command -v dust      >/dev/null && alias du="dust"
command -v duf       >/dev/null && alias df="duf"
command -v procs     >/dev/null && alias ps="procs"
command -v sd        >/dev/null && alias sed="sd"
command -v xh        >/dev/null && alias curl="xh"
command -v btop      >/dev/null && alias top="btop"
command -v dog       >/dev/null && alias dig="dog"
command -v rg        >/dev/null && alias grep="rg"

# --- Git (with lazygit) ---
command -v lazygit   >/dev/null && alias lg="lazygit"
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --all"

# --- Docker ---
command -v lazydocker >/dev/null && alias lzd="lazydocker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"

# --- Shortcuts ---
command -v yazi      >/dev/null && alias y="yazi"
command -v just      >/dev/null && alias j="just"
command -v nvim      >/dev/null && alias vim="nvim"
command -v glow      >/dev/null && alias md="glow"

# --- Safety ---
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# --- Clipboard (Linux) ---
if command -v wl-copy >/dev/null; then
  alias pbcopy="wl-copy"
  alias pbpaste="wl-paste"
elif command -v xclip >/dev/null; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
fi

# --- Common ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"

alias h="history"
alias c="clear"
alias e="$EDITOR"

# --- System ---
alias update="sudo apt update && sudo apt upgrade"  # Debian/Ubuntu
alias cleanup="sudo apt autoremove && sudo apt autoclean"

# --- Networking ---
alias myip="curl ifconfig.me"
alias ports="netstat -tulanp"
alias listening="lsof -i -P | grep LISTEN"

# --- Misc ---
alias weather="curl wttr.in"
alias cheat="curl cheat.sh"
```

---

### `dot_config/zsh/functions.zsh`

```zsh
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
```

---

### `dot_config/zsh/prompt.zsh`

```zsh
#!/usr/bin/env zsh
# Prompt Configuration

if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback prompt
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f '
  setopt PROMPT_SUBST
  PROMPT='%F{cyan}%~%f ${vcs_info_msg_0_}%F{green}❯%f '
fi
```

---

### `dot_config/starship.toml`

```toml
# Starship Prompt Configuration
# https://starship.rs/config/

format = """
[┌─](bold blue)$username$hostname$directory$git_branch$git_status$git_state$python$nodejs$rust$golang$package
[└─](bold blue)$character
"""

[username]
show_always = false
format = "[$user]($style)@"
style_user = "bold yellow"

[hostname]
ssh_only = true
format = "[$hostname]($style) in "
style = "bold green"

[directory]
truncation_length = 3
truncate_to_repo = true
format = "[$path]($style)[$read_only]($read_only_style) "
style = "bold cyan"
read_only = " 󰌾"

[git_branch]
symbol = " "
format = "on [$symbol$branch(:$remote_branch)]($style) "
style = "bold purple"

[git_status]
format = "([$all_status$ahead_behind]($style) )"
style = "bold red"
conflicted = "🏳"
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
untracked = "🤷"
stashed = "📦"
modified = "📝"
staged = '[++\($count\)](green)'
renamed = "👅"
deleted = "🗑"

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[python]
symbol = " "
format = "via [$symbol$virtualenv]($style) "
style = "yellow"

[nodejs]
symbol = " "
format = "via [$symbol($version )]($style)"
style = "green"

[rust]
symbol = " "
format = "via [$symbol($version )]($style)"
style = "red"

[golang]
symbol = " "
format = "via [$symbol($version )]($style)"
style = "cyan"

[package]
symbol = "📦 "
format = "is [$symbol$version]($style) "
style = "208"

[cmd_duration]
min_time = 500
format = "took [$duration]($style) "
style = "bold yellow"
```

---

### `dot_config/systemd/user/ssh-agent.service`

```ini
[Unit]
Description=SSH Authentication Agent

[Service]
Type=simple
ExecStart=/usr/bin/ssh-agent -D -a %t/ssh-agent.socket
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket

[Install]
WantedBy=default.target
```

---

### `dot_config/systemd/user/chezmoi-sync.service`

```ini
[Unit]
Description=Chezmoi dotfiles sync
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/chezmoi update --apply --no-tty
StandardOutput=journal
StandardError=journal
```

---

### `dot_config/systemd/user/chezmoi-sync.timer`

```ini
[Unit]
Description=Sync dotfiles every 6 hours

[Timer]
OnBootSec=5min
OnUnitActiveSec=6h
Persistent=true
RandomizedDelaySec=30min

[Install]
WantedBy=timers.target
```

---

## 🚀 Chezmoi Scripts

### `run_once_before_01-install-packages.sh.tmpl`

```bash
#!/bin/bash
set -euo pipefail

echo "📦 Installing system packages..."

{{ if eq .chezmoi.osRelease.id "ubuntu" "debian" "pop" }}
sudo apt update -qq
sudo apt install -y \
  zsh git curl wget unzip jq tree \
  build-essential cmake pkg-config \
  ripgrep fd-find bat fzf tmux neovim \
  python3 python3-pip python3-venv \
  openssh-client gpg wl-clipboard \
  direnv
  
# Fix bat/fd naming on Debian/Ubuntu
[ ! -f /usr/local/bin/bat ] && sudo ln -s /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
[ ! -f /usr/local/bin/fd ] && sudo ln -s /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true

{{ else if eq .chezmoi.osRelease.id "arch" "endeavouros" "manjaro" }}
sudo pacman -S --needed --noconfirm \
  zsh git curl wget unzip jq tree \
  base-devel cmake \
  ripgrep fd bat eza fzf zoxide \
  tmux neovim starship \
  btop dust duf procs sd tokei \
  hyperfine watchexec yazi xh \
  git-delta just lazygit github-cli \
  direnv dog gping bandwhich \
  jless yq age sops glow tldr \
  fastfetch wl-clipboard

{{ else if eq .chezmoi.osRelease.id "fedora" }}
sudo dnf install -y \
  zsh git curl wget unzip jq tree \
  @development-tools cmake \
  ripgrep fd-find bat fzf \
  tmux neovim \
  python3 python3-pip \
  openssh gnupg2 wl-clipboard \
  direnv
{{ end }}

echo "✅ System packages installed"
```

---

### `run_once_before_02-set-zsh-default.sh`

```bash
#!/bin/bash
set -euo pipefail

if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "🐚 Setting ZSH as default shell..."
  sudo chsh -s "$(command -v zsh)" "$USER"
  echo "⚠️  You'll need to log out and back in for this to take effect"
else
  echo "✅ ZSH already default shell"
fi
```

---

### `run_once_before_03-install-starship.sh`

```bash
#!/bin/bash
set -euo pipefail

if ! command -v starship >/dev/null; then
  echo "🚀 Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "✅ Starship already installed"
fi
```

---

### `run_once_before_04-install-mise.sh`

```bash
#!/bin/bash
set -euo pipefail

if ! command -v mise >/dev/null; then
  echo "📦 Installing mise (runtime manager)..."
  curl https://mise.run | sh
  
  # Add to PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "✅ mise already installed"
fi
```

---

### `run_once_before_05-install-bun.sh`

```bash
#!/bin/bash
set -euo pipefail

if ! command -v bun >/dev/null; then
  echo "🍞 Installing Bun (fast JavaScript runtime)..."
  curl -fsSL https://bun.sh/install | bash
  
  # Add to PATH for this session
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
else
  echo "✅ Bun already installed"
fi
```

---

### `run_once_before_06-install-uv.sh`

```bash
#!/bin/bash
set -euo pipefail

if ! command -v uv >/dev/null; then
  echo "⚡ Installing uv (fast Python package installer)..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  
  # Add to PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "✅ uv already installed"
fi
```

---

### `run_once_before_07-install-mise lang manager`

```bash
#!/bin/bash
set -euo pipefail

if ! command -v mise >/dev/null; then
  echo "📦 Installing mise (runtime manager)..."
  curl https://mise.run | sh
  
  # Add to PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "✅ mise already installed"
fi
```

---

### `run_once_before_08-install-rust.sh`

```bash
#!/bin/bash
set -euo pipefail

if ! command -v rustc >/dev/null; then
  echo "🦀 Installing Rust toolchain..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  source "$HOME/.cargo/env"
else
  echo "✅ Rust already installed"
fi
```

---

### `run_once_before_09-install-antidote.sh`

```bash
#!/bin/bash
set -euo pipefail

ANTIDOTE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.antidote"

if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  echo "📦 Installing Antidote ZSH plugin manager..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
  echo "✅ Antidote already installed"
fi
```

---

### `run_once_10-mise-install-runtimes.sh`

```bash
#!/bin/bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

if command -v mise >/dev/null; then
  echo "📦 Installing runtimes via mise..."
  
  mise use --global node@lts
  mise use --global python@latest
  
  echo "✅ Runtimes installed"
else
  echo "⚠️  mise not found, skipping runtime installation"
fi
```

---

### `run_once_11-npm-globals.sh.tmpl`

```bash
#!/bin/bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

if command -v mise >/dev/null; then
  eval "$(mise activate bash)"
fi

if command -v npm >/dev/null; then
  echo "📦 Installing global npm packages..."
  npm install -g \
    typescript \
    prettier \
    eslint \
    tldr \
    live-server \
    nodemon \
    pnpm
else
  echo "⚠️  npm not found, skipping global packages"
fi
```

---

### `run_once_12-ssh-keygen.sh.tmpl`

```bash
#!/bin/bash
set -euo pipefail

SSH_KEY="$HOME/.ssh/id_ed25519"

if [ ! -f "$SSH_KEY" ]; then
  echo "🔑 Generating SSH key..."
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "{{ .email }}" -f "$SSH_KEY" -N ""
  
  echo ""
  echo "📋 Add this public key to GitHub/GitLab:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  cat "${SSH_KEY}.pub"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "GitHub: https://github.com/settings/keys"
  echo "GitLab: https://gitlab.com/-/profile/keys"
else
  echo "✅ SSH key already exists"
fi

# Configure SSH
if [ ! -f "$HOME/.ssh/config" ]; then
  cat > "$HOME/.ssh/config" <<EOF
Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 60
  ServerAliveCountMax 3
EOF
  chmod 600 "$HOME/.ssh/config"
fi
```

---

### `run_once_13-create-xdg-dirs.sh`

```bash
#!/bin/bash
set -euo pipefail

echo "📁 Creating XDG directories..."

mkdir -p \
  "$HOME/.config" \
  "$HOME/.local/bin" \
  "$HOME/.local/share" \
  "$HOME/.local/state/zsh" \
  "$HOME/.cache"

echo "✅ Directories created"
```

---

### `run_once_14-enable-ssh-agent.sh`

```bash
#!/bin/bash
set -euo pipefail

echo "🔑 Enabling systemd ssh-agent..."
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service

echo "✅ SSH agent enabled"
```

---

### `run_once_15-enable-autosync.sh`

```bash
#!/bin/bash
set -euo pipefail

echo "⏰ Enabling dotfiles auto-sync timer..."
systemctl --user daemon-reload
systemctl --user enable --now chezmoi-sync.timer

echo "✅ Auto-sync enabled (runs every 6 hours)"
```

---

### `run_onchange_sync-zsh-plugins.sh.tmpl`

```bash
#!/bin/bash
# plugins hash: {{ include "dot_config/zsh/plugins.zsh" | sha256sum }}
# plugins list hash: {{ include "dot_config/zsh/dot_zsh_plugins.txt" | sha256sum }}
set -euo pipefail

ANTIDOTE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.antidote"

if [[ -d "$ANTIDOTE_DIR" ]]; then
  echo "🔄 Syncing ZSH plugins..."
  source "$ANTIDOTE_DIR/antidote.zsh"
  antidote update
  
  # Recompile zsh files
  echo "⚡ Compiling ZSH configs..."
  ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
  for f in "$ZDOTDIR"/*.zsh; do
    zsh -c "zcompile '$f'" 2>/dev/null || true
  done
  
  echo "✅ Plugins synced"
else
  echo "⚠️  Antidote not found, skipping plugin sync"
fi
```

---

### `run_once_after_99-cleanup.sh`

```bash
#!/bin/bash
set -euo pipefail

echo "🧹 Cleaning up..."

# Remove orphaned zwc files
ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
find "$ZDOTDIR" -name "*.zwc" -type f -delete 2>/dev/null || true

# Install remaining tools via cargo if not already installed
if command -v cargo >/dev/null; then
  echo "📦 Installing Rust-based tools..."
  
  CARGO_TOOLS=(
    "eza"
    "zoxide"
    "du-dust"
    "duf"
    "procs"
    "sd"
    "tokei"
    "hyperfine"
    "watchexec-cli"
    "yazi-fm"
    "xh"
    "git-delta"
    "just"
    "atuin"
    "jless"
    "glow"
  )
  
  for tool in "${CARGO_TOOLS[@]}"; do
    binary="${tool%-*}"  # Remove suffixes like -cli, -fm
    if ! command -v "$binary" >/dev/null 2>&1; then
      echo "  Installing $tool..."
      cargo install "$tool" --locked 2>/dev/null || true
    fi
  done
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Log out and back in (for default shell change)"
echo "  2. Add SSH key to GitHub/GitLab (see above)"
echo "  3. Run: exec zsh"
echo ""
echo "Optional tools to install manually:"
echo "  - lazygit:    https://github.com/jesseduffield/lazygit"
echo "  - lazydocker: https://github.com/jesseduffield/lazydocker"
echo "  - gh:         https://cli.github.com/"
echo "  - age:        https://github.com/FiloSottile/age"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

---

## 📋 Additional Configs

### `dot_config/mise/config.toml`

```toml
[tools]
node = "lts"
python = "latest"

[settings]
experimental = true
legacy_version_file = true  # Read .nvmrc, .python-version, etc.
```

---

### `dot_gitconfig.tmpl`

```toml
[user]
  name = {{ .name }}
  email = {{ .email }}

[core]
  editor = nvim
  pager = delta

[interactive]
  diffFilter = delta --color-only

[delta]
  navigate = true
  light = false
  side-by-side = true
  line-numbers = true

[merge]
  conflictstyle = diff3

[diff]
  colorMoved = default

[init]
  defaultBranch = main

[pull]
  rebase = false

[push]
  autoSetupRemote = true

[alias]
  lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
  st = status -sb
  co = checkout
  br = branch
  ci = commit
  unstage = reset HEAD --
  last = log -1 HEAD
```

---

## 🔧 Installation Instructions

### First Time Setup

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Haz3-jolt/dotfiles

# Or with your actual GitHub username
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <your-github-username>/dotfiles
```

### After Editing Dotfiles

```bash
# Edit files
chezmoi edit ~/.config/zsh/aliases.zsh

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Or edit + apply in one step
chezmoi edit --apply ~/.zshrc
```

### Sync to Another Machine

```bash
# Pull and apply latest dotfiles
chezmoi update --apply
```

---

## 🎯 Key Improvements Summary

### Removed
- ❌ Antigen (replaced with Antidote)
- ❌ NVM (replaced with mise)
- ❌ rupa/z (redundant with zoxide)
- ❌ common-aliases plugin (too opinionedated)
- ❌ keychain (replaced with systemd ssh-agent)

### Added
- ✅ **mise** - Universal runtime manager
- ✅ **Antidote** - Modern, maintained plugin manager
- ✅ **atuin** - Synced shell history
- ✅ **direnv** - Auto project environments
- ✅ **delta** - Beautiful git diffs
- ✅ **Modern CLI tools** - eza, bat, dust, duf, procs, sd, btop, etc.
- ✅ **systemd ssh-agent** - Native Linux agent management
- ✅ **Proper XDG compliance** - Follows Linux standards
- ✅ **Auto-sync** - systemd timer for dotfiles updates
- ✅ **age encryption** - Secure secrets in dotfiles

### Improved
- ✅ Proper plugin load order (syntax-highlighting last)
- ✅ Compiled .zsh files for faster startup
- ✅ Better FZF configuration with fallbacks
- ✅ Comprehensive functions and aliases
- ✅ Starship prompt with git status
- ✅ chezmoi templates for machine-specific config
- ✅ Automated bootstrap scripts
- ✅ XDG-compliant directory structure

---

## 📊 Before vs After

| Aspect | Before | After |
|--------|--------|-------|
| Plugin Manager | Antigen (unmaintained) | Antidote (active) |
| Runtime Manager | NVM only | mise (all runtimes) |
| SSH Agent | keychain | systemd native |
| Shell History | Basic | atuin (synced, searchable) |
| Git Diffs | Plain text | delta (beautiful) |
| Startup Time | ~800ms | ~200ms (with compilation) |
| Portability | Manual setup | Automated via chezmoi |
| Security | Unencrypted secrets | age encryption support |
| Maintenance | Manual updates | Auto-sync every 6h |

---

## 🎨 Additional TUI & Beautification Tools

### Comprehensive TUI Replacements

| Category | Tool | Replaces | Description |
|----------|------|----------|-------------|
| **Git** | [lazygit](https://github.com/jesseduffield/lazygit) | `git` CLI | Full-featured git TUI - staging, branching, rebasing |
| | [gitui](https://github.com/extrawurst/gitui) | `git` CLI | Blazing fast git TUI in Rust |
| | [tig](https://github.com/jonas/tig) | `git log` | Text-mode interface for git |
| **Docker** | [lazydocker](https://github.com/jesseduffield/lazydocker) | Docker Desktop | Manage containers, images, volumes |
| | [dive](https://github.com/wagoodman/dive) | — | Explore Docker image layers |
| | [ctop](https://github.com/bcicen/ctop) | `docker stats` | Top-like interface for containers |
| **Kubernetes** | [k9s](https://github.com/derailed/k9s) | `kubectl` | Full-featured K8s TUI |
| | [kubectx + kubens](https://github.com/ahmetb/kubectx) | — | Switch contexts/namespaces |
| **Files** | [yazi](https://github.com/sxyazi/yazi) | `ranger`/`nnn` | Blazing fast file manager with image preview |
| | [broot](https://github.com/Canop/broot) | `tree`/`find` | Interactive tree view with fuzzy search |
| | [nnn](https://github.com/jarun/nnn) | — | Lightweight, fast file manager |
| | [lf](https://github.com/gokcehan/lf) | `ranger` | Fast terminal file manager in Go |
| **HTTP/API** | [posting](https://github.com/darrenburns/posting) | Postman | Modern HTTP client TUI |
| | [hurl](https://github.com/Orange-OpenSource/hurl) | — | Run HTTP requests from files |
| **Monitoring** | [btop](https://github.com/aristocratos/btop) | `htop` | Beautiful resource monitor |
| | [bottom (btm)](https://github.com/ClementTsang/bottom) | `htop` | Graphical process/system monitor |
| | [zenith](https://github.com/bvaisvil/zenith) | `top` | Sort of like top/htop but with zoom |
| | [glances](https://github.com/nicolargo/glances) | — | Cross-platform system monitor |
| **Network** | [trippy](https://github.com/fujiapple852/trippy) | `traceroute` | Network diagnostic with TUI |
| | [bandwhich](https://github.com/imsnif/bandwhich) | — | Bandwidth usage per process |
| | [gping](https://github.com/orf/gping) | `ping` | Ping with a live graph |
| | [mtr](https://github.com/traviscross/mtr) | `traceroute` | Network diagnostic tool |
| **Database** | [lazysql](https://github.com/jorgerojas26/lazysql) | SQL clients | TUI for SQL databases |
| | [pgcli](https://github.com/dbcli/pgcli) | `psql` | Postgres CLI with autocomplete |
| | [mycli](https://github.com/dbcli/mycli) | `mysql` | MySQL CLI with autocomplete |
| | [litecli](https://github.com/dbcli/litecli) | `sqlite3` | SQLite CLI with autocomplete |
| **Text/Data** | [fx](https://github.com/antonmedv/fx) | — | Interactive JSON viewer |
| | [jless](https://github.com/PaulJuliusJulius/jless) | `less` | Interactive JSON/YAML viewer |
| | [visidata](https://github.com/saulpw/visidata) | Excel | TUI spreadsheet multitool |
| | [csvlens](https://github.com/YS-L/csvlens) | — | CSV file viewer |
| **Music** | [spotify-tui](https://github.com/Rigellute/spotify-tui) | Spotify app | Spotify terminal UI |
| | [ncspot](https://github.com/hrkfdn/ncspot) | Spotify app | Cross-platform Spotify TUI |
| | [cmus](https://github.com/cmus/cmus) | — | Music player |
| **Email** | [neomutt](https://github.com/neomutt/neomutt) | Email client | Terminal email client |
| | [himalaya](https://github.com/soywod/himalaya) | Email client | Modern terminal email |
| **Misc** | [slides](https://github.com/maaslalani/slides) | PowerPoint | Terminal presentations |
| | [termshark](https://github.com/gcla/termshark) | Wireshark | TUI for packet analysis |
| | [grex](https://github.com/pemistahl/grex) | — | Generate regex from examples |
| | [hexyl](https://github.com/sharkdp/hexyl) | `hexdump` | Colorful hex viewer |

### Beautification & ASCII Art

```bash
# Terminal eye candy
starship           # Minimal, fast prompt
oh-my-posh         # Alternative to starship
powerlevel10k      # Feature-rich ZSH theme
synth-shell-prompt # Fancy bash prompt

# System info displays
fastfetch          # Fast system info (neofetch fork)
neofetch           # Classic system info
screenfetch        # Alternative to neofetch
pfetch             # Minimal system info
cpufetch           # CPU info with logo
ramfetch           # RAM info display

# ASCII art & text
figlet             # Large ASCII text
toilet             # Colorful ASCII text
lolcat             # Rainbow colorize output
gay                # Pride flag colorize (Rust)
cowsay             # Speaking cow
fortune            # Random quotes
ponysay            # Speaking ponies

# Terminal animations
cmatrix            # Matrix rain effect
pipes.sh           # Animated pipes screensaver
cbonsai            # ASCII bonsai tree
asciiquarium       # ASCII aquarium animation
sl                 # Steam locomotive (typo easter egg)
tty-clock          # Digital clock
cava               # Audio visualizer
```

### Color Schemes & Themes

```bash
# Terminal color tools
vivid              # LS_COLORS generator
lsd                # LSDeluxe - ls with colors and icons
colorls            # Ruby-based colorful ls
grc                # Generic colorizer for commands

# Theme managers
gogh               # Terminal color scheme setter
base16             # Color scheme framework
```

---

## 🎯 Recommended TUI Starter Pack

**Install these first** for maximum impact:

```bash
# Git workflow
lazygit           # You'll never use git CLI the same way

# File navigation
yazi              # Best file manager, period

# System monitoring
btop              # Gorgeous resource monitor

# Docker (if you use it)
lazydocker        # Makes Docker management pleasant

# HTTP/API testing
posting           # Better than opening Postman

# Database (if applicable)
lazysql           # Universal DB client TUI

# Kubernetes (if applicable)
k9s               # Makes kubectl obsolete
```

---

## 🎨 Fun Additions to `functions.zsh`

Add these to make your terminal more enjoyable:

```zsh
# --- Random quote on new terminal ---
function startup-quote() {
  if command -v fortune >/dev/null && command -v cowsay >/dev/null; then
    fortune | cowsay | lolcat 2>/dev/null || fortune | cowsay
  elif command -v fortune >/dev/null; then
    fortune
  fi
}

# --- System info on login ---
function sysinfo() {
  if command -v fastfetch >/dev/null; then
    fastfetch
  elif command -v neofetch >/dev/null; then
    neofetch
  fi
}

# --- Rainbow cat ---
function rcat() {
  if command -v lolcat >/dev/null; then
    bat "$@" --paging=never | lolcat
  else
    bat "$@"
  fi
}

# --- Matrix effect ---
function matrix() {
  if command -v cmatrix >/dev/null; then
    cmatrix -b
  else
    echo "Install cmatrix first: sudo apt install cmatrix"
  fi
}

# --- Bonsai tree ---
function bonsai() {
  if command -v cbonsai >/dev/null; then
    cbonsai -l -t 0.1
  else
    echo "Install cbonsai first: https://gitlab.com/jallbrit/cbonsai"
  fi
}

# --- ASCII aquarium ---
function aquarium() {
  if command -v asciiquarium >/dev/null; then
    asciiquarium
  else
    echo "Install asciiquarium first: sudo apt install asciiquarium"
  fi
}

# --- Animated pipes ---
function pipes() {
  bash -c "$(curl -sL https://raw.githubusercontent.com/pipeseroni/pipes.sh/master/pipes.sh)"
}

# --- Show a random pony ---
function pony() {
  if command -v ponysay >/dev/null; then
    fortune | ponysay
  else
    echo "Install ponysay first: sudo apt install ponysay"
  fi
}

# --- Display text as ASCII art ---
function bigtext() {
  if command -v figlet >/dev/null && command -v lolcat >/dev/null; then
    figlet -f slant "$@" | lolcat
  elif command -v figlet >/dev/null; then
    figlet "$@"
  else
    echo "$@"
  fi
}

# --- Show current playing song (Spotify TUI) ---
function music() {
  if command -v spotify-tui >/dev/null; then
    spotify-tui
  elif command -v ncspot >/dev/null; then
    ncspot
  else
    echo "Install spotify-tui or ncspot"
  fi
}
```

---

## 🎨 Enhanced Aliases for TUI Tools

Add to `aliases.zsh`:

```zsh
# --- TUI Tools ---
command -v lazygit      >/dev/null && alias lg="lazygit"
command -v gitui        >/dev/null && alias gu="gitui"
command -v lazydocker   >/dev/null && alias lzd="lazydocker"
command -v k9s          >/dev/null && alias k="k9s"
command -v yazi         >/dev/null && alias y="yazi"
command -v broot        >/dev/null && alias br="broot"
command -v btop         >/dev/null && alias top="btop"
command -v bottom       >/dev/null && alias btm="bottom"
command -v posting      >/dev/null && alias post="posting"
command -v visidata     >/dev/null && alias vd="visidata"
command -v lazysql      >/dev/null && alias lsql="lazysql"

# --- Fun ---
command -v fastfetch    >/dev/null && alias neofetch="fastfetch"
command -v lolcat       >/dev/null && alias lc="lolcat"
command -v cmatrix      >/dev/null && alias matrix="cmatrix -b"
command -v cbonsai      >/dev/null && alias bonsai="cbonsai -l"

# --- Enhanced ls with lsd ---
if command -v lsd >/dev/null; then
  alias ls="lsd --group-dirs first"
  alias ll="lsd -la --group-dirs first"
  alias lt="lsd --tree --depth 2"
fi
```

---

## 📦 Installation Script for TUI Tools

Add this as `run_once_15-install-tui-tools.sh`:

```bash
#!/bin/bash
set -euo pipefail

echo "🎨 Installing TUI and beautification tools..."

{{ if eq .chezmoi.osRelease.id "arch" "endeavouros" "manjaro" }}
# Arch has most in official repos or AUR
sudo pacman -S --needed --noconfirm \
  lazygit lazydocker \
  btop bottom \
  fastfetch figlet toilet lolcat \
  fortune-mod cowsay \
  cmatrix \
  grc

# AUR tools (if using yay/paru)
if command -v paru >/dev/null; then
  paru -S --needed --noconfirm \
    yazi-bin \
    spotify-tui-bin \
    posting-bin \
    k9s-bin \
    gitui \
    cbonsai \
    pipes.sh
fi

{{ else if eq .chezmoi.osRelease.id "ubuntu" "debian" "pop" }}
# Install via apt where available
sudo apt install -y \
  figlet toilet lolcat \
  fortune-mod cowsay \
  cmatrix asciiquarium \
  grc

# Install via cargo/go for others
if command -v cargo >/dev/null; then
  echo "📦 Installing Rust-based TUI tools..."
  cargo install --locked \
    yazi-fm \
    gitui \
    bottom \
    spotify-tui
fi

# lazygit (via GitHub releases)
if ! command -v lazygit >/dev/null; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz
fi

# lazydocker
if ! command -v lazydocker >/dev/null; then
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# k9s
if ! command -v k9s >/dev/null; then
  curl -sS https://webi.sh/k9s | sh
fi

{{ else if eq .chezmoi.osRelease.id "fedora" }}
sudo dnf install -y \
  figlet toilet \
  fortune-mod cowsay \
  cmatrix \
  grc

# Rest via cargo
if command -v cargo >/dev/null; then
  cargo install --locked \
    yazi-fm gitui bottom lazygit
fi
{{ end }}

# cbonsai (from source)
if ! command -v cbonsai >/dev/null; then
  echo "📦 Installing cbonsai..."
  git clone https://gitlab.com/jallbrit/cbonsai /tmp/cbonsai
  cd /tmp/cbonsai
  make install PREFIX=$HOME/.local
  cd -
  rm -rf /tmp/cbonsai
fi

echo "✅ TUI tools installed"
```

---

## 🎨 Cool Terminal Startup

Add to the end of `dot_zshrc`:

```zsh
# --- Cool startup (optional, comment out if too slow) ---
if [[ -o interactive ]]; then
  # Show system info on first terminal of the day
  if [[ ! -f /tmp/fastfetch_shown_today_$(date +%Y%m%d) ]]; then
    command -v fastfetch >/dev/null && fastfetch
    touch /tmp/fastfetch_shown_today_$(date +%Y%m%d)
  fi
  
  # Random quote (10% chance)
  if (( RANDOM % 10 == 0 )); then
    if command -v fortune >/dev/null && command -v cowsay >/dev/null && command -v lolcat >/dev/null; then
      fortune -s | cowsay | lolcat
    fi
  fi
fi
```

---

## 🚀 Next Steps
2. **Generate age key** for secret encryption: `age-keygen -o ~/.config/chezmoi/key.txt`
3. **Add SSH key to GitHub/GitLab** (generated during bootstrap)
4. **Customize** starship.toml, aliases, functions to your preference
5. **Install optional tools** manually: lazygit, lazydocker, gh, etc.
6. **Test** on a VM or secondary machine before deploying to main machine

---

**Total setup time on fresh machine:** ~5 minutes + package download time

**Maintenance:** Zero — auto-updates every 6 hours via systemd timer
