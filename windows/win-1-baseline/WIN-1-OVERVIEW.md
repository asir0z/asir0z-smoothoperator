# WIN-1 — Windows Engineering Baseline

> **Version:** 1.0 · 2026-07-23  
> **Status:** SPECIFICATION — execution after **WIN-0 ACCEPTED**  
> **Platform:** SmoothOperator™ · Windows

---

## Purpose

Transform the operator Windows host from ad-hoc daily driver into a **certified engineering baseline** — including retirement of legacy local infrastructure that Contabo now supersedes.

---

## Sub-sprints

```text
WIN-1
├── WIN-1.0  Engineering Baseline      (startup, temp, disk, terminal, winget)
├── WIN-1.1  Legacy VM Removal         (DevOps-Lab-Ubuntu — see dedicated spec)
└── WIN-1.2  Storage Recovery          (post-removal verification)
```

| Order | Sprint | Mutation | Prerequisite |
|-------|--------|----------|--------------|
| 1 | WIN-0 | None (audit only) | — |
| 2 | WIN-1.0 partial | Controlled cleanup from WIN-0 buckets | WIN-0 ACCEPTED |
| 3 | WIN-1.1 | Remove legacy Ubuntu VM | WIN-1.1 gate (below) |
| 4 | WIN-1.2 | Verify disk recovery | WIN-1.1 ACCEPTED |

**Arch Workstation VM:** no changes in WIN-1.

---

## Target end state (VirtualBox)

```text
VirtualBox
└── Arch-Engineering-Workstation   (SmoothOperator Linux / WS-*)

Production Ubuntu Server  →  Contabo VPS (DevOps Lab canonical runtime)
```

---

## Lifecycle (all WIN-* sprints)

```text
Spec → Execute → Evidence → Certification → FROZEN
```

Evidence path: `shared/evidence/win-1/` (and subfolders per sub-sprint)

---

## Related specs

| Doc | Path |
|-----|------|
| WIN-0 audit | `windows/win-0-audit/WIN-0-SPEC.md` |
| WIN-1.1 legacy VM | `windows/win-1-baseline/WIN-1.1-LEGACY-VM-REMOVAL.md` |
