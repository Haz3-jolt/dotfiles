# --- Custom functions ---
mkcd() {
  mkdir -p -- "$1" && zoxide add "$1" && cd "$1"
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
editrc() { nano ~/.config/zsh/.zshrc }
editaliases() { nano ~/.config/zsh/aliases.zsh }
editenv() { nano ~/.config/zsh/env.zsh }
editfunc() { nano ~/.config/zsh/functions.zsh }
editplugins() { nano ~/.config/zsh/plugins.zsh }
editprompt() { nano ~/.config/zsh/prompt.zsh }
