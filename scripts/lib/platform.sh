#!/usr/bin/env bash
# Platform detection helpers
# shellcheck shell=bash

if [[ -n "${_SO_PLATFORM_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
_SO_PLATFORM_LOADED=1

so_detect_platform() {
  case "$(uname -s)" in
    Darwin) PLATFORM="macos" ;;
    Linux)  PLATFORM="linux" ;;
    *)
      echo "Unsupported operating system: $(uname -s)" >&2
      return 1
      ;;
  esac
  export PLATFORM
}

so_require_macos() {
  so_detect_platform || return 1
  if [[ "$PLATFORM" != "macos" ]]; then
    echo "This script must run on macOS (Darwin). Detected: $PLATFORM" >&2
    return 1
  fi
}

# Homebrew prefix-aware PATH (does not force-link GNU over BSD)
so_brew_shellenv() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    # shellcheck disable=SC1090
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    # shellcheck disable=SC1090
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# Resolve a GNU-prefixed tool when available (gsed, gawk, gdate, …)
so_gnu() {
  local base="$1"
  if command -v "g${base}" >/dev/null 2>&1; then
    command -v "g${base}"
  elif command -v "$base" >/dev/null 2>&1; then
    command -v "$base"
  else
    return 1
  fi
}
