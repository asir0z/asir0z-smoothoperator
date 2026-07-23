#!/usr/bin/env bash
# Shared logging helpers — source from scripts/lib/common.sh
# shellcheck shell=bash

if [[ -n "${_SO_LOGGING_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
_SO_LOGGING_LOADED=1

so_log() {
  local level="$1"
  shift
  printf '[%s] %s\n' "$level" "$*" >&2
}

so_info()  { so_log INFO  "$*"; }
so_warn()  { so_log WARN  "$*"; }
so_error() { so_log ERROR "$*"; }
so_die()   { so_error "$*"; exit 1; }
