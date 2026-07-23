#!/usr/bin/env bash
# MAC-1 — Homebrew + developer tools bootstrap (macOS only)
# Spec: mac/mac-1-operator-console/MAC-1-SPEC.md
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAC1_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "ERROR: bootstrap-mac1.sh must run on macOS (Darwin). Detected: $(uname -s)" >&2
  exit 1
fi

echo "=== MAC-1 bootstrap ==="
echo "Repo package: $MAC1_ROOT"

# --- Homebrew PATH (Apple Silicon / Intel) ---
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install first:" >&2
  echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' >&2
  exit 1
fi

echo "--- brew update ---"
brew update

echo "--- brew install tools ---"
# curl is usually present via macOS; brew formula still ensures brew-managed path when useful
brew install git gh wget curl jq tree htop ripgrep fd tmux neovim

echo "--- brew upgrade ---"
brew upgrade || true

echo "--- brew doctor ---"
set +e
brew doctor
doctor_rc=$?
set -e
if [[ $doctor_rc -ne 0 ]]; then
  echo "WARN: brew doctor exited $doctor_rc — review warnings before certification." >&2
fi

echo "--- configure git ---"
bash "$SCRIPT_DIR/configure-git.sh"

echo "--- configure ssh ---"
bash "$SCRIPT_DIR/configure-ssh.sh"

echo "--- clone repositories ---"
bash "$SCRIPT_DIR/clone-repos.sh"

echo
echo "=== MAC-1 bootstrap finished ==="
echo "Next:"
echo "  1. Complete Phase 1 GUI hardening (FileVault, Firewall) if not done"
echo "  2. gh auth login -p ssh -h github.com"
echo "  3. Install Cursor.app (Phase 6)"
echo "  4. Edit ~/.ssh/config HostName for lab / arch"
echo "  5. bash mac/mac-1-operator-console/verify/verify-mac1.sh"
