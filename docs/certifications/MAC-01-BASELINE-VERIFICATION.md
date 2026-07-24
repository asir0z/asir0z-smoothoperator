# Certification — MAC-01 Baseline Verification

```text
Certification ID:  CERT-MAC-01
Mission:           MAC-1 — Operator Console Bootstrap
                   shared/missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md
Evidence References:
  - shared/evidence/mac-1/mac-1-evidence-20260724.md
  - shared/evidence/mac-1/verification-20260724-023724.txt
Capability Version: N/A (pre-capability-catalog era; baseline operator console)
Interface Version:  N/A (wrapper pattern established; formal IFACE specs pending)
Decision Records:
  - shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md (Accepted)
  - shared/missions/MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md (Approved)
  - shared/certification/MAC-1.md (CERTIFIED)
Git Commit:        4ea7e3d (evidence certify) · stamp 156240e
Decision:          APPROVED
Reviewer:          Certification Authority
Timestamp:         2026-07-24
Lifecycle:         CERTIFIED
Blocking Issues:   None
```

Foundation: [`../foundation/MAC-ENGINEERING-STATION-FOUNDATION-v1.0.md`](../foundation/MAC-ENGINEERING-STATION-FOUNDATION-v1.0.md)  
Legacy gate: [`../../shared/certification/MAC-1.md`](../../shared/certification/MAC-1.md)  
Standard: [`../standards/CERTIFICATION-STANDARD.md`](../standards/CERTIFICATION-STANDARD.md)

---

## Summary

MAC-01 verifies that the Mac meets the **baseline Operator Console** acceptance criteria established by mission MAC-1.

Collector result: **PASS=56 FAIL=0 WARN=4 SKIP=2**.

Mac is primary operator console. Windows is fallback.

---

## Evidence chain

| Artifact | Role |
|----------|------|
| `verification-20260724-023724.txt` | Immutable collector output |
| `mac-1-evidence-20260724.md` | Operator evidence report |
| `shared/certification/MAC-1.md` | SmoothOperator certification gate |

---

## Acceptance mapping

| Criterion (amended MAC-1) | Result |
|---------------------------|--------|
| zsh · Terminal.app recovery | PASS |
| Homebrew · CLI toolchain | PASS (brew doctor WARN — macOS 27 Tier 2) |
| GNU tools policy | PASS |
| SSH · GitHub | PASS |
| Git identity · gh auth | PASS |
| Cursor | PASS |
| Required repos | PASS |
| Dotfiles · wrappers | PASS |
| `ssh lab` · remote health invoked | PASS (Ubuntu production FAIL is Ubuntu authority) |
| Arch not required | PASS |
| Evidence under `shared/evidence/mac-1/` | PASS |

---

## Known backlog (non-blocking)

```text
- ssh arch (waiting for bare-metal)
- Firewall hardening
- brew doctor (macOS 27 Tier 2)
- Ubuntu backup / DEPLOYED_COMMIT (Mission 20 / Ubuntu)
```

---

## Next mission

Per PLATFORM-STATE (unchanged by this MES certification record):

```text
OFFLINE-1 → Arch Installation → Arch Bootstrap → MAC-2 Implementation
```

MAC-2 remains **DEFERRED · DESIGN FROZEN**. This certification does **not** authorize MAC-2 implementation.

---

*SmoothOperator™ · Mac Engineering Station · CERT-MAC-01*
