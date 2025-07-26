# --- Starship Prompt ---
if ! command -v starship >/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi
eval "$(starship init zsh)"
