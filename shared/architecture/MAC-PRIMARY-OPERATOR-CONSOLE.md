# Platform Architecture Decision — Primary Operator Console

```text
Status: Accepted Architecture Direction
Scope: Long-Term Platform Architecture
Priority: Informational
Implementation: MAC-1 (operator bootstrap) AUTHORIZED
Type: Platform Architecture Decision
```

This document is **not** an operating-system preference. It describes the **long-term operational model** of the ecosystem — responsibility separation, not machine loyalty.

This document defines the architectural direction. **Implementation of the Mac operator workstation is mission MAC-1** — see [`mac/mac-1-operator-console/MAC-1-SPEC.md`](../../mac/mac-1-operator-console/MAC-1-SPEC.md).

---

## Purpose

The long-term goal is **not** to make the Arch Linux workstation mandatory.

The goal is to make the entire ecosystem manageable from a portable operator console regardless of whether the Arch machine is powered on.

The Mac is the **long-term target** for that role. The server remains the always-on infrastructure layer.

---

## Long-Term Architecture

```text
                    GitHub
                       │
        ┌──────────────┴──────────────┐
        │                             │
  Operator Console              Arch Linux
  (Mac — steady state)          AI Workstation
        │                             │
        └──────────────┬──────────────┘
                       │
                Ubuntu Server
             (DevOps Lab Core)
                       │
     Docker · n8n · Reverse Proxy
       Monitoring · Automation
                       │
      Telegram · APIs · Public Services
```

