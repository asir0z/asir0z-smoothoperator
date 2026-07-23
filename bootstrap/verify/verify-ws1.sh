#!/usr/bin/env bash
# WS-1 evidence capture — run as asir0z (user layer verification only).
# Spec: asir0z-devopslab/docs/cross-project/DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md section 7
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  echo "Run as asir0z, not root: su - asir0z -c 'bash $0'" >&2
  exit 1
fi

echo "=== WS-1 evidence ==="
date -Iseconds
hostname
uname -r
echo
echo "=== packages ==="
pacman -Q git jq ripgrep fd bat eza fzf neovim github-cli python nodejs npm 2>&1
echo
echo "=== versions ==="
git --version
jq --version
rg --version
gh --version
python --version
node --version
npm --version
echo
echo "=== session ==="
echo "SHELL=$SHELL"
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-unset}"
systemctl is-system-running
echo
echo "=== sddm ==="
systemctl is-enabled sddm 2>/dev/null || true
echo
echo "=== done ==="
