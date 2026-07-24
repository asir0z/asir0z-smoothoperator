# Mac Engineering Station — Foundation v1.0

```text
Status:       ACCEPTED
Version:      1.0
Date:         2026-07-24
Layer:        Foundation
Type:         Canonical foundation (principles only)
Provenance:   Derived from shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md
              (Accepted Architecture Direction) + certified MAC-1 outcomes
```

**This document answers only foundation questions.** It must not contain package lists, Brewfiles, app names, verification commands, workspace layouts, or focus modes.

Upstream architecture: [`../../shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](../../shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md)

---

## What is the Mac?

The Mac is the **primary Operator Console** and **Engineering Station** for the SmoothOperator™ ecosystem.

It is a portable human-facing workstation for development, repository management, documentation, and remote control of infrastructure and compute hosts.

It is **not** a production server.

---

## Why does it exist?

So the entire ecosystem remains operable when compute hosts are offline and without requiring physical access to infrastructure machines.

The Mac exists to make daily engineering and operations **independent of Arch power state**, while Ubuntu continues to run production services continuously.

---

## What does it own?

* Operator environment (shell, terminal recovery path, local tooling)
* Local engineering toolchain configuration (reproducible via Git)
* Git-tracked operator configuration and wrappers
* Repository management on the operator device
* Remote invocation of infrastructure and compute (SSH / private networking)
* Operator documentation and evidence collection for Mac missions
* Human approval for destructive or production-mutating actions initiated from the console

---

## What does it not own?

* Production infrastructure (Docker, reverse proxy, n8n, public services, scheduled jobs)
* Canonical production operational scripts (authority remains on Ubuntu)
* Always-on service availability
* Heavy AI / CUDA / local-LLM compute workloads (Arch)
* Platform source-of-truth synchronization (GitHub / Git)

The Mac may **invoke** remote systems. It must not **become** those systems.

---

## How does it relate to Arch?

```text
Mac  → Operator / Engineering Station
Arch → On-demand Compute Workstation
```

* Arch may remain powered off indefinitely without breaking production or Mac daily ops.
* Mac must not depend on Arch for operator console function.
* Large AI workloads belong on Arch; Mac AI tools are clients only when present.

---

## How does it relate to Ubuntu?

```text
Mac     → Operator (wrappers · aliases · verification)
Ubuntu  → Infrastructure (canonical production scripts · services)
```

* Ubuntu is the always-on infrastructure layer.
* Mac wrappers call remote canonical scripts (example pattern: `lab-health` → `ssh lab '~/scripts/ops/…'`).
* Production logic is not duplicated on the Mac.

---

## How does SmoothOperator coordinate it?

SmoothOperator™ is the operator engineering platform repository that holds:

* Architecture decisions
* Missions and amendments
* Evidence and certification records
* Mac bootstrap / verify scripts and secret-free operator config

Coordination model:

```text
GitHub (source of truth)
    ↓
SmoothOperator missions + evidence + certification
    ↓
Mac implements operator capabilities
    ↓
Remote SSH to Ubuntu / Arch as needed
```

Living platform state remains in [`../../shared/certification/PLATFORM-STATE.md`](../../shared/certification/PLATFORM-STATE.md).

---

## Principles that never change

1. **Responsibility separation** — Operator ≠ Infrastructure ≠ Compute.
2. **Git is synchronization authority** — no manual duplication as the sync model.
3. **Ubuntu remains production authority** — Mac does not host production stacks.
4. **Arch is optional for daily ops** — compute on demand, not a required dependency.
5. **Failure independence** — each layer can fail or sleep without collapsing the others’ roles.
6. **Evidence-first certification** — claims require immutable evidence and a certification decision.
7. **Wrappers only for production** — invoke remote canonical scripts; do not reimplement them locally.
8. **Secrets never in Git** — keys and tokens stay in Keychain / agents / approved secret stores.
9. **Human approval for destructive actions** — automation assists; it does not silently destroy.
10. **Document layer discipline** — each change updates only the owning documentation layer.

---

## Explicit non-content (belongs elsewhere)

| Content | Owning layer |
|---------|----------------|
| Package / app lists · Brewfile | Mission / implementation / software baseline |
| Verification commands | Mission · Evidence · Verification scripts |
| Capability “how” with tool names | Capability specs · ADRs |
| Process / gates / drift | Governance |
| PASS/FAIL records | Certification |

---

## Versioning

* Foundation changes require an ADR and governance review.
* Additive clarifications may ship as v1.x; principle changes require v2.0.

---

*SmoothOperator™ · Mac Engineering Station · Foundation v1.0*
