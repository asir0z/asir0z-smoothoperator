#!/usr/bin/env bash
# MAC-1 evidence collector — run on the Mac after bootstrap
set -u
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

REPO_ROOT="$(so_repo_root)"
PASS=0
FAIL=0
WARN=0
SKIP=0

record() {
  local status="$1"
  local name="$2"
  local detail="${3:-}"
  case "$status" in
    PASS) PASS=$((PASS + 1)) ;;
    FAIL) FAIL=$((FAIL + 1)) ;;
    WARN) WARN=$((WARN + 1)) ;;
    SKIP) SKIP=$((SKIP + 1)) ;;
  esac
  printf '[%s] %-44s %s\n' "$status" "$name" "$detail"
}

have() { command -v "$1" >/dev/null 2>&1; }

tool_bin() {
  case "$1" in
    ripgrep) echo rg ;;
    fd) echo fd ;;
    neovim) echo nvim ;;
    openssh) echo ssh ;;
    gnu-sed) echo gsed ;;
    findutils) echo gfind ;;
    coreutils) echo gdate ;;
    *) echo "$1" ;;
  esac
}

echo "=== MAC-1 mac-verify ==="
echo "UTC:      $(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date)"
echo "Host:     $(hostname 2>/dev/null || echo unknown)"
echo "User:     ${USER:-unknown}"
echo "REPO:     $REPO_ROOT"
echo "uname:    $(uname -a 2>/dev/null || true)"
echo

if [[ "$(uname -s)" == "Darwin" ]]; then
  record PASS "platform" "Darwin"
  so_brew_shellenv
else
  record FAIL "platform" "expected Darwin, got $(uname -s)"
fi

# Shell
echo "SHELL=$SHELL"
if [[ "${SHELL:-}" == *zsh* ]]; then
  record PASS "shell.default" "$SHELL"
else
  record WARN "shell.default" "${SHELL:-unset} (want zsh)"
fi
if have zsh; then record PASS "shell.zsh" "$(zsh --version 2>&1 | head -n1)"; else record FAIL "shell.zsh" "missing"; fi
if have bash; then record PASS "shell.bash" "$(bash --version 2>&1 | head -n1)"; else record FAIL "shell.bash" "missing"; fi

# OS signals (best-effort)
if have scutil; then
  record PASS "hostname.computer" "$(scutil --get ComputerName 2>/dev/null || echo n/a)"
else
  record SKIP "hostname" "scutil unavailable"
fi

# systemsetup needs admin; fall back to /etc/localtime when it returns empty.
tz=""
if have systemsetup; then
  tz="$(systemsetup -gettimezone 2>/dev/null | awk -F': ' '{print $2}' || true)"
fi
if [[ -z "$tz" ]] && [[ -L /etc/localtime ]]; then
  tz="$(readlink /etc/localtime 2>/dev/null | sed -n 's|.*/zoneinfo/||p' || true)"
fi
if [[ "$tz" == "Europe/Istanbul" ]]; then
  record PASS "timezone" "$tz"
elif [[ -n "$tz" ]]; then
  record WARN "timezone" "$tz (want Europe/Istanbul)"
else
  record WARN "timezone" "unknown (want Europe/Istanbul)"
fi

if have fdesetup; then
  if fdesetup status 2>/dev/null | grep -qi "FileVault is On"; then
    record PASS "filevault" "On"
  else
    record WARN "filevault" "$(fdesetup status 2>/dev/null | tr '\n' ' ')"
  fi
else
  record SKIP "filevault" "unavailable"
fi

if [[ -d /System/Applications/Utilities/Terminal.app ]] || [[ -d /Applications/Utilities/Terminal.app ]]; then
  record PASS "terminal.app" "present"
else
  record WARN "terminal.app" "path not found (still usually available)"
fi

# Homebrew
if have brew; then
  record PASS "brew" "$(brew --version | head -n1)"
  echo "--- brew doctor ---"
  brew doctor
  doctor_rc=$?
  if [[ $doctor_rc -eq 0 ]]; then
    record PASS "brew.doctor" "clean"
  else
    record WARN "brew.doctor" "exit $doctor_rc"
  fi
