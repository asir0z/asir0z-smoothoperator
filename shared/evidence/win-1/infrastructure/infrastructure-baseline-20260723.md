# WIN-1 Infrastructure Baseline

> **Operator:** Asır  
> **Date:** 2026-07-23  
> **Hostname:** DESKTOP-P53S8B0  
> **Track:** Infrastructure *(sprint 1 — operator priority)*  
> **Collectors:** `shared/evidence/win-1/infrastructure/collectors/`  
> **Spec:** `windows/win-1-baseline/WIN-1-INFRASTRUCTURE-SPEC.md`

---

## Executive summary

Infrastructure sprint establishes the Windows host as the **canonical operator environment**. Baseline collectors confirm the post-migration toolchain is intact: Git, SSH, WSL, Docker Desktop, and VirtualBox paths are operational. One migration artifact was fixed (broken `bootstrap/` junction). Canonical SSH alias `devops-lab` added for transition production access.

**Result:** Infrastructure baseline **PASS** — ready for daily operator use. **WIN-1 Core** deferred until Observed Friction from real usage.

**Not performed:** startup cleanup, app removal, Ubuntu VM changes, Mission 20 work.

---

## Sprint goal

```text
Windows developer environment → canonical operator environment
```

---

## Git

| Item | Value | Status |
|------|-------|--------|
| Version | 2.53.0.windows.3 | ✅ |
| Global user | Asır · asir01oz@gmail.com | ✅ |
| core.autocrlf / eol | false / lf | ✅ |
| LFS | configured | ✅ |
| smoothoperator remote | `https://github.com/ASIR0Z/asir0z-smoothoperator.git` | ✅ |
| devopslab remote | `git@github.com:asir0z/asir0z-devopslab.git` | ✅ |
| Junction fix | Removed stale `bootstrap/` → `asir0z-engineering-platform` | ✅ |

---

## SSH

| Host alias | Target | Connectivity |
|------------|--------|--------------|
| `devops-lab` | 127.0.0.1:2222 · user `asir0z` | ✅ `asir0z-devopslab` |
| `contabo` | 169.58.62.107 · user `root` | ✅ `vmi3459972` |
| `arch-ws` | 127.0.0.1:2223 · user `asir0z` | ⏸️ VM powered off (expected) |

---

## WSL

| Distro | State | Version |
|--------|-------|---------|
| Ubuntu (default) | Stopped | WSL 2 |
| docker-desktop | Running | WSL 2 |

WSL version: 2.6.1.0 · kernel 6.6.87.2-1

---

## Docker Desktop

| Item | Value |
|------|-------|
| Desktop | 4.82.0 (233772) |
| Engine | 29.6.1 |
| Context | `desktop-linux` (active) |
| Memory | 15.49 GiB allocated |

Engine healthy. No container workload changes in this sprint.

---

## VirtualBox

| VM | Role | Shared folder |
|----|------|---------------|
| Arch-Engineering-Workstation | WS-1 · keep | `bootstrap` → `C:\Projects\asir0z-smoothoperator\linux\bootstrap` ✅ |
| DevOps-Lab-Ubuntu | Transition production · keep running | None |

VBox 7.2.12. Arch share path **canonical** — no update required.

---

## Terminal & toolchain

| Tool | Version |
|------|---------|
| Windows Terminal default | PowerShell 7 (`574e775e` profile) |
| PowerShell | 7.6.3 |
| Node.js | 22.20.0 |
| Python | 3.13.14 |
| winget | 1.29.280 |
| git-lfs | 3.7.1 |

---

## Implementation log

See `implementation-log.txt`. Mutations limited to:

1. Remove broken `bootstrap/` junction
2. Add `devops-lab` SSH host alias

---

## Deferred → WIN-1 Core

From WIN-0 classification — **not in Infrastructure sprint:**

- Startup cleanup (Epic, Razer, Edge auto-launch)
- App review / uninstall
- Disk hygiene (`asir0z-web-tmp`, gaming stack)
- Docker Desktop startup policy
- PowerShell duplicate install consolidation

These require **Observed Friction** from daily use after Infrastructure baseline.

---

## Deferred → Mission 20 / WIN-1A

| Item | Gate |
|------|------|
| Contabo production parity | Mission 20 |
| Ubuntu VM retirement | WIN-1A · observation window |

---

## Infrastructure checklist

| # | Item | Status |
|---|------|--------|
| 1 | Baseline collectors | ✅ |
| 2 | Broken junction removed | ✅ |
| 3 | SSH `devops-lab` | ✅ |
| 4 | VBox canonical path | ✅ |
| 5 | Git + remotes | ✅ |
| 6 | Docker + WSL health | ✅ |
| 7 | Baseline report | ✅ (this document) |

---

## Next step

```text
Daily operator use on Windows
  ↓
Observed Friction (natural)
  ↓
WIN-1 Core sprint
  ↓
Mission 20 (when WIN-1 does not block work)
```

**Default mode:** `No new evidence. Continue execution.` — daily Windows use; Core sprint when friction appears.

---

## Certification

```text
MISSION:        WIN-1 Infrastructure Baseline
STATUS:         APPROVED ✅
CERTIFICATION:  PASSED
LIFECYCLE:      FROZEN BASELINE
REMOTE:         SYNCHRONIZED ✅
DATE:           2026-07-23
COMMIT:         8b57fe8 · origin/master
```

---

*WIN-1 Infrastructure baseline · SmoothOperator™ · 2026-07-23*
