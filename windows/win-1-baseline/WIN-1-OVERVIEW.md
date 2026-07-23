# WIN-1 — Windows Engineering Baseline

> **Version:** 1.4 · 2026-07-23  
> **Status:** **AUTHORIZED ✅ · EXECUTION BLOCKED until Migration FROZEN**  
> **Platform:** SmoothOperator™ · Windows

---

## Purpose

Certified engineering baseline on the Windows operator host.

**Execution blocked until P0 close-out:** Migration must reach **100% · FROZEN** before any WIN-1 mutation. See [`P0-CLOSEOUT.md`](../../P0-CLOSEOUT.md).

---

## Priority (platform)

```text
P0 Close-out          PRIORITY 1  ⏳
  ↓
Migration FROZEN
  ↓
WIN-1 Core ∥ Infrastructure
  ↓
WIN-2.5 (spec approved · exec later)
  ↓
WS-2
  ↓
Mission 20 → Observation → WIN-1A
```

---

## WIN-1 — parallel tracks

Run **Core** and **Infrastructure** in parallel (two workstreams).

### WIN-1 Core

| Area | WIN-0 source |
|------|--------------|
| Startup | Epic, Razer, Edge autolaunch → Remove now |
| Temp | `asir0z-web-tmp`, duplicate `bootstrap/` |
| Apps | 14 unused / non-engineering apps |
| Disk | ~18 GB cleanup potential |
| Terminal | baseline inventory · no heavy config yet (WIN-2.5) |
| winget | consolidate · document reinstall set |

**Risk:** Low

### WIN-1 Infrastructure

| Area | Notes |
|------|-------|
| Docker Desktop | startup · disk · WSL backend |
| WSL | distros · disk |
| VirtualBox | inventory · shared folder path post-rename |
| SSH | config · keys inventory |
| Git | global config parity with Linux |
| winget | declarative baseline manifest |

**Risk:** Medium · inventory-first

**Excluded:** `DevOps-Lab-Ubuntu` → **WIN-1A** only (transition infrastructure).

---

## Evidence (on completion)

```text
shared/evidence/win-1/
├── core/
└── infrastructure/
```

Certification → `shared/certification/WIN-1.md` (update on acceptance)

---

## Related

| Doc | Path |
|-----|------|
| P0 | `P0-CLOSEOUT.md` |
| Migration gate | `shared/certification/MIGRATION.md` |
| Transition VM | `shared/evidence/win-1a/TRANSITION-INFRASTRUCTURE-REPORT.md` |

---

*SmoothOperator™ · asir0z-smoothoperator*
