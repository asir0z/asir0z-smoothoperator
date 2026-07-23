#!/usr/bin/env bash
# MAC-1 — full Mac operator console bootstrap (macOS only)
# Mutates the local Mac operator environment only — never production hosts.
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

REPO_ROOT="$(so_repo_root)"
export REPO_ROOT

so_require_macos || exit 1
so_brew_shellenv

so_info "=== MAC-1 mac-bootstrap ==="
so_info "REPO_ROOT=$REPO_ROOT"

if [[ "${SHELL:-}" != *zsh* ]]; then
  so_warn "Login SHELL is not zsh (${SHELL:-unset}). MAC-1 expects macOS default zsh; not changing it."
fi

# Packages
bash "${SCRIPT_DIR}/mac-packages.sh"

# Git identity (safe)
if [[ -x "${REPO_ROOT}/mac/mac-1-operator-console/scripts/configure-git.sh" ]]; then
  bash "${REPO_ROOT}/mac/mac-1-operator-console/scripts/configure-git.sh"
fi

# SSH scaffold (safe; no overwrite of existing config)
if [[ -x "${REPO_ROOT}/mac/mac-1-operator-console/scripts/configure-ssh.sh" ]]; then
  bash "${REPO_ROOT}/mac/mac-1-operator-console/scripts/configure-ssh.sh"
fi

# Dotfiles (secret-free)
if [[ -x "${REPO_ROOT}/shared/operator/scripts/install-dotfiles.sh" ]]; then
  bash "${REPO_ROOT}/shared/operator/scripts/install-dotfiles.sh"
fi

# Repositories
if [[ -x "${REPO_ROOT}/mac/mac-1-operator-console/scripts/clone-repos.sh" ]]; then
  bash "${REPO_ROOT}/mac/mac-1-operator-console/scripts/clone-repos.sh"
fi

so_info "=== MAC-1 mac-bootstrap finished ==="
cat <<'EOF'
Next (operator):
  1. Phase 1 GUI: FileVault, Firewall, automatic security updates
  2. gh auth login -p ssh -h github.com
  3. Edit ~/.ssh/config HostName for lab / arch
  4. Install Cursor.app
  5. exec zsh -l
  6. bash scripts/bootstrap/mac-verify.sh | tee shared/evidence/mac-1/verification-$(date +%Y%m%d).txt
  7. After lab SSH is safe: lab-health
EOF
