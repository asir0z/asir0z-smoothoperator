#!/usr/bin/env bash
# WS-1 system layer — one-shot for root (TTY or ssh).
# Flow: copy off vboxsf → CRLF strip on local fs → dev-stack → install-ssh-authorized-key
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo bash $0" >&2
  exit 1
fi

MNT=/mnt/bootstrap
WORKDIR=/tmp/ws1-bootstrap

mkdir -p "$MNT"
if ! mountpoint -q "$MNT"; then
  mount -t vboxsf bootstrap "$MNT"
fi

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR/verify"
cp "$MNT/dev-stack.sh" "$MNT/install-ssh-authorized-key.sh" "$WORKDIR/"
cp "$MNT/verify/verify-ws1.sh" "$WORKDIR/verify/"
chmod +x "$WORKDIR"/*.sh "$WORKDIR"/verify/*.sh

# vboxsf does not support sed -i rename; strip CRLF on local filesystem
for f in "$WORKDIR/dev-stack.sh" "$WORKDIR/install-ssh-authorized-key.sh" "$WORKDIR/verify/verify-ws1.sh"; do
  sed -i 's/\r$//' "$f"
done

bash "$WORKDIR/dev-stack.sh"
bash "$WORKDIR/install-ssh-authorized-key.sh" "$MNT/windows_id_ed25519.pub"

echo
echo "System layer complete."
echo "Next (as asir0z, not root):"
echo "  bash $MNT/verify/verify-ws1.sh | tee ~/ws-1-evidence.txt"
