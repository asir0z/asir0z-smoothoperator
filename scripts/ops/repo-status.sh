#!/usr/bin/env bash
# Multi-repository status under a projects root.
# Read-only: never commit, reset, rebase, or force-push.
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

ROOT="${1:-${PROJECTS_DIR:-$HOME/Projects}}"

if [[ ! -d "$ROOT" ]]; then
  so_die "Projects root not found: $ROOT"
fi

so_require_cmd git
so_info "repo-status root: $ROOT"
printf '%-36s %-16s %-10s %-12s %s\n' "REPO" "BRANCH" "DIRTY" "AHEAD/BEHIND" "REMOTE"
printf '%-36s %-16s %-10s %-12s %s\n' "----" "------" "-----" "-----------" "------"

shopt -s nullglob
for dir in "$ROOT"/*/; do
  [[ -d "${dir}/.git" ]] || continue
  name="$(basename "$dir")"
  branch="$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
  dirty="clean"
  if [[ -n "$(git -C "$dir" status --porcelain 2>/dev/null || true)" ]]; then
    dirty="dirty"
  fi

  ahead_behind="n/a"
  remote_state="ok"
  if git -C "$dir" rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>&1; then
    # fetch is optional; use local tracking info only (no network mutation required)
    counts="$(git -C "$dir" rev-list --left-right --count '@{upstream}'...HEAD 2>/dev/null || true)"
    if [[ -n "$counts" ]]; then
      behind="${counts%%	*}"
      ahead="${counts##*	}"
      ahead_behind="A${ahead}/B${behind}"
    fi
  else
    ahead_behind="no-upstream"
  fi

  remote_url="$(git -C "$dir" remote get-url origin 2>/dev/null || echo 'no-origin')"
  # Never print embedded credentials (https://user:token@host/…)
  remote_url="$(printf '%s' "$remote_url" | sed -E 's#(https?://)[^/@]+@#\1#g')"
  if ! git -C "$dir" ls-remote --exit-code --heads origin >/dev/null 2>&1; then
    remote_state="unreachable"
  fi

  printf '%-36s %-16s %-10s %-12s %s (%s)\n' \
    "$name" "$branch" "$dirty" "$ahead_behind" "$remote_state" "$remote_url"
done
