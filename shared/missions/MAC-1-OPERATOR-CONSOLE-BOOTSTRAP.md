# MAC-1 — Operator Console Bootstrap

```text
Status:       AUTHORIZED ✅ · OPERATOR EXECUTION
Scope:        Operator Environment (macOS) — full console baseline
Priority:     High
Platform:     SmoothOperator™ · Mac
Type:         Workstation bootstrap — not infrastructure
Date:         2026-07-23
Amendment:    MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md (Approved)
```

Package / runbook: [`mac/mac-1-operator-console/`](../../mac/mac-1-operator-console/)  
Architecture: [`../architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](../architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md)

---

## Purpose

Prepare the Mac as the **primary operator console** for the engineering ecosystem — recoverable from Git-tracked configuration and bootstrap scripts after a clean macOS install.

Not an infrastructure mission: no production server mutation, no DevOps service deployment, no Arch/Kubernetes changes.

---

## Success criteria

At completion, the Mac can:

* Run a reliable **zsh** operator environment
* Fall back to **Terminal.app** (never depend exclusively on a third-party terminal)
* Authenticate to GitHub (`gh` + SSH)
* Clone, inspect, commit, and push repositories
* Reach Ubuntu Server via `ssh lab`
* Invoke **canonical remote** operational scripts over SSH
* Run local verification and bootstrap scripts
* Restore operator configuration from Git-tracked sources
* Operate **without** Arch powered on

```text
Mac (wrappers · Git · Cursor · zsh)
        │
        ▼
   ssh lab / arch / github
        │
        ▼
Ubuntu Server  ← canonical production scripts
```

---

## Native shell

Default shell: **zsh** (macOS default). Do **not** replace the login shell during MAC-1.

Bash remains available for script compatibility.

```bash
echo "$SHELL"
zsh --version
bash --version
```

---

## Terminal

* **Terminal.app** must remain usable as the recovery terminal.
* Enhanced terminals (Ghostty, iTerm2) are **MAC-2** — optional.

---

## Required CLI tools

Install and verify via `scripts/bootstrap/mac-packages.sh`:

```text
git gh openssh curl wget jq yq tree ripgrep fd fzf tmux htop
rsync coreutils gnu-sed findutils gawk make shellcheck shfmt
```

Optional recommended: `bat eza btop watch ncdu neovim`

### GNU tools policy

Homebrew may install GNU tools with **prefixed** names (`gsed`, `gawk`, `gdate`, …).

* Do **not** silently override macOS system binaries unless explicitly documented.
* Scripts that need GNU behavior must call prefixed binaries or set a documented PATH segment.

---

## SSH operator layer

Aliases (HostName filled only during operator execution):

```bash
ssh lab
ssh arch
ssh github
```

Required artifacts:

```text
~/.ssh/config
~/.ssh/known_hosts
~/.ssh/*.pub
```

Permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/<private-key>
chmod 644 ~/.ssh/<public-key>.pub
```

Private keys / secrets never committed. Template: `shared/operator/dotfiles/ssh-config.example`

---

## Shared operator scripts

```text
scripts/
├── bootstrap/
│   ├── mac-bootstrap.sh
│   ├── mac-packages.sh
│   └── mac-verify.sh
├── ops/
│   ├── production-health-check.sh   # Mac wrapper → ssh lab
│   ├── server-status.sh
│   ├── ssh-check.sh
│   └── repo-status.sh
├── deploy/
│   └── remote-deploy-wrapper.sh
└── lib/
    ├── common.sh
    ├── logging.sh
    └── platform.sh
```

Mac wrappers simplify invocation; **Ubuntu remains production authority**.

---

## Script design rules

* Shebang + strict mode where compatible (`set -Eeuo pipefail`)
* Fail clearly · quote variables · validate commands
* No hard-coded secrets
* macOS BSD-compatible **or** explicit Homebrew GNU tools
* ShellCheck where practical
* Platform detection via `scripts/lib/platform.sh`

---

## Dotfiles (secret-free)

```text
shared/operator/
├── README.md
├── dotfiles/
│   ├── zshrc
│   ├── gitconfig
│   ├── tmux.conf
│   └── ssh-config.example
└── scripts/
    └── install-dotfiles.sh
```

### Zsh baseline (MAC-1)

Stable operator functions only — **no large plugin framework**:

* Git-aware prompt
* History + completion
* fzf integration (when installed)
* Safe aliases
* Repository navigation
* SSH / operator wrappers (`lab-health`, `lab-ssh`, `repos-status`, …)

MAC-2 may add Starship, zoxide, syntax highlighting, autosuggestions.

---

## Recommended operator commands

| Command | Behavior |
|---------|----------|
| `lab-health` | `ssh lab '~/scripts/ops/production-health-check.sh'` |
| `lab-status` | `ssh lab` host/uptime summary |
| `lab-ssh` | interactive `ssh lab` |
| `arch-ssh` | interactive `ssh arch` |
| `repos-status` | local multi-repo status under `~/Projects` |
| `repos-pull` | `git pull --ff-only` per clean repo (no force) |
| `deploy-web` / `deploy-pi` | wrappers → remote deploy (MAC-2 polish OK) |

---

## Repository synchronization

Git remains the sync authority. Support:

```bash
git clone
git fetch --all --prune
git pull --ff-only
git status · git diff · git commit · git push
```

`scripts/ops/repo-status.sh` reports path, branch, dirty/clean, ahead/behind, remote failures — **never** auto-commit, reset, rebase, or force-push.

---

## Secrets

Acceptable initial options: macOS Keychain · `gh auth` · SSH agent.

Never store secrets in `.zshrc`, Git, plain-text notes, operator scripts, or aliases.

---

## Tailscale / runtimes

* **Tailscale** → MAC-2 (unless immediate access requires it during MAC-1)
* **Runtime managers** (uv, mise/fnm, pnpm) → MAC-2 after documented strategy

---

## Evidence (amended)

Capture:

```bash
echo "$SHELL"
zsh --version
bash --version
ssh -V
rsync --version
jq --version
shellcheck --version
shfmt --version
tmux -V
git --version
gh auth status
```

Script verification:

```bash
bash -n scripts/bootstrap/mac-bootstrap.sh
find scripts -name '*.sh' -print0 | xargs -0 -n1 shellcheck
```

Remote (only after SSH safely configured):

```bash
ssh lab 'hostname'
ssh lab '~/scripts/ops/production-health-check.sh'
```

Evidence path: `shared/evidence/mac-1/`

---

## Phases (execution)

| Phase | Title |
|-------|-------|
| 1 | OS updates · FileVault · Firewall · time/hostname/timezone |
| 2 | Homebrew |
| 3 | CLI toolchain (`mac-packages.sh`) |
| 4 | SSH keys + aliases |
| 5 | Git identity + GitHub auth |
| 6 | Cursor |
| 7 | `~/Projects` clones |
| 8 | Dotfiles (`shared/operator`) + zsh baseline |
| 9 | Remote ops wrappers · `ssh lab` · optional remote health |
| 10 | Evidence (`mac-verify.sh`) |

Operator runbook: [`mac/mac-1-operator-console/SETUP-GUIDE.md`](../../mac/mac-1-operator-console/SETUP-GUIDE.md)

---

## Explicit non-goals

* Replacing Arch compute role
* Migrating production onto the Mac
* Installing Docker/Kubernetes as a server substitute
* Changing Contabo / Ubuntu configuration from this mission
* Large zsh plugin frameworks (→ MAC-2)

---

## Certification

See [`../certification/MAC-1.md`](../certification/MAC-1.md).

---

*SmoothOperator™ · MAC-1 · Operator Console Bootstrap*
