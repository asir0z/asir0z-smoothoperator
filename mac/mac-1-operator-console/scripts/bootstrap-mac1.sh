#!/usr/bin/env bash
# Compatibility wrapper → canonical scripts/bootstrap/mac-bootstrap.sh
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
TARGET="${REPO_ROOT}/scripts/bootstrap/mac-bootstrap.sh"

if [[ ! -f "$TARGET" ]]; then
  echo "ERROR: canonical bootstrap missing: $TARGET" >&2
  exit 1
fi

echo "[mac-1] delegating to scripts/bootstrap/mac-bootstrap.sh"
exec bash "$TARGET" "$@"
