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