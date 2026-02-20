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
    # Core modern replacements
    eza
    zoxide
    du-dust
    duf
    procs
    sd
    ripgrep
    fd-find
    bat

    # Dev tools
    tokei
    hyperfine
    watchexec-cli
    just

    # File / data
    yazi-fm
    jless
    xh
    git-delta

    # Shell tools
    atuin

    # TUI tools
    bottom
    gitui

    # System info
    fastfetch
    cbonsai

    # Viewing
    glow

    # Extras
    bat-extras
    tealdeer
  )

  for tool in "${CARGO_TOOLS[@]}"; do

    case "$tool" in
      du-dust) binary="dust" ;;
      watchexec-cli) binary="watchexec" ;;
      yazi-fm) binary="yazi" ;;
      git-delta) binary="delta" ;;
      fd-find) binary="fd" ;;
      bat-extras) binary="batgrep" ;;
      tealdeer) binary="tldr" ;;
      *) binary="$tool" ;;
    esac

    if ! command -v "$binary" >/dev/null 2>&1; then
      echo "  Installing $tool..."
      cargo install "$tool" --locked
    else
      echo "  ✔ $tool already installed"
    fi

  done
fi

# Install lazygit (not available via cargo)
if ! command -v lazygit >/dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
  tar xf lazygit.tar.gz lazygit
  install lazygit ~/.local/bin
  rm lazygit lazygit.tar.gz
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Log out and back in"
echo "  2. Run: exec zsh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"