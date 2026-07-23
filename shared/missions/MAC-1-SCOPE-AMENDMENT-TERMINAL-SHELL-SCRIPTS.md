# MAC-1 / MAC-2 Scope Amendment — Terminal, Shell, and Operator Scripts

```text
Status:     Approved Scope Amendment
Applies to: MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md · MAC-2-DEVELOPMENT-EXPERIENCE.md
Date:       2026-07-23
```

## Purpose

Ensure the Mac becomes a **complete and reproducible operator console**, not merely a Git/Cursor workstation.

## Decision

The Mac must include all terminal, shell, SSH, repository, deployment, verification, and operator-script capabilities required to manage the ecosystem independently.

> A clean Mac installation must be able to recover the complete operator environment from Git-tracked configuration and bootstrap scripts.

This amendment does **not** move production infrastructure onto the Mac.

* Ubuntu Server remains the always-on infrastructure layer.
* Arch remains the on-demand compute workstation.

## Responsibility split

| Layer | Location | Authority |
|-------|----------|-----------|
| Operator wrappers / aliases | Mac (`scripts/ops`, zsh functions) | Invocation only |
| Canonical production scripts | Ubuntu Server (`~/scripts/ops/…`) | Production truth |
| SmoothOperator bootstrap | This repo (`scripts/bootstrap`, `shared/operator`) | Operator recovery |

Example:

```bash
ssh lab '~/scripts/ops/production-health-check.sh'
# or Mac wrapper:
lab-health
```

Do not create random duplicated script copies on the Mac.

## Bare-metal track

Unchanged. Mac bootstrap may proceed independently.

---

Full requirements are merged into [MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md](MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md) and [MAC-2-DEVELOPMENT-EXPERIENCE.md](MAC-2-DEVELOPMENT-EXPERIENCE.md).

*SmoothOperator™ · Approved Scope Amendment*
