# MAC-1 — Operator Console Bootstrap

```text
Status:       AUTHORIZED ✅ · OPERATOR EXECUTION
Scope:        Operator Environment (macOS)
Priority:     High
Platform:     SmoothOperator™ · Mac
Type:         Workstation bootstrap — not infrastructure
Date:         2026-07-23
```

This mission prepares the Mac to become the **primary operator console** for the engineering ecosystem.

This is **not** an infrastructure mission.

* No production servers are modified.
* No DevOps services are deployed.
* No Ubuntu / Arch / Kubernetes changes.

Architecture authority: [`shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](../../shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md)

---

## Purpose

Establish a clean, reproducible, and portable Mac operator workstation that can:

* Access every Git repository
* Access every server through SSH
* Operate Cursor as the primary development environment
* Operate ChatGPT as the primary engineering assistant
* Build and review code
* Manage infrastructure remotely
* Work independently from the Arch workstation

---

## Success criteria

At completion, the Mac can replace Windows as the daily operator console for Git, SSH, Cursor, repository management, and remote infrastructure operations.

```text
Mac
 ↓
SSH
 ↓
Ubuntu Server (infrastructure)
```

No local infrastructure required on the Mac.

---

## Scope

### Included

| Area | Notes |
|------|-------|
| macOS updates | Security + system updates |
| FileVault · Firewall · auto security updates | Operator host hardening |
| Homebrew | Package manager |
| Dev tools | git, gh, wget, curl, jq, tree, htop, ripgrep, fd, tmux, neovim (optional) |
| SSH | `~/.ssh`, keys, host aliases (`lab`, `arch`, `github`) |
| Git | identity, default branch, GitHub auth |
| Cursor | install + repo workspace |
| Workspace | `~/Projects/` clone layout |
| Evidence | Phase 9 capture → `shared/evidence/mac-1/` |

### Excluded

* Ubuntu infrastructure changes
* Docker server deployment
* n8n deployment
* Arch installation / bare-metal
* Kubernetes
* Infrastructure migration
* Private key material in the repository

---

## Architecture alignment

| Layer | Role | Host |
|-------|------|------|
| Operator | Daily engineering console | **Mac** (this mission) |
| Infrastructure | Always-on services | Ubuntu Server |
| Compute | AI / heavy workloads | Arch Linux (on-demand) |
| Sync | Single source of truth | GitHub |

Production services remain independent from both Mac and Arch.

---

## Phases

| Phase | Title | Gate |
|-------|-------|------|
| 1 | Operating System | Updates · FileVault · Firewall · time/hostname/timezone |
| 2 | Package Manager | `brew doctor` / `update` / `upgrade` — no blocking issues |
| 3 | Development Tools | Every executable verified |
| 4 | SSH | Keys + config aliases prepared (no infra mutation) |
| 5 | Git | Identity + GitHub auth + clone/fetch/push |
| 6 | Cursor | Install · Git · Terminal · open `~/Projects` |
| 7 | Workspace | Canonical `~/Projects/` layout |
| 8 | Remote Operations | `ssh lab` / `ssh arch` reachability documented |
| 9 | Evidence | Collector output committed under `shared/evidence/mac-1/` |

Operator runbook: [`SETUP-GUIDE.md`](SETUP-GUIDE.md)  
Verify: [`verify/verify-mac1.sh`](verify/verify-mac1.sh)

---

## Canonical paths

| Item | Path |
|------|------|
| Project root | `~/Projects/` |
| This repo | `~/Projects/asir0z-smoothoperator` |
| SSH config | `~/.ssh/config` |
| Evidence | `shared/evidence/mac-1/` |
| Certification | `shared/certification/MAC-1.md` |

### Repository inventory

| Repository | Remote | Required |
|------------|--------|----------|
| asir0z-smoothoperator | `git@github.com:asir0z/asir0z-smoothoperator.git` | Yes |
| asir0z-devopslab | `git@github.com:asir0z/asir0z-devopslab.git` | Yes |
| asir0z-web | `git@github.com:asir0z/asir0z-web.git` | Yes |
| asir0z-product-intelligence | `git@github.com:asir0z/asir0z-product-intelligence.git` | Yes |
| asir0z-project-pulse | `git@github.com:asir0z/asir0z-project-pulse.git` | Yes if exists |
| asir0z-cortex | — | Deferred until GitHub repo restored |

---

## SSH aliases (prepared only)

| Alias | Purpose | Notes |
|-------|---------|-------|
| `lab` | Ubuntu Server / DevOps Lab | HostName filled by operator; no server-side change |
| `arch` | Arch workstation | May be powered off; document expected failure |
| `github` | `git@github.com` | Preferred for Git SSH |

Existing Windows/Arch aliases (`devops-lab`, `contabo`, `arch-ws`) remain valid on those hosts. Mac uses the portable names above; map HostName/User/IdentityFile during Phase 4.

**SSH key policy:** private keys never enter the repo, bootstrap trees, or evidence.

---

## Git identity (defaults)

Set only when unset:

| Key | Value |
|-----|-------|
| `user.name` | `Asır` |
| `user.email` | `asir01oz@gmail.com` |
| `init.defaultBranch` | `master` |
| `core.autocrlf` | `input` |
| `core.eol` | `lf` |

Signing is optional.

---

## Execution roles

| Role | Responsibility |
|------|----------------|
| **Operator (Mac)** | Run phases 1–9 on the Mac; paste evidence |
| **Cursor (this repo)** | Spec, scripts, templates, certification stubs |
| **Certification Authority** | Review evidence → APPROVED / CHANGES REQUIRED / REJECTED |

---

## Certification gate

MAC-1 **PASS** when evidence shows:

- [ ] macOS updates applied; FileVault · Firewall · auto updates enabled
- [ ] Time sync · hostname · timezone (`Europe/Istanbul`) verified
- [ ] Homebrew healthy (`brew doctor` no blockers)
- [ ] Dev tools installed and executable
- [ ] SSH keys present; `ssh -T git@github.com` succeeds
- [ ] `gh auth status` authenticated
- [ ] Git clone / fetch / push verified
- [ ] Cursor launches and opens `~/Projects/asir0z-smoothoperator`
- [ ] Required repositories present under `~/Projects/`
- [ ] Remote SSH aliases documented (reachability PASS or expected OFF)
- [ ] Evidence pack under `shared/evidence/mac-1/`
- [ ] Review updates `shared/certification/MAC-1.md` + `PLATFORM-STATE.md`

---

## Explicit non-goals

* Replacing Arch compute role
* Migrating production to Mac
* Installing Docker/Kubernetes locally as a substitute for the server
* Changing Contabo / Ubuntu Server configuration

---

## Next mission (after MAC-1 PASS)

* Continue Arch bare-metal installation when authorized
* Use the Mac as the primary operator console throughout remaining setup
* Windows becomes fallback, not daily primary

---

*SmoothOperator™ · MAC-1 · Operator Console Bootstrap*
