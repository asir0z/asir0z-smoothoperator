# WIN-1 Infrastructure — Canonical Operator Environment

> **Version:** 1.0 · 2026-07-23  
> **Track:** Infrastructure *(first — operator priority)*  
> **Status:** **EXECUTING**  
> **Goal:** Windows developer environment becomes the **canonical operator environment**.

---

## Scope

Infrastructure establishes the foundation all later Windows work depends on. **Core** (startup, disk, apps) waits until Infrastructure is certified and daily use produces Observed Friction.

| Area | In scope | Out of scope |
|------|----------|--------------|
| Git | Global config, project remotes, repo hygiene | GitHub org policy |
| SSH | Host aliases, connectivity to operator targets | Key rotation |
| WSL | Distro inventory, default distro | WSL distro rebuild |
| Docker Desktop | Engine health, context | Container workloads |
| VirtualBox | VM inventory, Arch shared folder path | Ubuntu VM removal → **WIN-1A** |
| Terminal | Default profile verification | Full WIN-2.5 workflow |
| Dev tools | Version inventory (Git, Node, Python, PS, winget) | App uninstall → **Core** |

**Explicitly excluded:** `DevOps-Lab-Ubuntu` retirement · production mutation · Mission 20 cutover.

---

## Execution order (operator priority)

```text
1. Infrastructure   ← this sprint
2. Core             ← after daily use + Observed Friction
3. Mission 20       ← when WIN-1 does not block operator work
```

---

## Canonical operator map

| Target | Access | Role |
|--------|--------|------|
| Windows host | Local | Primary operator shell |
| `devops-lab` | `ssh devops-lab` · NAT `:2222` | Transition production (Ubuntu VM) |
| `contabo` | `ssh contabo` | Mission 20 target host |
| `arch-ws` | `ssh arch-ws` · NAT `:2223` | WS-1 engineering workstation (when powered on) |

### Project roots

| Path | Remote |
|------|--------|
| `C:\Projects\asir0z-smoothoperator` | `https://github.com/ASIR0Z/asir0z-smoothoperator.git` |
| `C:\Projects\asir0z-devopslab` | `git@github.com:asir0z/asir0z-devopslab.git` |
| `C:\Projects\asir0z-web` | `git@github.com:asir0z/asir0z-web.git` |
| `C:\Projects\asir0z-product-intelligence` | `git@github.com:asir0z/asir0z-product-intelligence.git` |

### VirtualBox

| VM | State policy | Shared folder |
|----|--------------|---------------|
| Arch-Engineering-Workstation | Keep · power on when needed | `bootstrap` → `...\asir0z-smoothoperator\linux\bootstrap` |
| DevOps-Lab-Ubuntu | Keep running until Mission 20 + observation | None |

---

## Implementation checklist

| # | Action | Evidence |
|---|--------|----------|
| 1 | Read-only baseline collectors | `shared/evidence/win-1/infrastructure/collectors/` |
| 2 | Remove broken repo-root `bootstrap/` junction | `implementation-log.txt` |
| 3 | Canonical SSH alias `devops-lab` | `ssh-connectivity.txt` |
| 4 | Verify VBox `bootstrap` share path | baseline report |
| 5 | Verify Git global + project remotes | baseline report |
| 6 | Verify Docker + WSL engine health | baseline report |
| 7 | Infrastructure baseline report | `infrastructure-baseline-YYYYMMDD.md` |

---

## Certification gate

Infrastructure track **COMPLETE** when:

- [ ] Baseline report submitted
- [ ] Broken migration artifacts resolved (junction, paths)
- [ ] SSH connectivity PASS for `devops-lab` and `contabo`
- [ ] VBox Arch shared folder canonical
- [ ] No production mutation performed
- [ ] Review → update `shared/certification/WIN-1.md` + `PLATFORM-STATE.md`

Then: **daily operator use** → natural Observed Friction → **WIN-1 Core** sprint.

---

*SmoothOperator™ · WIN-1 Infrastructure*
