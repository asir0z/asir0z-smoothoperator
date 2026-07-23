#!/usr/bin/env bash
# Developer CLI stack for Arch-Engineering-Workstation.
# Spec: asir0z-devopslab/docs/cross-project/DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md
#
# DevOps Lab standard:
#   System mutations run as root. User state runs as the operator.
#
# This script: SYSTEM LAYER ONLY (pacman, usermod).
# Must NOT run: gh auth, git config, pip/npm global, or any write under /home.
# User layer: directive section 6 — run as asir0z after this script exits.
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

echo "[3/4] groups + ssh key"
usermod -aG wheel "$TARGET_USER"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PUB="$SCRIPT_DIR/windows_id_ed25519.pub"
if [[ -f "$PUB" ]]; then
  AUTH_KEYS="$TARGET_HOME/.ssh/authorized_keys"
  install -d -m 700 -o "$TARGET_USER" -g "$TARGET_USER" "$TARGET_HOME/.ssh"
  touch "$AUTH_KEYS"
  chown "$TARGET_USER:$TARGET_USER" "$AUTH_KEYS"
  chmod 600 "$AUTH_KEYS"
  if ! grep -qF "$(cat "$PUB")" "$AUTH_KEYS" 2>/dev/null; then
    cat "$PUB" >>"$AUTH_KEYS"
    echo "installed SSH pubkey for $TARGET_USER"
  fi
fi

echo "[4/4] verify"
for cmd in git curl jq rg fd bat eza fzf nvim gh python node npm; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "ok: $cmd -> $(command -v "$cmd")"
  else
    echo "FAIL: $cmd missing" >&2
    exit 1
  fi
done

echo "system layer done — capture evidence (directive section 7)"
echo "user layer next — as $TARGET_USER, not root (directive section 6)"
