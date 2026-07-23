#!/usr/bin/env bash
# MAC-1 evidence collector — run on the Mac after bootstrap
# Spec: mac/mac-1-operator-console/MAC-1-SPEC.md
set -u

PASS=0
FAIL=0
WARN=0
SKIP=0

ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
hostname_val="$(hostname 2>/dev/null || echo unknown)"

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
  printf '[%s] %-40s %s\n' "$status" "$name" "$detail"
}

have() { command -v "$1" >/dev/null 2>&1; }

echo "=== MAC-1 verification ==="
echo "UTC:      $ts"
echo "Host:     $hostname_val"
echo "User:     ${USER:-unknown}"
echo "uname:    $(uname -a 2>/dev/null || true)"
echo

# --- Platform gate ---
if [[ "$(uname -s)" == "Darwin" ]]; then
  record PASS "platform" "Darwin"
else
  record FAIL "platform" "expected Darwin, got $(uname -s)"
fi

# --- Phase 1 signals (best-effort; some need admin) ---
if have scutil; then
  record PASS "hostname.computer" "$(scutil --get ComputerName 2>/dev/null || echo n/a)"
  record PASS "hostname.local" "$(scutil --get LocalHostName 2>/dev/null || echo n/a)"
else
  record SKIP "hostname" "scutil unavailable"
fi

if have systemsetup; then
  tz="$(systemsetup -gettimezone 2>/dev/null | awk -F': ' '{print $2}' || true)"
  if [[ "$tz" == "Europe/Istanbul" ]]; then
    record PASS "timezone" "$tz"
  else
    record WARN "timezone" "${tz:-unknown} (want Europe/Istanbul)"
  fi
  ntp="$(systemsetup -getusingnetworktime 2>/dev/null || true)"
  record PASS "network_time" "$ntp"
else
  record SKIP "timezone" "systemsetup unavailable"
fi

if have fdesetup; then
  if fdesetup status 2>/dev/null | grep -qi "FileVault is On"; then
    record PASS "filevault" "On"
  else
    record WARN "filevault" "$(fdesetup status 2>/dev/null | tr '\n' ' ')"
  fi
else
  record SKIP "filevault" "fdesetup unavailable"
fi

if have /usr/libexec/ApplicationFirewall/socketfilterfw; then
  fw="$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null || true)"
  if echo "$fw" | grep -qi "enabled"; then
    record PASS "firewall" "$fw"
  else
    record WARN "firewall" "$fw"
  fi
else
  record SKIP "firewall" "socketfilterfw unavailable"
fi

# --- Homebrew ---
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if have brew; then
  record PASS "brew" "$(brew --version | head -n1)"
  echo "--- brew doctor ---"
  brew doctor
  doctor_rc=$?
  if [[ $doctor_rc -eq 0 ]]; then
    record PASS "brew.doctor" "clean"
  else
    record WARN "brew.doctor" "exit $doctor_rc (review warnings)"
  fi
else
  record FAIL "brew" "not installed"
fi

# --- Dev tools (bash 3.2 compatible — macOS /bin/bash) ---
tool_bin() {
  case "$1" in
    ripgrep) echo rg ;;
    fd) echo fd ;;
    neovim) echo nvim ;;
    *) echo "$1" ;;
  esac
}

for tool in git gh wget curl jq tree htop ripgrep fd tmux neovim; do
  bin="$(tool_bin "$tool")"
  if have "$bin"; then
    ver="$("$bin" --version 2>&1 | head -n1 | tr '\n' ' ')"
    record PASS "tool.$tool" "$ver"
  else
    if [[ "$tool" == "neovim" ]]; then
      record WARN "tool.$tool" "optional missing"
    else
      record FAIL "tool.$tool" "missing ($bin)"
    fi
  fi
done

# --- SSH ---
if [[ -d "$HOME/.ssh" ]]; then
  mode="$(stat -f '%Lp' "$HOME/.ssh" 2>/dev/null || stat -c '%a' "$HOME/.ssh" 2>/dev/null || echo '?')"
  record PASS "ssh.dir" "mode $mode"
else
  record FAIL "ssh.dir" "missing ~/.ssh"
fi

