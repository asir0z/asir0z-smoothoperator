#!/usr/bin/env bash
# MAC-1 — Git global identity (safe: only sets when unset)
set -euo pipefail

GIT_NAME="${GIT_NAME:-Asır}"
GIT_EMAIL="${GIT_EMAIL:-asir01oz@gmail.com}"

set_if_empty() {
  local key="$1"
  local value="$2"
  local current
  current="$(git config --global --get "$key" 2>/dev/null || true)"
  if [[ -z "$current" ]]; then
    git config --global "$key" "$value"
    echo "set  $key=$value"
  else
    echo "keep $key=$current"
  fi
}

set_if_empty user.name "$GIT_NAME"
set_if_empty user.email "$GIT_EMAIL"
set_if_empty init.defaultBranch master
set_if_empty core.autocrlf input
set_if_empty core.eol lf
set_if_empty pull.rebase false

echo "Git identity:"
git config --global --get user.name
git config --global --get user.email
git config --global --get init.defaultBranch || true
