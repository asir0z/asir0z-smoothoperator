#!/usr/bin/env bash
# Compatibility wrapper → canonical scripts/bootstrap/mac-verify.sh
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
TARGET="${REPO_ROOT}/scripts/bootstrap/mac-verify.sh"

if [[ ! -f "$TARGET" ]]; then
  echo "ERROR: canonical verify missing: $TARGET" >&2
  exit 1
fi

echo "[mac-1] delegating to scripts/bootstrap/mac-verify.sh"
exec bash "$TARGET" "$@"
