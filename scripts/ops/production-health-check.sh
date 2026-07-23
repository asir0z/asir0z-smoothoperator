#!/usr/bin/env bash
# Mac wrapper — invokes canonical Ubuntu production health check over SSH.
# Production authority remains on the server (do not duplicate logic here).
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

HOST="${SO_LAB_HOST:-lab}"

so_info "Invoking remote health on ${HOST}"
so_info "Canonical script: \$HOME/scripts/ops/production-health-check.sh (Ubuntu)"
so_info "This file is a Mac wrapper only — no production logic here."

so_ssh "$HOST" 'bash -s' <<'REMOTE'
set -euo pipefail
SCRIPT="${HOME}/scripts/ops/production-health-check.sh"
if [[ -x "$SCRIPT" ]]; then
  exec "$SCRIPT"
elif [[ -f "$SCRIPT" ]]; then
  exec bash "$SCRIPT"
else
  echo "ERROR: missing $SCRIPT on $(hostname)" >&2
  echo "Install/sync asir0z-devopslab ops scripts on the server, then retry." >&2
  exit 2
fi
REMOTE
