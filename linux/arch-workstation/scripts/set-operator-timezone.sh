#!/usr/bin/env bash
# Operator timezone — Europe/Istanbul (requires root once)
set -euo pipefail
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run: sudo bash $0" >&2
  exit 1
fi
timedatectl set-timezone Europe/Istanbul
timedatectl status
