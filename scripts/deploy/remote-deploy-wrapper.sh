#!/usr/bin/env bash
# Generic Mac → Ubuntu deploy wrapper.
# Does not embed deploy logic; runs a remote canonical script.
#
# Usage:
#   bash scripts/deploy/remote-deploy-wrapper.sh web
#   bash scripts/deploy/remote-deploy-wrapper.sh pi
#   SO_DEPLOY_SCRIPT='~/scripts/deploy/foo.sh' bash scripts/deploy/remote-deploy-wrapper.sh custom
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

TARGET="${1:-}"
HOST="${SO_LAB_HOST:-lab}"

if [[ -z "$TARGET" ]]; then
  cat <<'EOF' >&2
Usage: remote-deploy-wrapper.sh <web|pi|custom|path-key>

Environment:
  SO_LAB_HOST          SSH host alias (default: lab)
  SO_DEPLOY_SCRIPT     Override remote script path
EOF
  exit 2
fi

case "$TARGET" in
  web) remote="${SO_DEPLOY_SCRIPT:-~/scripts/deploy/deploy-web.sh}" ;;
  pi)  remote="${SO_DEPLOY_SCRIPT:-~/scripts/deploy/deploy-pi.sh}" ;;
  custom)
    remote="${SO_DEPLOY_SCRIPT:-}"
    [[ -n "$remote" ]] || so_die "SO_DEPLOY_SCRIPT required for target=custom"
    ;;
  *)
    remote="${SO_DEPLOY_SCRIPT:-~/scripts/deploy/${TARGET}.sh}"
    ;;
esac

so_info "Remote deploy wrapper → ssh $HOST '$remote'"
so_info "Canonical deploy authority remains on Ubuntu / asir0z-devopslab."
so_warn "Refusing to invent local production deploy logic."

# Explicit confirmation for safety
if [[ "${SO_DEPLOY_CONFIRM:-}" != "yes" ]]; then
  so_die "Set SO_DEPLOY_CONFIRM=yes to invoke remote deploy: $remote"
fi

so_ssh "$HOST" "bash -lc '$remote'"
