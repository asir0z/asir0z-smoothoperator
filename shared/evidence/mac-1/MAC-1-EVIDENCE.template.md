# MAC-1 Evidence Report

```text
MISSION:     MAC-1 — Operator Console Bootstrap (amended)
HOST:        (ComputerName / LocalHostName)
DATE:        YYYY-MM-DD
OPERATOR:    asir0z
RESULT:      PASS | FAIL | PARTIAL
```

Copy to `mac-1-evidence-YYYYMMDD.md` and fill. Attach `verification-YYYYMMDD.txt` from `scripts/bootstrap/mac-verify.sh`.

---

## Phase 1 — Operating System

| Check | Result | Notes |
|-------|--------|-------|
| macOS updates applied | ☐ | |
| FileVault On | ☐ | |
| Firewall On | ☐ | |
| Automatic security updates | ☐ | |
| Timezone `Europe/Istanbul` | ☐ | |
| Network time On | ☐ | |
| Hostname set | ☐ | |
| Default shell is zsh | ☐ | `echo $SHELL` |
| Terminal.app usable | ☐ | recovery terminal |

```text
(paste scutil / systemsetup / fdesetup / shell versions — no secrets)
```

---

## Phase 2 — Homebrew

| Check | Result | Notes |
|-------|--------|-------|
| `brew --version` | ☐ | |
| `brew doctor` | ☐ | blocking issues? |
| `brew update` / `upgrade` | ☐ | |

---

## Phase 3 — CLI toolchain

| Tool | Present | Version |
|------|---------|---------|
| git | ☐ | |
| gh | ☐ | |
| ssh (`ssh -V`) | ☐ | |
| curl / wget | ☐ | |
| jq / yq | ☐ | |
| tree | ☐ | |
| ripgrep (`rg`) / fd / fzf | ☐ | |
| tmux | ☐ | |
| htop | ☐ | |
| rsync | ☐ | |
| coreutils / gnu-sed / findutils / gawk | ☐ | prefixed OK |
| make | ☐ | |
| shellcheck / shfmt | ☐ | |
| bat / eza / btop (optional) | ☐ | |

GNU override policy documented: ☐ no silent PATH override / ☐ documented exception

---

## Phase 4 — SSH

| Check | Result | Notes |
|-------|--------|-------|
| `~/.ssh` mode 700 | ☐ | |
| config mode 600 | ☐ | |
| private key 600 · pub 644 | ☐ | |
| hosts `github` `lab` `arch` | ☐ | |
| `ssh -T git@github.com` | ☐ | |

**Do not paste private keys.**

---

## Phase 5 — Git / GitHub

| Check | Result | Notes |
|-------|--------|-------|
| identity | ☐ | |
| `gh auth status` | ☐ | |
| fetch / pull --ff-only | ☐ | |
| push demonstrated | ☐ | |

---

## Phase 6 — Cursor

| Check | Result | Notes |
|-------|--------|-------|
| Cursor.app | ☐ | |
| Opens smoothoperator | ☐ | |
| Git + Terminal | ☐ | |

---

## Phase 7 — Workspace

| Repository | Cloned | HEAD |
|------------|--------|------|
| asir0z-smoothoperator | ☐ | |
| asir0z-devopslab | ☐ | |
| asir0z-web | ☐ | |
| asir0z-product-intelligence | ☐ | |
| asir0z-project-pulse | ☐ / N/A | |
| asir0z-cortex | deferred | |

---

## Phase 8 — Dotfiles / zsh

| Check | Result | Notes |
|-------|--------|-------|
| `install-dotfiles.sh` run | ☐ | |
| operator zshrc active | ☐ | |
| `lab-health` / `repos-status` defined | ☐ | |
| No secrets in dotfiles | ☐ | |

---

## Phase 9 — Remote operations

| Target | Result | Notes |
|--------|--------|-------|
| `ssh lab 'hostname'` | ☐ | |
| `lab-health` / remote production-health-check | ☐ / deferred | only after safe SSH |
| `ssh arch` | ☐ PASS / ☐ OFF OK | |
| Infra mutation | **NONE** | required |

---

## Phase 10 — Collector / lint

```text
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

```text
bash -n scripts/bootstrap/mac-bootstrap.sh
find scripts -name '*.sh' -print0 | xargs -0 -n1 shellcheck
```

Verification log: `verification-YYYYMMDD.txt`

```text
PASS=  FAIL=  WARN=  SKIP=
RESULT:
```

---

## Certification request

```text
Requested decision: MAC-1 APPROVED | CHANGES REQUIRED | REJECTED
Full operator console (not Git/Cursor only): YES / NO
Windows replaced as daily operator console: YES / NO / PARTIAL
```

---

*SmoothOperator™ · MAC-1 Evidence Template*