During bare-metal preparation, Windows temporarily holds the operator console role. See [Relationship with WIN-1](#relationship-with-win-1).

---

## Architectural Principles

The long-term platform is based on **responsibility separation** rather than machine preference.

### Operator Console

A portable client device acts as the primary operator console.

| Phase | Operator console |
|-------|------------------|
| Bare-metal prep (now) | Windows |
| Post-install validation | Arch + Windows fallback |
| Steady state (target) | Mac |

Changing the operator device must **not** require changes to the infrastructure architecture.

Typical responsibilities (regardless of which device holds the role):

* Daily development
* Cursor
* ChatGPT
* Git
* SSH
* Terminal
* Repository management
* Infrastructure operations
* Emergency recovery
* Monitoring
* Documentation

---

### Infrastructure

Ubuntu Server remains the permanent infrastructure layer.

Responsibilities include:

* Docker
* Reverse Proxy
* n8n
* Monitoring
* Automation
* Public services
* Scheduled jobs
* Telegram bots

Infrastructure must operate independently from both operator devices and compute workstations.

---

### Compute Layer

Arch Linux is a dedicated compute workstation.

Typical responsibilities include:

* AI workloads
* CUDA
* Local LLMs
* Heavy builds
* Experimental environments
* High-performance engineering work

Arch is intentionally **not** part of the production infrastructure.

The ecosystem must continue functioning even if Arch remains powered off for extended periods.

---

### Synchronization

Git remains the canonical source of truth.

```text
GitHub
   │
 ┌─┴───────────────┐
 │                 │
Operator         Arch
console
```

No manual file duplication. Repositories synchronize through Git.

Future synchronization technologies (Syncthing, Tailscale + rsync, external storage) are **implementation choices** — introduce only when operational evidence justifies them.

---

### Failure Independence

The architecture should satisfy the following properties:

* Arch may remain powered off indefinitely without affecting production services.
* Operator devices may change without affecting infrastructure.
* Infrastructure restarts must not affect development workstations.
* Production services must remain independent from local development environments.

#### If Arch is OFF

* Website remains online
* Telegram bots continue
* n8n continues
* Docker services continue
* Monitoring continues

No infrastructure outage.

#### If the operator console is unavailable

Infrastructure continues running. Operator access can later be restored from another device.

#### If the server restarts

Operator devices and Arch remain unaffected. Responsibilities stay separated.

---

## Remote Operations

The operator console should manage every system remotely.

Examples:

```bash
ssh lab
ssh arch
ssh nas
```

The operator should be able to deploy, monitor, update, troubleshoot, review logs, and restart services without physically accessing any machine.

---

## Apple Ecosystem Integration

Future Project Pulse architecture:

```text
Apple Watch
      │
Apple Health
      │
     Mac
      │
Project Pulse
      │
Ubuntu Server
      │
Telegram
```

The Apple ecosystem naturally integrates through the Mac (steady-state operator console).

Arch should not become a dependency for personal health or operational workflows.

---

## Engineering Principles

1. A portable operator console holds daily operations (Windows now → Mac steady state).
2. Ubuntu Server is the production infrastructure.
3. Arch is the compute workstation.
4. Git is the synchronization authority.
5. Infrastructure must not depend on Arch being powered on.
6. Every operational task should be executable from the operator console.
7. Compute and infrastructure responsibilities remain separated.

---

## Relationship with WIN-1

This document does **not** replace WIN-1.

WIN-1 correctly defines Windows as the current operator environment during migration and bare-metal preparation.

Long-term evolution:

```text
Today
  Windows
    ↓
Bare-metal preparation
    ↓
Arch bootstrap
    ↓
Mac becomes primary operator console
    ↓
Steady-state platform
```

No migration work is introduced by this document. It only records the intended destination.

Reference: `windows/win-1-baseline/WIN-1-INFRASTRUCTURE-SPEC.md`

---

## Relationship to Current Operations

| Phase | Operator environment | Notes |
|-------|---------------------|-------|
| Bare-metal prep | Windows (daily) + **MAC-1** on Mac | MAC-1 AUTHORIZED; Windows until MAC-1 certified |
| Post-install validation | Arch + Mac/Windows fallback | Arch bootstrap; Mac preferred if MAC-1 PASS |
| Steady state (target) | Mac | Primary operator console per this document |

Bare-metal install spec and shrink plan are **unchanged**. This document is reviewed and committed independently from disk shrink, Arch installation, bootstrap missions, and operational evidence.

---

## Implementation — MAC-1

Operator-console bootstrap is authorized as **MAC-1** (macOS only · no infrastructure mutation):

| Artifact | Path |
|----------|------|
| Mission | `shared/missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md` |
| Amendment | `shared/missions/MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md` |
| Bootstrap | `scripts/bootstrap/mac-bootstrap.sh` |
| Operator dotfiles | `shared/operator/` |
| Ops wrappers | `scripts/ops/` (Mac) → Ubuntu canonical scripts |
| Package / runbook | `mac/mac-1-operator-console/` |
| Evidence | `shared/evidence/mac-1/` |
| Certification | `shared/certification/MAC-1.md` |

MAC-1 PASS is the gate for declaring Mac the **daily** primary operator console. Until then, Windows remains the active daily console.

---

## Future Work

Potential improvements (incremental, evidence-justified only):

* SSH configuration simplification
* Unified terminal profiles
* Remote development workflows
* Automated synchronization
* Backup verification
* Secret management
* Infrastructure dashboards
* Project Pulse integration with Apple ecosystem

---

## Target State

> **Mac becomes the primary operator console. Ubuntu Server provides continuous infrastructure. Arch Linux serves as an on-demand high-performance workstation.**

This minimizes operational risk, improves flexibility, and ensures the ecosystem remains fully manageable regardless of the power state of the Arch workstation.

---

## Operational Roadmap

1. **MAC-1** — Mac operator console bootstrap (AUTHORIZED · operator execution)
2. Disk shrink / Arch installation (`arch-install-spec.md`) when authorized
3. Arch bootstrap
4. Production validation
5. Complete transition of daily operator role from Windows → Mac (after MAC-1 certification)

This document formalizes the long-term architectural destination. Bare-metal Arch remains independently gated; MAC-1 does not require Arch to be online.

---

*SmoothOperator™ · Accepted Architecture Direction · Platform Architecture Decision · Informational*
