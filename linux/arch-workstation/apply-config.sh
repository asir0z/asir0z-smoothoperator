#!/usr/bin/env bash
# Apply Arch workstation config from repo. VM-safe now; bare-metal profile auto-selected later.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CFG="$REPO_ROOT/linux/arch-workstation/config"
TARGET_USER="${TARGET_USER:-$(id -un)}"
TARGET_HOME="${TARGET_HOME:-$HOME}"

detect_profile() {
  if systemd-detect-virt -q 2>/dev/null; then
    echo vm
  elif grep -qiE 'virtualbox|vmware|qemu|kvm' /sys/class/dmi/id/product_name 2>/dev/null; then
    echo vm
  else
    echo baremetal
  fi
}

PROFILE="${WORKSTATION_PROFILE:-$(detect_profile)}"
echo "workstation profile: $PROFILE"

install -d -m 755 "$TARGET_HOME/.config/hypr"
install -d -m 755 "$TARGET_HOME/.config/waybar"
install -d -m 755 "$TARGET_HOME/Projects"
install -d -m 700 "$TARGET_HOME/.ssh"

cp "$CFG/hypr/hyprland.base.conf" "$TARGET_HOME/.config/hypr/hyprland.base.conf"
cp "$CFG/hypr/hyprland.${PROFILE}.conf" "$TARGET_HOME/.config/hypr/hyprland.profile.conf"

cat >"$TARGET_HOME/.config/hypr/hyprland.conf" <<EOF
# Managed by asir0z-smoothoperator/linux/arch-workstation/apply-config.sh
# Profile: $PROFILE — re-run apply-config after bare-metal install

source = ~/.config/hypr/hyprland.base.conf
source = ~/.config/hypr/hyprland.profile.conf
EOF

if [[ -f "$CFG/waybar/config" ]]; then
  cp "$CFG/waybar/config" "$TARGET_HOME/.config/waybar/config"
  cp "$CFG/waybar/style.css" "$TARGET_HOME/.config/waybar/style.css"
fi

if [[ -f "$CFG/ssh/config.template" ]] && [[ ! -f "$TARGET_HOME/.ssh/config" ]]; then
  cp "$CFG/ssh/config.template" "$TARGET_HOME/.ssh/config"
  chmod 600 "$TARGET_HOME/.ssh/config"
  echo "installed ~/.ssh/config from template"
elif [[ -f "$CFG/ssh/config.template" ]]; then
  echo "skip ~/.ssh/config — already exists (merge manually from config.template)"
fi

# Canonical repo path mirrors Windows C:\Projects\asir0z-smoothoperator
CANON="$TARGET_HOME/Projects/asir0z-smoothoperator"
if [[ "$REPO_ROOT" != "$CANON" ]]; then
  if [[ ! -e "$CANON" ]]; then
    echo "hint: move or clone repo to $CANON for Windows path parity"
  fi
fi

# Git identity — only if unset (matches Windows WIN-1 baseline)
if [[ -z "$(git config --global user.name 2>/dev/null || true)" ]]; then
  git config --global user.name "Asır"
  git config --global user.email "asir01oz@gmail.com"
  git config --global core.autocrlf false
  git config --global core.eol lf
  echo "git global identity configured"
fi

echo "done — profile=$PROFILE"
echo "Hyprland reload: hyprctl reload  (or re-login if session active)"
