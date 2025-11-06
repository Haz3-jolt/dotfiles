# --- Zoxide (smarter cd) ---
if command -v zoxide >/dev/null; then

  eval "$(zoxide init zsh --cmd cd --hook prompt)"

fi

# --- FZF (fuzzy finder) ---

if [ -f ~/.fzf.zsh ]; then

  source ~/.fzf.zsh

fi

# --- Antigen Plugin Manager ---
if [ ! -f "$HOME/.antigen.zsh" ]; then
  curl -L git.io/antigen > "$HOME/.antigen.zsh"
fi

source "$HOME/.antigen.zsh"
antigen use oh-my-zsh

# --- Essential plugins ---
antigen bundle git
antigen bundle common-aliases
antigen bundle command-not-found
antigen bundle extract
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle rupa/z
antigen bundle djui/alias-tips
antigen bundle Aloxaf/fzf-tab

antigen apply
