#!/bin/bash
set -euo pipefail

if ! command -v rustc >/dev/null; then
  echo "🦀 Installing Rust toolchain..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  source "$HOME/.cargo/env"
else
  echo "✅ Rust already installed"
fi