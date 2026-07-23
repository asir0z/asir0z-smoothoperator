#!/usr/bin/env bash
# MAC-1 — install Homebrew operator toolchain (macOS only)
# Does not force-link GNU tools over macOS system binaries.
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

so_require_macos || exit 1
so_brew_shellenv

if ! so_have_cmd brew; then
  so_die "Homebrew not found. Install: https://brew.sh then re-run."
fi

REQUIRED_FORMULAE=(
  git
  gh
  openssh
  curl
  wget
  jq
  yq
  tree
  ripgrep
  fd
  fzf
  tmux
  htop
  rsync
  coreutils
  gnu-sed
  findutils
  gawk
  make
  shellcheck
  shfmt
)

OPTIONAL_FORMULAE=(
  bat
  eza
  btop
  watch
  ncdu
  neovim
)

so_info "brew update"
brew update

so_info "Installing required formulae"
brew install "${REQUIRED_FORMULAE[@]}"

so_info "Installing optional formulae (best-effort)"
for f in "${OPTIONAL_FORMULAE[@]}"; do
  if brew list --formula "$f" >/dev/null 2>&1; then
    so_info "optional already installed: $f"
  else
    brew install "$f" || so_warn "optional install failed: $f"
  fi
done

# fzf keybindings — non-fatal
if so_have_cmd fzf && [[ -x "$(brew --prefix)/opt/fzf/install" ]]; then
  so_info "fzf install helper present (run manually if keybindings desired): $(brew --prefix)/opt/fzf/install"
fi

so_info "GNU tools are typically prefixed (gsed, gawk, gdate, …). PATH is not force-overridden."
so_info "mac-packages complete"
