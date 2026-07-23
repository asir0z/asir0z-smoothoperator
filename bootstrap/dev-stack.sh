#!/usr/bin/env bash
# Developer CLI stack for Arch-Engineering-Workstation.
# Spec: asir0z-devopslab/docs/cross-project/DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md
# Root scope: pacman + usermod only. No writes under /home — user config is section 6 (as asir0z).
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo bash $0" >&2
  exit 1
fi

TARGET_USER="${TARGET_USER:-asir0z}"

echo "[1/4] sync"
pacman -Syu --noconfirm

echo "[2/4] core packages"
pacman -S --needed --noconfirm \
  base-devel linux-headers git curl wget jq \
  openssh inetutils \
  ripgrep fd bat eza fzf \
  neovim tree htop \
  github-cli \
  python python-pip \
  nodejs npm

echo "[3/4] user groups (docker optional later)"
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

echo "done — capture evidence per DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md section 7"
echo "next: run section 6 as $TARGET_USER (gh auth, git config, pip --user)"
