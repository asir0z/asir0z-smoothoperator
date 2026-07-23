# MAC-1 Setup Guide — Operator Runbook

> **Run on the Mac only.** Do not mutate production hosts.  
> **Canonical mission:** [`shared/missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md`](../../shared/missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md)  
> **Amendment:** [`shared/missions/MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md`](../../shared/missions/MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md)

---

## Before you start

1. Mac with admin access; Terminal.app available
2. GitHub account `asir0z`
3. SSH private key available **or** generate new + add to GitHub
4. Cursor download from [cursor.com](https://cursor.com)
5. Lab HostName/User known (fill into `~/.ssh/config` later — not committed)

---

## Phase 1 — Operating System

```bash
softwareupdate --list
sudo softwareupdate --install --all --agree-to-license
```

GUI: FileVault **On** · Firewall **On** · Automatic security updates **On**.

```bash
sudo scutil --set ComputerName "asir0z-mac"
sudo scutil --set LocalHostName "asir0z-mac"
sudo scutil --set HostName "asir0z-mac"
sudo systemsetup -settimezone Europe/Istanbul
sudo systemsetup -setusingnetworktime on
```

Shell check (keep zsh as default):

```bash
echo "$SHELL"          # expect .../zsh
zsh --version
bash --version
```

**Do not** change the login shell away from zsh during MAC-1.

---

## Phase 2 — Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || \
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
fi

brew doctor
brew update
```

---

## Phase 3 — CLI toolchain

```bash
cd ~/Projects/asir0z-smoothoperator   # after initial clone
bash scripts/bootstrap/mac-packages.sh
```

Required set includes: git, gh, jq, yq, ripgrep, fd, fzf, tmux, rsync, coreutils, gnu-sed, findutils, gawk, make, shellcheck, shfmt, …

GNU tools stay **prefixed** (`gsed`, `gawk`, …) unless you explicitly document overrides.

---

## Phase 4 — SSH

```bash
bash mac/mac-1-operator-console/scripts/configure-ssh.sh
# or copy shared/operator/dotfiles/ssh-config.example → ~/.ssh/config
```

Edit HostName for `lab` / `arch`. Fix permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

```bash
gh auth login -p ssh -h github.com
ssh -T git@github.com
```

---

## Phase 5 — Git

```bash
bash mac/mac-1-operator-console/scripts/configure-git.sh
# or rely on shared/operator/dotfiles/gitconfig via install-dotfiles.sh
gh auth status
git fetch --all --prune
```

---

## Phase 6 — Cursor

Install Cursor.app → open `~/Projects/asir0z-smoothoperator` → confirm Git + Terminal.

Optional: Command Palette → Install `cursor` command in PATH.

---

## Phase 7 — Workspace

```bash
bash mac/mac-1-operator-console/scripts/clone-repos.sh
# or: bash scripts/bootstrap/mac-bootstrap.sh  (includes packages + clones + dotfiles)
```

```text
~/Projects/
├── asir0z-smoothoperator/
├── asir0z-devopslab/
├── asir0z-web/
├── asir0z-product-intelligence/
└── …
```

---

## Phase 8 — Dotfiles / zsh baseline

```bash
bash shared/operator/scripts/install-dotfiles.sh
exec zsh -l
```

Expect: Git-aware prompt, history, completion, safe aliases, `lab-health` / `repos-status` helpers.  
No large plugin framework in MAC-1. Terminal.app remains the recovery terminal.

---

## Phase 9 — Remote operations (wrappers)

```bash
bash scripts/ops/ssh-check.sh
bash scripts/ops/repo-status.sh ~/Projects

# Only after lab HostName + key authorization are safe:
ssh lab 'hostname'
lab-health
# equivalent: bash scripts/ops/production-health-check.sh
```

Production health logic stays on the server:

```bash
ssh lab '~/scripts/ops/production-health-check.sh'
```

---

## Phase 10 — Evidence

```bash
mkdir -p shared/evidence/mac-1
bash scripts/bootstrap/mac-verify.sh | tee shared/evidence/mac-1/verification-$(date +%Y%m%d).txt
```

Also fill `shared/evidence/mac-1/MAC-1-EVIDENCE.template.md` → dated report.

Script lint (on Mac after packages):

```bash
bash -n scripts/bootstrap/mac-bootstrap.sh
find scripts -name '*.sh' -print0 | xargs -0 -n1 shellcheck
```

---

## One-shot bootstrap (after Homebrew + clone)

```bash
bash scripts/bootstrap/mac-bootstrap.sh
```

Still complete Phase 1 GUI hardening, Cursor install, `gh auth login`, and SSH HostName fills manually.

---

## Completion checklist

- [ ] zsh default · Terminal.app usable
- [ ] Homebrew + required CLI tools
- [ ] SSH aliases · GitHub auth
- [ ] Git round-trip
- [ ] Cursor
- [ ] `~/Projects` required repos
- [ ] Dotfiles installed
- [ ] `ssh lab` (or documented blocker)
- [ ] Remote health wrapper tested **or** deferred with reason
- [ ] Evidence committed
- [ ] Certification review

---

*SmoothOperator™ · MAC-1 Setup Guide*