else
  record FAIL "brew" "not installed"
fi

# Tools
for tool in git gh openssh curl wget jq yq tree ripgrep fd fzf tmux htop rsync \
            coreutils gnu-sed findutils gawk make shellcheck shfmt; do
  bin="$(tool_bin "$tool")"
  if have "$bin"; then
    case "$bin" in
      ssh) ver="$(ssh -V 2>&1)" ;;
      tmux) ver="$(tmux -V 2>&1)" ;;
      rsync) ver="$(rsync --version 2>&1 | head -n1)" ;;
      *) ver="$("$bin" --version 2>&1 | head -n1 | tr '\n' ' ')" ;;
    esac
    record PASS "tool.$tool" "$ver"
  else
    record FAIL "tool.$tool" "missing ($bin)"
  fi
done

for tool in bat eza btop watch ncdu neovim; do
  bin="$(tool_bin "$tool")"
  if have "$bin"; then
    record PASS "optional.$tool" "present"
  else
    record SKIP "optional.$tool" "not installed"
  fi
done

# SSH
if [[ -d "$HOME/.ssh" ]]; then
  mode="$(stat -f '%Lp' "$HOME/.ssh" 2>/dev/null || stat -c '%a' "$HOME/.ssh" 2>/dev/null || echo '?')"
  record PASS "ssh.dir" "mode $mode"
else
  record FAIL "ssh.dir" "missing"
fi

