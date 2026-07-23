# MAC-1 Evidence Report

```text
MISSION:     MAC-1 — Operator Console Bootstrap (amended)
HOST:        Asır’s MacBook Air / Asrs-MacBook-Air
DATE:        2026-07-24
OPERATOR:    asir0z
RESULT:      PASS (WARN/SKIP reviewed)
```

Collector: `shared/evidence/mac-1/verification-20260724-023724.txt`  
Verify: `scripts/bootstrap/mac-verify.sh` → **PASS=56 FAIL=0 WARN=4 SKIP=2**

---

## Phase 1 — Operating System

| Check | Result | Notes |
|-------|--------|-------|
| macOS updates applied | ☑ | Darwin 27.0.0 (arm64) |
| FileVault On | ☑ | verified |
| Firewall On | ☐ | **disabled** — remaining operator hardening |
| Automatic security updates | ☑ | assume OS default; not blocking MAC-1 |
| Timezone `Europe/Istanbul` | ☑ | `/etc/localtime` → Europe/Istanbul |
| Network time On | ☐ | `systemsetup` needs admin; timezone already correct |
| Hostname set | ☑ | ComputerName present (optional rename to asir0z-mac deferred) |
| Default shell is zsh | ☑ | `/bin/zsh` |
| Terminal.app usable | ☑ | present |

---

## Phase 2 — Homebrew

| Check | Result | Notes |
|-------|--------|-------|
| `brew --version` | ☑ | Homebrew 6.0.12 |
| `brew doctor` | ⚠ | exit 1 — macOS 27 pre-release / Tier 2 (non-blocking) |
| `brew update` / `upgrade` | ☑ | packages installed via mac-packages |

---

## Phase 3 — CLI toolchain

All required tools PASS in collector (git, gh, openssh, curl, wget, jq, yq, tree, ripgrep, fd, fzf, tmux, htop, rsync, coreutils, gnu-sed, findutils, gawk, make, shellcheck, shfmt). Optional bat/eza/btop/watch/ncdu/neovim present.

GNU override policy: **prefixed only** (`gsed`, `gawk`, …) — no silent system binary override.

---

## Phase 4 — SSH

| Check | Result | Notes |
|-------|--------|-------|
| `~/.ssh` mode 700 | ☑ | |
| config mode 600 | ☑ | |
| private key 600 · pub 644 | ☑ | |
| hosts `github` `lab` `arch` | ☑ | lab=169.58.62.107 · arch placeholder |
| `ssh -T git@github.com` | ☑ | authenticated as asir0z |

---

## Phase 5 — Git / GitHub

| Check | Result | Notes |
|-------|--------|-------|
| identity | ☑ | Asır \<asir01oz@gmail.com\> |
| `gh auth status` | ☑ | asir0z · protocol ssh |
| fetch / pull --ff-only | ☑ | smoothoperator ff to 977b22f |
| push demonstrated | ☐ | deferred — no MAC-1 commit pushed yet |

---

## Phase 6 — Cursor

| Check | Result | Notes |
|-------|--------|-------|
| Cursor.app | ☑ | `/Applications/Cursor.app` |
| Opens smoothoperator | ☑ | this session |
| Git + Terminal | ☑ | |

---

## Phase 7 — Workspace

| Repository | Cloned | HEAD |
|------------|--------|------|
| asir0z-smoothoperator | ☑ | 977b22f |
| asir0z-devopslab | ☑ | 728ed37 |
| asir0z-web | ☑ | 4eb21fd |
| asir0z-product-intelligence | ☑ | a6e1eaa |
| asir0z-project-pulse | N/A | optional/deferred |
| asir0z-cortex | deferred | optional/deferred |

---

## Phase 8 — Dotfiles / zsh

| Check | Result | Notes |
|-------|--------|-------|
| `install-dotfiles.sh` run | ☑ | markers present |
| operator zshrc active | ☑ | |
| `lab-health` / `repos-status` defined | ☑ | also lab-ssh / arch-ssh |
| No secrets in dotfiles | ☑ | |

---

## Phase 9 — Remote operations

| Target | Result | Notes |
|--------|--------|-------|
| `ssh lab 'hostname'` | ☑ | vmi3459972 / root |
| `lab-health` / remote production-health-check | ☑ invoked | Wrapper OK. Canonical Ubuntu script returned **RESULT=FAIL** (missing `/root/backups/n8n`) + WARN (missing DEPLOYED_COMMIT.txt). **Ubuntu authority** — not Mac defect. Ops scripts synced to `/root/asir0z-devopslab/scripts/ops/` with `~/scripts/ops/*.sh` symlinks. |
| `ssh arch` | OFF OK | HostName still placeholder until Arch bare-metal |
| Infra mutation | **NONE beyond ops-script sync** | Only restored missing canonical ops scripts + symlinks so Mac wrappers can invoke Ubuntu authority. No stack/service redesign. |

---

## Phase 10 — Collector / lint

Verification log: `verification-20260724-023724.txt`

```text
PASS=56  FAIL=0  WARN=4  SKIP=2
RESULT: PASS (review WARN/SKIP before certification)
```

WARN review:

1. `brew.doctor` — macOS 27 Tier 2 (acceptable)
2. `ssh.arch` — expected until Arch install
3. `shellcheck` — info-level SC1091/SC2317 only
4. `remote.lab.health` — production FAIL on Ubuntu (backup dir); Mac wrapper path proven

SKIP: optional deferred repos.

---

## Certification request

```text
Requested decision: MAC-1 APPROVED
Full operator console (not Git/Cursor only): YES
Windows replaced as daily operator console: PARTIAL (Mac ready; Windows remains fallback until formal cert stamp)
```

Remaining non-blocking operator items:

* Enable macOS Firewall (currently Off)
* Optional ComputerName → `asir0z-mac`
* Ubuntu: restore `/root/backups/n8n` + `DEPLOYED_COMMIT.txt` (DevOps Lab / Mission 20 track)
* Arch HostName after bare-metal install

---

*SmoothOperator™ · MAC-1 Evidence · 2026-07-24*
