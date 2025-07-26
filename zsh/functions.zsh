# --- Custom functions ---
mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}
reload() {
  source ~/.zshrc
  echo "Shell config reloaded"
}
please() {
  sudo $(fc -ln -1)
}
histg() {
  history | grep --color=auto "$1"
}

# --- Edit config commands ---
editrc() { nano ~/.zshrc }
editaliases() { nano ~/dotfiles/zsh/aliases.zsh }
editenv() { nano ~/dotfiles/zsh/env.zsh }
editfunc() { nano ~/dotfiles/zsh/functions.zsh }
editplugins() { nano ~/dotfiles/zsh/plugins.zsh }
editprompt() { nano ~/dotfiles/zsh/prompt.zsh }

# --- Repo Update ---
gacp() {
  if [ -z "$1" ]; then
    echo "Usage: gacp \"commit message\""
    return 1
  fi
  git add .
  git commit -m "$1"
  git push origin "$(git rev-parse --abbrev-ref HEAD)"
}

