#!/usr/bin/env bash
# Install secret-free operator dotfiles into $HOME (idempotent, backs up)
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPERATOR_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DOTFILES="${OPERATOR_ROOT}/dotfiles"
BACKUP="${HOME}/.smoothoperator-dotfiles-backup-$(date +%Y%m%d%H%M%S)"

log() { printf '[dotfiles] %s\n' "$*"; }

install_file() {
  local src="$1"
  local dest="$2"
  local mode="${3:-}"

  if [[ ! -f "$src" ]]; then
    log "SKIP missing source: $src"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" ]]; then
      local target
      target="$(readlink "$dest" || true)"
      if [[ "$target" == "$src" ]]; then
        log "OK  already linked: $dest"
        return 0
      fi
    fi
    mkdir -p "$BACKUP"
    mv "$dest" "$BACKUP/"
    log "backed up → $BACKUP/$(basename "$dest")"
  fi

  ln -s "$src" "$dest"
  if [[ -n "$mode" ]]; then
    chmod "$mode" "$dest" 2>/dev/null || true
  fi
  log "linked $dest → $src"
}

log "OPERATOR_ROOT=$OPERATOR_ROOT"

install_file "${DOTFILES}/zshrc" "${HOME}/.zshrc"
install_file "${DOTFILES}/tmux.conf" "${HOME}/.tmux.conf"

# gitconfig: only install when absent (do not clobber rich existing configs)
if [[ ! -f "${HOME}/.gitconfig" ]]; then
  install_file "${DOTFILES}/gitconfig" "${HOME}/.gitconfig"
else
  log "KEEP existing ~/.gitconfig (merge manually if needed)"
  if command -v git >/dev/null 2>&1; then
    git config --global user.name >/dev/null 2>&1 || git config --global user.name "Asır"
    git config --global user.email >/dev/null 2>&1 || git config --global user.email "asir01oz@gmail.com"
  fi
fi

# SSH config example → only if missing
mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"
if [[ ! -f "${HOME}/.ssh/config" ]]; then
  cp "${DOTFILES}/ssh-config.example" "${HOME}/.ssh/config"
  chmod 600 "${HOME}/.ssh/config"
  log "installed ~/.ssh/config from example — fill HostName for lab/arch"
else
  log "KEEP existing ~/.ssh/config"
fi

# Ensure zprofile loads brew on Apple Silicon without duplicating forever
if [[ -x /opt/homebrew/bin/brew ]]; then
  if [[ ! -f "${HOME}/.zprofile" ]] || ! grep -q 'brew shellenv' "${HOME}/.zprofile" 2>/dev/null; then
    {
      echo ''
      echo '# Homebrew (SmoothOperator)'
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    } >> "${HOME}/.zprofile"
    log "appended brew shellenv to ~/.zprofile"
  fi
fi

log "Done. Run: exec zsh -l"
[[ -d "$BACKUP" ]] && log "Backups in $BACKUP"
