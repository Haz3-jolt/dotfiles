#!/bin/bash
set -euo pipefail

echo "⏰ Enabling dotfiles auto-sync timer..."
systemctl --user daemon-reload
systemctl --user enable --now chezmoi-sync.timer

echo "✅ Auto-sync enabled (runs every 6 hours)"