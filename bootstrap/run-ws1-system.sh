#!/usr/bin/env bash
# WS-1 system layer — one-shot for root (TTY or ssh).
# Flow: CRLF strip → dev-stack.sh → install-ssh-authorized-key.sh
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo bash $0" >&2
  exit 1
fi

MNT=/mnt/bootstrap
mkdir -p "$MNT"
if ! mountpoint -q "$MNT"; then
  mount -t vboxsf bootstrap "$MNT"
fi

for f in dev-stack.sh run-ws1-system.sh install-ssh-authorized-key.sh verify/verify-ws1.sh; do
  if [[ -f "$MNT/$f" ]]; then
    sed -i 's/\r$//' "$MNT/$f"
  fi
done

bash "$MNT/dev-stack.sh"
bash "$MNT/install-ssh-authorized-key.sh"

echo
echo "System layer complete."
echo "Next (as asir0z, not root):"
echo "  bash $MNT/verify/verify-ws1.sh | tee ~/ws-1-evidence.txt"
