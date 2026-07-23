# MAC-1 Evidence Report

```text
MISSION:     MAC-1 — Operator Console Bootstrap
HOST:        (ComputerName / LocalHostName)
DATE:        YYYY-MM-DD
OPERATOR:    asir0z
RESULT:      PASS | FAIL | PARTIAL
```

Copy to `mac-1-evidence-YYYYMMDD.md` and fill. Attach `verification-YYYYMMDD.txt`.

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

Commands / screenshots notes:

```text
(paste scutil / systemsetup / fdesetup summary — no secrets)
```

---

## Phase 2 — Homebrew

| Check | Result | Notes |
|-------|--------|-------|
| `brew --version` | ☐ | |
| `brew doctor` | ☐ | blocking issues? |
| `brew update` / `upgrade` | ☐ | |

```text
(paste brew doctor summary)
```

---

## Phase 3 — Development tools

| Tool | Present | Version |
|------|---------|---------|
| git | ☐ | |
| gh | ☐ | |
| wget | ☐ | |
| curl | ☐ | |
| jq | ☐ | |
| tree | ☐ | |
| htop | ☐ | |
| ripgrep (`rg`) | ☐ | |
| fd | ☐ | |
| tmux | ☐ | |
| neovim (`nvim`) | ☐ optional | |

---

## Phase 4 — SSH

| Check | Result | Notes |
|-------|--------|-------|
| `~/.ssh` exists (700) | ☐ | |
| Public key present | ☐ | filename only |
| Config hosts `github` `lab` `arch` | ☐ | |
| `ssh -T git@github.com` | ☐ | |

**Do not paste private keys.**

```text
(paste public key fingerprint or ssh -T greeting)
```

---

## Phase 5 — Git / GitHub

| Check | Result | Notes |
|-------|--------|-------|
| `user.name` / `user.email` | ☐ | |
| `gh auth status` | ☐ | |
| `git fetch` | ☐ | |
| `git push` demonstrated | ☐ | branch / commit |

---

## Phase 6 — Cursor

| Check | Result | Notes |
|-------|--------|-------|
| Cursor.app installed | ☐ | |
| Opens `~/Projects/asir0z-smoothoperator` | ☐ | |
| Git + Terminal usable | ☐ | |

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

## Phase 8 — Remote operations

| Target | Result | Notes |
|--------|--------|-------|
| `ssh lab` | ☐ PASS / ☐ blocked pending HostName / key | |
| `ssh arch` | ☐ PASS / ☐ OFF (acceptable) | |
| Infra mutation | **NONE** (required) | |

---

## Phase 9 — Collector

Verification log: `verification-YYYYMMDD.txt`

```text
PASS=  FAIL=  WARN=  SKIP=
RESULT:
```

---

## Certification request

```text
Requested decision: MAC-1 APPROVED | CHANGES REQUIRED | REJECTED
Evidence pack complete: YES / NO
Windows replaced as daily operator console: YES / NO / PARTIAL
```

---

*SmoothOperator™ · MAC-1 Evidence Template*
