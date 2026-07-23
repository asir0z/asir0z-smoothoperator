# SmoothOperator™ — Certification Records

Certification is **separate from evidence**.

```text
Evidence        →  Reality
Certification   →  Decision
```

| Layer | Path | Purpose |
|-------|------|---------|
| **Evidence** | `shared/evidence/<sprint>/` | Raw audit output, verification logs, screenshots, collector dumps |
| **Certification** | `shared/certification/<SPRINT>.md` | Reviewer decision, lifecycle state, gate conditions |

Lifecycle for every sprint:

```text
Spec → Execute → Evidence → Certification → FROZEN
```

Certification files are the canonical **approval record**. Evidence supports them; it does not replace them.

---

## Platform maturity (2026-07-23)

```text
SmoothOperator™

FOUNDATION     COMPLETE ✅
GOVERNANCE     COMPLETE ✅
LIFECYCLE      COMPLETE ✅
EXECUTION      ACTIVE
```

New architecture velocity: **low**. Value now comes from real usage friction → evidence → decision.

---

## Platform state (locked)

```text
Foundation        FROZEN ✅
Governance        FROZEN ✅
Lifecycle         FROZEN ✅

Migration         95% (P0 pending)
WIN-1             Authorized / blocked until Migration FROZEN
Mission 20        Awaiting execution
WIN-1A            Blocked
```

**New sprint gate:** proven friction only — "good idea" alone is insufficient.

**Certification policy:**

```text
Observed Friction → Specification → Implementation → Evidence → Review → Certification
```

**Success metric:** real friction closed with minimum complexity and verifiable evidence — not document volume.

**Next reviewer decision:** P0 evidence → Migration **100% · CERTIFIED · FROZEN** → focus shifts to WIN-1 + Mission 20.

**Working note (not methodology):** [STOP-SYNC-START-ENGINEERING.md](../working-notes/STOP-SYNC-START-ENGINEERING.md) — when to stop synchronizing and resume execution.

---

No new architecture decisions. Current gates held:

| Gate | Status |
|------|--------|
| **Migration** | 95% · P0 close-out pending → **100% · CERTIFIED · FROZEN** |
| **WIN-1** | Spec + auth ready · **execution waits for Migration FROZEN** |
| **Mission 20** | Critical DevOps Lab track · parity + cutover + observation |

**Mission 20 acceptance:** *Production users cannot tell that infrastructure changed.*

---

## Certification Authority workflow

Reviewer role: **Certification Authority** (not ongoing architecture).

```text
Specification → Evidence → Review → Decision
```

| Result | Meaning |
|--------|---------|
| **APPROVED** | Proceed to next gate or FROZEN |
| **REJECTED** | Stop; do not execute |
| **CHANGES REQUIRED** | Revise spec or evidence; re-submit |

**Review principles (four questions — any NO → not approved):**

1. Is there **evidence** showing the observed problem?
2. Does the proposed change **actually solve** that problem?
3. Is **sprint scope** preserved?
4. Is the change **rollback-capable and verifiable**?

**P0 (operator):** paste `git status` · `remote -v` · `branch -vv` · `log -5` + path `C:\Projects\asir0z-smoothoperator` → reviewer certifies **Migration 100% · FROZEN**.

**WIN-1:** execution remains blocked until Migration FROZEN.

---

Foundation is sufficient. **Slow new mission velocity.** Solve real friction from daily use.

**Standard emerges from usage — not from the spec alone:**

```text
Specification → Implementation → Real Usage → Evidence → Review → Standard
```

Example: Flow Launcher may win on paper; after two weeks PowerToys Run may win in practice — update the standard with evidence.

**Sprint opener (one question):**

```text
What is today's bottleneck?
```

| When | Bottleneck |
|------|------------|
| Now | Windows operator environment (P0 → WIN-1) |
| Next | Contabo runtime parity (Mission 20) |
| Then | Arch daily workflow (WS-2) |

---

## Active tracks (three)

```text
SmoothOperator™     P0 → WIN-1 → WIN-2.5 → WS-2
DevOps Lab™           Mission 20 → Parity → Cutover → Observation → Retirement
Products              standby until Contabo production complete
```

---

## Future layer (not started)

Target architecture — **no sprint opened yet**:

```text
shared/
├── evidence/
├── certification/
└── standards/          ← product-independent rules
    ├── sprint-lifecycle.md
    ├── naming.md
    ├── evidence-rules.md
    └── ...
```

`standards/` would hold cross-platform engineering rules (Windows, Linux, future hosts). Defer until after WIN-1 Core delivers measurable Windows improvements.

---

## Current certifications

| File | Status |
|------|--------|
| [WS-1.md](WS-1.md) | CERTIFIED · FROZEN |
| [WIN-0.md](WIN-0.md) | APPROVED |
| [WIN-1.md](WIN-1.md) | AUTHORIZED · NOT STARTED |
| [WIN-2.5.md](WIN-2.5.md) | SPEC APPROVED · **WAITING FOR WIN-1** · exec NOT authorized |
| [TRANSITION-INFRASTRUCTURE-REVIEW.md](TRANSITION-INFRASTRUCTURE-REVIEW.md) | APPROVED ✅ |
| [MIGRATION.md](MIGRATION.md) | 95% · APPROVED · pending FROZEN gate |

---

*SmoothOperator™ · asir0z-smoothoperator*
