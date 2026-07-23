# MAC-1 Setup Guide — Operator Runbook

> **Run on the Mac only.**  
> **Spec:** [`MAC-1-SPEC.md`](MAC-1-SPEC.md)  
> **Verify:** [`verify/verify-mac1.sh`](verify/verify-mac1.sh)

No Ubuntu / Arch / Contabo changes in this guide.

---

## Before you start

1. Mac is powered on with admin access
2. Apple ID available for App Store / software updates if required
3. GitHub account `asir0z` accessible
4. Existing SSH private key available **or** willingness to generate a new key and add it to GitHub
5. Cursor download available from [cursor.com](https://cursor.com)

---

## Phase 1 — Operating System

### Updates

```bash
softwareupdate --list
sudo softwareupdate --install --all --agree-to-license
```

Or: **System Settings → General → Software Update → Update Now**.

### Hardening (GUI)

| Setting | Path | Target |
|---------|------|--------|
| FileVault | System Settings → Privacy & Security → FileVault | **On** |
| Firewall | System Settings → Network → Firewall | **On** |
| Auto security updates | System Settings → General → Software Update → Automatic Updates | Security responses + system files **On** |

### Identity / time

```bash
# Hostname (pick one durable name)
sudo scutil --set ComputerName "asir0z-mac"
sudo scutil --set LocalHostName "asir0z-mac"
sudo scutil --set HostName "asir0z-mac"

# Timezone
sudo systemsetup -settimezone Europe/Istanbul

# Time sync
sudo systemsetup -setusingnetworktime on
sntp -sS time.apple.com 2>/dev/null || true

# Verify
scutil --get ComputerName
scutil --get LocalHostName
scutil --get HostName
systemsetup -gettimezone
systemsetup -getusingnetworktime
date
```

**PASS:** updates applied · FileVault on · Firewall on · timezone `Europe/Istanbul` · network time on.

---

## Phase 2 — Homebrew

```bash
# Install (official)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon — add brew to PATH for this shell (installer prints the exact lines)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
fi

brew doctor
brew update
brew upgrade
```

**PASS:** `brew doctor` reports no blocking issues (warnings about optional PATH tweaks are OK if documented).

---

## Phase 3 — Development tools

Automated (preferred):

```bash
cd ~/Projects/asir0z-smoothoperator
bash mac/mac-1-operator-console/scripts/bootstrap-mac1.sh
```

Manual equivalent:

```bash
brew install git gh wget curl jq tree htop ripgrep fd tmux neovim
```

Verify:

```bash
for c in git gh wget curl jq tree htop rg fd tmux nvim; do
  command -v "$c" && "$c" --version 2>&1 | head -n1
done
```

(`rg` = ripgrep, `fd` = fd, `nvim` = neovim.)

---

## Phase 4 — SSH

```bash
bash mac/mac-1-operator-console/scripts/configure-ssh.sh
```

What the script does:

1. Creates `~/.ssh` (`700`)
2. Generates `~/.ssh/id_ed25519` if missing (ed25519, no overwrite)
3. Installs `config/ssh/config.template` → `~/.ssh/config` if missing
4. Prints next steps for GitHub key upload

Then edit `~/.ssh/config` and fill **HostName** for `lab` and `arch` (operator knowledge — not committed as secrets).

```bash
# Add public key to GitHub (interactive)
gh auth login -p ssh -h github.com
# or paste ~/.ssh/id_ed25519.pub at https://github.com/settings/keys

ssh -T git@github.com
# expect: Hi asir0z! You've successfully authenticated...
```

Aliases prepared:

| Host | Use |
|------|-----|
| `github` | Git over SSH |
| `lab` | Ubuntu Server / DevOps Lab |
| `arch` | Arch workstation |

**Do not** change server `authorized_keys` from this mission unless the operator already owns that key path of trust. Prefer uploading the Mac public key via existing admin access when ready.

---

## Phase 5 — Git

```bash
bash mac/mac-1-operator-console/scripts/configure-git.sh
gh auth status
```

Round-trip proof (uses this repo):

```bash
cd ~/Projects/asir0z-smoothoperator
git fetch origin
git status
# push only when you have a real commit on a feature branch
```

**PASS:** `user.name` / `user.email` set · `gh auth status` OK · `git fetch` OK · push demonstrated once.

---

## Phase 6 — Cursor

1. Install Cursor from [cursor.com/downloads](https://cursor.com/downloads) → drag to `/Applications`
2. Launch once; sign in
3. Enable / confirm: Git integration, integrated terminal
4. Install Shell Command: **Cursor → Command Palette → “Install 'cursor' command in PATH”** (optional but recommended)
5. Open workspace:

```bash
cursor ~/Projects/asir0z-smoothoperator
# or: open -a Cursor ~/Projects/asir0z-smoothoperator
```

**PASS:** Cursor opens the repo; terminal + git UI functional.

---

## Phase 7 — Workspace

```bash
bash mac/mac-1-operator-console/scripts/clone-repos.sh
```

Target layout:

```text
~/Projects/
├── asir0z-smoothoperator/
├── asir0z-devopslab/
├── asir0z-product-intelligence/
├── asir0z-web/
├── asir0z-project-pulse/     # skipped if remote 404
└── asir0z-cortex/            # deferred until restored
```

Git remains the synchronization authority — no manual copy from Windows/Arch.

---

## Phase 8 — Remote operations

```bash
ssh -o BatchMode=yes -o ConnectTimeout=8 lab 'hostname && whoami'
ssh -o BatchMode=yes -o ConnectTimeout=8 arch 'hostname && whoami'
```

Document results in evidence:

| Target | Expected |
|--------|----------|
| `lab` | PASS when HostName filled and key authorized |
| `arch` | PASS when powered on; **OFF is acceptable** — note it |
| Infrastructure mutate | **Not in MAC-1** |

Mac must be able to operate without Arch powered on.

---

## Phase 9 — Evidence

```bash
cd ~/Projects/asir0z-smoothoperator
mkdir -p shared/evidence/mac-1
bash mac/mac-1-operator-console/verify/verify-mac1.sh \
  | tee shared/evidence/mac-1/verification-$(date +%Y%m%d).txt
```

Also capture (append or separate files):

* `brew doctor`
* `git --version`
* `gh auth status`
* `ssh -T git@github.com`
* Cursor launch confirmation (one-line operator note)
* `ls ~/Projects`
* clone / push proof

Fill [`shared/evidence/mac-1/MAC-1-EVIDENCE.template.md`](../../shared/evidence/mac-1/MAC-1-EVIDENCE.template.md) → dated report.

Commit evidence from the Mac (or via Cursor cloud after sync):

```bash
git checkout -b cursor/mac-1-evidence-7f72   # or continue current branch
git add shared/evidence/mac-1/
git commit -m "evidence(mac-1): operator console bootstrap verification"
git push -u origin HEAD
```

---

## Completion checklist

- [ ] Phase 1 OS hardening
- [ ] Phase 2 Homebrew healthy
- [ ] Phase 3 tools verified
- [ ] Phase 4 SSH + GitHub auth
- [ ] Phase 5 Git round-trip
- [ ] Phase 6 Cursor
- [ ] Phase 7 `~/Projects` clones
- [ ] Phase 8 remote SSH documented
- [ ] Phase 9 evidence committed
- [ ] Certification Authority review → `shared/certification/MAC-1.md`

---

*SmoothOperator™ · MAC-1 Setup Guide*
