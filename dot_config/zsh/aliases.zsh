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
command -v btop      >/dev/null && alias top="btop"
command -v dog       >/dev/null && alias dig="dog"
command -v doggo    >/dev/null && alias dig="doggo"
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
alias reload="exec zsh"

# --- System ---
if [[ "$OSTYPE" == darwin* ]]; then
  alias update="brew update && brew upgrade"
  alias cleanup="brew cleanup"
elif command -v apt >/dev/null; then
  alias update="sudo apt update && sudo apt upgrade"
  alias cleanup="sudo apt autoremove && sudo apt autoclean"
elif command -v pacman >/dev/null; then
  alias update="sudo pacman -Syu"
  alias cleanup="sudo pacman -Rns \$(pacman -Qdtq) 2>/dev/null || true"
elif command -v dnf >/dev/null; then
  alias update="sudo dnf upgrade"
  alias cleanup="sudo dnf autoremove"
fi

# --- Networking ---
alias myip="curl ifconfig.me"
alias ports="netstat -tulanp"
alias listening="lsof -i -P | grep LISTEN"

# --- Misc ---
alias weather="curl wttr.in"
alias cheat="curl cheat.sh"

# --- Zellij ---
alias work="zellij --config ~/.config/zellij/config_work.kdl"
