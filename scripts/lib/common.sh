#!/usr/bin/env bash
# Common helpers for SmoothOperator scripts
# Usage: source from a script after resolving paths
# shellcheck shell=bash

if [[ -n "${_SO_COMMON_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
_SO_COMMON_LOADED=1

_SO_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=logging.sh
source "${_SO_LIB_DIR}/logging.sh"
# shellcheck source=platform.sh
source "${_SO_LIB_DIR}/platform.sh"

so_repo_root() {
  if [[ -n "${REPO_ROOT:-}" && -d "${REPO_ROOT}/scripts/lib" ]]; then
    printf '%s\n' "$REPO_ROOT"
    return 0
  fi
  local here
  here="$(cd "${_SO_LIB_DIR}/../.." && pwd)"
  if [[ -d "${here}/scripts/lib" ]]; then
    printf '%s\n' "$here"
    return 0
  fi
  so_die "Unable to resolve SmoothOperator repo root from ${_SO_LIB_DIR}"
}

so_require_cmd() {
  local cmd
  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      so_die "Required command not found: $cmd"
    fi
  done
}

so_have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

so_ssh() {
  local host="$1"
  shift
  ssh \
    -o BatchMode=yes \
    -o ConnectTimeout="${SO_SSH_TIMEOUT:-8}" \
    -o IdentitiesOnly=yes \
    "$host" \
    "$@"
}

so_ssh_interactive() {
  local host="$1"
  shift
  ssh -o IdentitiesOnly=yes "$host" "$@"
}