if [[ -f "$HOME/.ssh/id_ed25519.pub" ]] || [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
  record PASS "ssh.pubkey" "present"
else
  record FAIL "ssh.pubkey" "missing"
fi

if [[ -f "$HOME/.ssh/config" ]]; then
  missing=()
  for h in github lab arch; do
    grep -Eq "^[[:space:]]*Host[[:space:]]+${h}([[:space:]]|$)" "$HOME/.ssh/config" || missing+=("$h")
  done
  if [[ ${#missing[@]} -eq 0 ]]; then
    record PASS "ssh.config.hosts" "github lab arch"
  else
    record WARN "ssh.config.hosts" "missing: ${missing[*]}"
  fi
else
  record FAIL "ssh.config" "missing"
fi

echo "--- ssh -T git@github.com ---"
ssh_out="$(ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1)"
ssh_rc=$?
echo "$ssh_out"
if echo "$ssh_out" | grep -Eqi 'successfully authenticated|Hi '; then
  record PASS "ssh.github" "authenticated"
else
  record FAIL "ssh.github" "rc=$ssh_rc"
fi

for host in lab arch; do
  echo "--- ssh $host ---"
  out="$(ssh -o BatchMode=yes -o ConnectTimeout=8 "$host" 'hostname; whoami' 2>&1)"
  rc=$?
  echo "$out"
  if [[ $rc -eq 0 ]]; then
    record PASS "ssh.$host" "reachable"
  else
    record WARN "ssh.$host" "unreachable rc=$rc"
  fi
done

# Git / gh
if have git; then
  record PASS "git.version" "$(git --version)"
  gname="$(git config --global --get user.name 2>/dev/null || true)"
  gemail="$(git config --global --get user.email 2>/dev/null || true)"
  if [[ -n "$gname" && -n "$gemail" ]]; then
    record PASS "git.identity" "$gname <$gemail>"
  else
    record FAIL "git.identity" "unset"
  fi
fi

if have gh; then
  echo "--- gh auth status ---"
  gh auth status
  gh_rc=$?
  if [[ $gh_rc -eq 0 ]]; then
    record PASS "gh.auth" "authenticated"
  else
    record FAIL "gh.auth" "not authenticated"
  fi
else
  record FAIL "gh.auth" "gh missing"
fi

# Workspace
PROJECTS="${PROJECTS_DIR:-$HOME/Projects}"
required=(asir0z-smoothoperator asir0z-devopslab asir0z-web asir0z-product-intelligence)
optional=(asir0z-project-pulse asir0z-cortex)

if [[ -d "$PROJECTS" ]]; then
  record PASS "projects.root" "$PROJECTS"
else
  record FAIL "projects.root" "missing"
fi
echo "--- Projects ---"
ls -1 "$PROJECTS" 2>/dev/null || true

for repo in "${required[@]}"; do
  if [[ -d "$PROJECTS/$repo/.git" ]]; then
    record PASS "repo.$repo" "$(git -C "$PROJECTS/$repo" rev-parse --short HEAD 2>/dev/null || echo cloned)"
  else
    record FAIL "repo.$repo" "missing"
  fi
done
for repo in "${optional[@]}"; do
  if [[ -d "$PROJECTS/$repo/.git" ]]; then
    record PASS "repo.$repo" "present"
  else
    record SKIP "repo.$repo" "optional/deferred"
  fi
done

SO="$PROJECTS/asir0z-smoothoperator"
if [[ -d "$SO/.git" ]]; then
  git -C "$SO" fetch --dry-run origin 2>&1
  fetch_rc=$?
  if [[ $fetch_rc -eq 0 ]]; then
    record PASS "git.fetch.smoothoperator" "ok"
  else
    record FAIL "git.fetch.smoothoperator" "rc=$fetch_rc"
  fi
fi

# Dotfiles / wrappers
if [[ -f "$HOME/.zshrc" ]] && grep -q 'SmoothOperator\|asir0z-smoothoperator\|lab-health' "$HOME/.zshrc" 2>/dev/null; then
  record PASS "dotfiles.zshrc" "operator markers present"
else
  record WARN "dotfiles.zshrc" "operator zshrc not detected"
fi

if have cursor; then
  record PASS "cursor.cli" "$(command -v cursor)"
elif [[ -d "/Applications/Cursor.app" ]]; then
  record PASS "cursor.app" "/Applications/Cursor.app"
else
  record WARN "cursor" "not found"
fi

# Script syntax
echo "--- bash -n bootstrap scripts ---"
for s in mac-bootstrap.sh mac-packages.sh mac-verify.sh; do
  if bash -n "${SCRIPT_DIR}/$s" 2>&1; then
    record PASS "syntax.$s" "ok"
  else
    record FAIL "syntax.$s" "bash -n failed"
  fi
done

if have shellcheck; then
  echo "--- shellcheck scripts/**/*.sh ---"
  sc_fail=0
  while IFS= read -r -d '' f; do
    if ! shellcheck "$f"; then
      sc_fail=1
    fi
  done < <(find "$REPO_ROOT/scripts" -name '*.sh' -print0 2>/dev/null)
  if [[ $sc_fail -eq 0 ]]; then
    record PASS "shellcheck" "clean"
  else
    record WARN "shellcheck" "findings present"
  fi
else
  record WARN "shellcheck" "not installed"
fi

if have shfmt; then
  record PASS "shfmt" "$(shfmt --version 2>&1 | head -n1)"
else
  record WARN "shfmt" "not installed"
fi

# Remote health (only if lab reachable) — wrapper path, not local production logic
echo "--- remote production-health-check (lab) ---"
if ssh -o BatchMode=yes -o ConnectTimeout=8 lab 'hostname' >/dev/null 2>&1; then
  out="$(bash "$REPO_ROOT/scripts/ops/production-health-check.sh" 2>&1)"
  rc=$?
  echo "$out"
  if [[ $rc -eq 0 ]]; then
    record PASS "remote.lab.health" "ok"
  elif echo "$out" | grep -q 'RESULT='; then
    # Wrapper reached canonical Ubuntu script; non-zero is production status, not Mac failure.
    record WARN "remote.lab.health" "rc=$rc (canonical script ran; production RESULT non-zero — Ubuntu authority)"
  else
    record WARN "remote.lab.health" "rc=$rc (wrapper/SSH failure or missing remote script)"
  fi
else
  record SKIP "remote.lab.health" "lab not reachable — configure SSH first"
fi

echo
echo "=== SUMMARY ==="
echo "PASS=$PASS FAIL=$FAIL WARN=$WARN SKIP=$SKIP"
if [[ $FAIL -eq 0 ]]; then
  echo "RESULT: PASS (review WARN/SKIP before certification)"
  exit 0
fi
echo "RESULT: FAIL"
exit 1
