#!/usr/bin/env bash
# WS-1 evidence capture — run as asir0z (not root).
# Spec: asir0z-devopslab/docs/cross-project/DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md section 7
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  echo "Run as asir0z, not root: su - asir0z -c 'bash $0'" >&2
  exit 1
fi

pass=0
fail=0

check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "✓ $label"
    pass=$((pass + 1))
  else
    echo "✗ $label"
    fail=$((fail + 1))
  fi
}

section() { echo; echo "=== $1 ==="; }

section "WS-1 Verification"
date -Iseconds
hostname
uname -r

section "Checklist"
check "OS (hostname)" test -n "$(hostname)"
check "Kernel (uname -r)" test -n "$(uname -r)"
check "Packages (git)" pacman -Q git
check "Packages (jq)" pacman -Q jq
check "Packages (ripgrep)" pacman -Q ripgrep
check "Packages (github-cli)" pacman -Q github-cli
check "Packages (python)" pacman -Q python
check "Packages (nodejs)" pacman -Q nodejs
check "Git" git --version
check "SSH (authorized_keys)" test -s "${HOME}/.ssh/authorized_keys"
check "Shell" test -n "${SHELL:-}"
check "Session (systemctl)" systemctl is-system-running
check "Network (archlinux.org)" ping -c1 -W3 archlinux.org
check "GitHub CLI" gh --version
check "Disk (/)" df -h /
check "Memory" free -h
check "Pacman health (git db)" pacman -Q git

section "Detail"
echo "SHELL=${SHELL:-unset}"
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-unset}"
systemctl is-system-running
systemctl is-enabled sddm 2>/dev/null || echo "sddm: n/a from this session"
git --version
jq --version
rg --version
gh --version
python --version
node --version
npm --version
df -h / | tail -1
free -h | awk '/^Mem:/ {print}'

section "WS-1 RESULT"
echo "PASS checks: $pass"
echo "FAIL checks: $fail"
if [[ "$fail" -eq 0 ]]; then
  echo "WS-1 RESULT"
  echo "PASS"
  exit 0
else
  echo "WS-1 RESULT"
  echo "FAIL"
  exit 1
fi
