# ---Homebrew---
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

# Start keychain and load the SSH key
eval `keychain --agents ssh --eval $HOME/.ssh/id_ed25519 2>/dev/null`
