#!/usr/bin/env bash
# Lightweight remote host status via SSH (does not mutate the server)
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

HOST="${1:-lab}"

so_info "server-status: $HOST"
so_ssh "$HOST" 'bash -s' <<'REMOTE'
set -euo pipefail
echo "hostname: $(hostname)"
echo "user:     $(whoami)"
echo "uptime:   $(uptime)"
echo "date:     $(date -Is 2>/dev/null || date)"
if command -v docker >/dev/null 2>&1; then
  echo "docker:   $(docker --version 2>/dev/null || true)"
  docker ps --format 'table {{.Names}}\t{{.Status}}' 2>/dev/null | head -n 30 || true
else
  echo "docker:   not installed / not in PATH"
fi
REMOTE
