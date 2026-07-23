#!/usr/bin/env bash
# MAC-1 — SSH directory, key, and portable config template
# Never prints private key material.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
# Prefer shared operator example; fall back to package template
TEMPLATE="${REPO_ROOT}/shared/operator/dotfiles/ssh-config.example"
if [[ ! -f "$TEMPLATE" ]]; then
  TEMPLATE="$SCRIPT_DIR/../config/ssh/config.template"
fi
SSH_DIR="${HOME}/.ssh"
KEY="${SSH_DIR}/id_ed25519"
CONFIG="${SSH_DIR}/config"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [[ ! -f "$KEY" ]]; then
  email="$(git config --global --get user.email 2>/dev/null || echo asir01oz@gmail.com)"
  ssh-keygen -t ed25519 -f "$KEY" -C "$email" -N ""
  echo "Generated $KEY"
else
  echo "Keep existing $KEY"
fi

chmod 600 "$KEY" 2>/dev/null || true
chmod 644 "${KEY}.pub" 2>/dev/null || true

if [[ ! -f "$CONFIG" ]]; then
  if [[ ! -f "$TEMPLATE" ]]; then
    echo "ERROR: missing template $TEMPLATE" >&2
    exit 1
  fi
  cp "$TEMPLATE" "$CONFIG"
  chmod 600 "$CONFIG"
  echo "Installed SSH config from template → $CONFIG"
  echo "Edit HostName for hosts: lab, arch"
else
  echo "Keep existing $CONFIG (template not overwritten)"
  echo "Ensure aliases exist: github, lab, arch — see $TEMPLATE"
fi

echo
echo "Public key (add to GitHub if needed):"
echo "-----"
cat "${KEY}.pub"
echo "-----"
echo "Test: ssh -T git@github.com"
