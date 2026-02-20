#!/bin/bash
set -euo pipefail

echo "🔑 Enabling systemd ssh-agent..."
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service

echo "✅ SSH agent enabled"