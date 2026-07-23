#!/usr/bin/env bash
# Operator SSH connectivity check (github / lab / arch)
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

HOSTS=(github lab arch)
FAIL=0

check_host() {
  local host="$1"
  local out rc=0
  echo "=== $host ==="
  case "$host" in
    github)
      set +e
      out="$(ssh -o BatchMode=yes -o ConnectTimeout="${SO_SSH_TIMEOUT:-8}" -T git@github.com 2>&1)"
      rc=$?
      set -e
      echo "$out"
      if echo "$out" | grep -Eqi 'successfully authenticated|Hi '; then
        so_info "github: PASS"
        return 0
      fi
      so_warn "github: FAIL (rc=${rc})"
      return 1
      ;;
    *)
      set +e
      out="$(so_ssh "$host" 'printf "%s %s\n" "$(hostname)" "$(whoami)"' 2>&1)"
      rc=$?
      set -e
      echo "$out"
      if [[ $rc -eq 0 ]]; then
        so_info "$host: PASS"
        return 0
      fi
      so_warn "$host: FAIL (fill HostName / power-on / authorize key)"
      return 1
      ;;
  esac
}

for h in "${HOSTS[@]}"; do
  if ! check_host "$h"; then
    FAIL=$((FAIL + 1))
  fi
done

if [[ $FAIL -eq 0 ]]; then
  so_info "ssh-check: all targets OK"
  exit 0
fi
so_warn "ssh-check: $FAIL target(s) failed"
exit 1
