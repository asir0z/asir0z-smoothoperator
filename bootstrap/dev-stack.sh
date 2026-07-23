#!/usr/bin/env bash
# Developer CLI stack for Arch-Engineering-Workstation.
# Spec: asir0z-devopslab/docs/cross-project/DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md
#
# DevOps Lab standard:
#   System mutations run as root. User state runs as the operator.
#
# This script: SYSTEM LAYER ONLY (pacman, usermod). Idempotent via pacman -S --needed.
# Must NOT run: gh auth, git config, SSH keys, pip/npm global, or writes under /home.
# SSH pubkey: bootstrap/install-ssh-authorized-key.sh (called by run-ws1-system.sh).
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "System layer: sudo bash $0" >&2
  exit 1
fi

TARGET_USER="${TARGET_USER:-asir0z}"

echo "[1/4] sync"
pacman -Syu --noconfirm

echo "[2/4] core packages (system)"
pacman -S --needed --noconfirm \
  base-devel linux-headers git curl wget jq \
  openssh inetutils \
  ripgrep fd bat eza fzf \
  neovim tree htop \
  github-cli \
  python python-pip \
  nodejs npm

echo "[3/4] groups"
usermod -aG wheel "$TARGET_USER"

echo "[4/4] verify"
for cmd in git curl jq rg fd bat eza fzf nvim gh python node npm; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "ok: $cmd -> $(command -v "$cmd")"
  else
    echo "FAIL: $cmd missing" >&2
    exit 1
  fi
done

echo "dev-stack done — idempotent system packages only"
echo "user layer next — as $TARGET_USER, not root (directive section 6)"
