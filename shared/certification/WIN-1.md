# WIN-1 Certification Gate

```text
SPRINT:     WIN-1 — Engineering Baseline (Core ∥ Infrastructure)
PLATFORM:   SmoothOperator™ · Windows
SPEC:       AUTHORIZED ✅
EXECUTION:  NOT STARTED — gated on Migration FROZEN
DATE:       2026-07-23
REVIEWER:   Operator review
```

## Execution gate

| Gate | Status |
|------|--------|
| WIN-0 APPROVED | ✅ |
| Transition Infrastructure Review | ✅ |
| Migration **100% · FROZEN** | ⏳ **P0 PRIORITY 1** |
| Explicit WIN-1 execution start | ⏳ after Migration FROZEN |

**Do not mutate Windows until** `shared/certification/MIGRATION.md` reads **FROZEN**.

## Parallel tracks (when authorized)

```text
WIN-1
├── Core            startup · temp · apps · disk · terminal · winget
└── Infrastructure  Docker Desktop · WSL · VirtualBox · SSH · Git · winget
```

Two tracks may proceed in parallel — separate evidence subfolders optional.

## Not in WIN-1

Ubuntu VM removal → **WIN-1A** after Mission 20 + observation.

---

*Certification gate · SmoothOperator™*
