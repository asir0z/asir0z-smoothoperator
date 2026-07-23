#!/usr/bin/env bash
# Machine-specific: install operator SSH pubkey into authorized_keys.
# Spec: asir0z-devopslab/docs/cross-project/DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md
# Idempotent — safe to re-run when rotating keys or changing laptops.
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo bash $0" >&2
  exit 1
fi

TARGET_USER="${TARGET_USER:-asir0z}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PUB="${1:-$SCRIPT_DIR/windows_id_ed25519.pub}"

if [[ ! -f "$PUB" ]]; then
  echo "skip: no pubkey at $PUB" >&2
  exit 0
fi

AUTH_KEYS="$TARGET_HOME/.ssh/authorized_keys"
install -d -m 700 -o "$TARGET_USER" -g "$TARGET_USER" "$TARGET_HOME/.ssh"
touch "$AUTH_KEYS"
chown "$TARGET_USER:$TARGET_USER" "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"

if grep -qF "$(cat "$PUB")" "$AUTH_KEYS" 2>/dev/null; then
  echo "ok: SSH pubkey already present for $TARGET_USER"
else
  cat "$PUB" >>"$AUTH_KEYS"
  echo "ok: installed SSH pubkey for $TARGET_USER from $PUB"
fi