if [[ -f "$HOME/.ssh/id_ed25519.pub" ]] || [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
  record PASS "ssh.pubkey" "present"
else
  record FAIL "ssh.pubkey" "no public key"
fi

if [[ -f "$HOME/.ssh/config" ]]; then
  missing_hosts=()
  for h in github lab arch; do
    if grep -Eq "^[[:space:]]*Host[[:space:]]+${h}([[:space:]]|$)" "$HOME/.ssh/config"; then
      :
    else
      missing_hosts+=("$h")
    fi
  done
  if [[ ${#missing_hosts[@]} -eq 0 ]]; then
    record PASS "ssh.config.hosts" "github lab arch"
  else
    record WARN "ssh.config.hosts" "missing: ${missing_hosts[*]}"
  fi
else
  record FAIL "ssh.config" "missing"
fi

echo "--- ssh -T git@github.com ---"
ssh_out="$(ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1)"
ssh_rc=$?
echo "$ssh_out"
# GitHub returns exit 1 on successful auth with greeting
if echo "$ssh_out" | grep -qi "successfully authenticated"; then
  record PASS "ssh.github" "authenticated"
elif echo "$ssh_out" | grep -qi "Hi "; then
  record PASS "ssh.github" "authenticated"
else
  record FAIL "ssh.github" "rc=$ssh_rc"
fi

for host in lab arch; do
  echo "--- ssh $host (batch, 8s) ---"
  out="$(ssh -o BatchMode=yes -o ConnectTimeout=8 "$host" 'hostname; whoami' 2>&1)"
  rc=$?
  echo "$out"
  if [[ $rc -eq 0 ]]; then
    record PASS "ssh.$host" "reachable"
  else
    record WARN "ssh.$host" "unreachable rc=$rc (fill HostName / power-on / authorize key)"
  fi
done

# --- Git / gh ---
if have git; then
  record PASS "git.version" "$(git --version)"
  gname="$(git config --global --get user.name 2>/dev/null || true)"
  gemail="$(git config --global --get user.email 2>/dev/null || true)"
  if [[ -n "$gname" && -n "$gemail" ]]; then
    record PASS "git.identity" "$gname <$gemail>"
  else
    record FAIL "git.identity" "user.name/email unset"
  fi
else
  record FAIL "git.version" "missing"
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

# --- Workspace ---
PROJECTS="${PROJECTS_DIR:-$HOME/Projects}"
required_repos=(asir0z-smoothoperator asir0z-devopslab asir0z-web asir0z-product-intelligence)
optional_repos=(asir0z-project-pulse asir0z-cortex)

if [[ -d "$PROJECTS" ]]; then
  record PASS "projects.root" "$PROJECTS"
else
  record FAIL "projects.root" "missing $PROJECTS"
fi

echo "--- ~/Projects ---"
ls -1 "$PROJECTS" 2>/dev/null || true

for repo in "${required_repos[@]}"; do
  if [[ -d "$PROJECTS/$repo/.git" ]]; then
    record PASS "repo.$repo" "$(git -C "$PROJECTS/$repo" rev-parse --short HEAD 2>/dev/null || echo cloned)"
  else
    record FAIL "repo.$repo" "missing"
  fi
done

for repo in "${optional_repos[@]}"; do
  if [[ -d "$PROJECTS/$repo/.git" ]]; then
    record PASS "repo.$repo" "present"
  else
    record SKIP "repo.$repo" "optional / deferred"
  fi
done

# SmoothOperator fetch proof
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

# --- Cursor ---
if have cursor; then
  record PASS "cursor.cli" "$(command -v cursor)"
elif [[ -d "/Applications/Cursor.app" ]]; then
  record PASS "cursor.app" "/Applications/Cursor.app"
else
  record WARN "cursor" "not found in PATH or /Applications"
fi

# --- Summary ---
echo
echo "=== SUMMARY ==="
echo "PASS=$PASS FAIL=$FAIL WARN=$WARN SKIP=$SKIP"
if [[ $FAIL -eq 0 ]]; then
  echo "RESULT: PASS (address WARN items before certification if material)"
  exit 0
fi
echo "RESULT: FAIL"
exit 1
