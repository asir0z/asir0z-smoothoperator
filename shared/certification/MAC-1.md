# MAC-1 Certification Gate

```text
MISSION:     MAC-1 — Operator Console Bootstrap
PLATFORM:   SmoothOperator™ · Mac
STATUS:     CERTIFIED ✅
Certification: PASS
Blocking Issues: None
EXECUTION:  OPERATOR (macOS)
DATE:       2026-07-23
CERTIFIED:  2026-07-24
AMENDMENT:  Terminal · shell · operator scripts — Approved
REVIEWER:   Certification Authority
```

Mission: [`../missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md`](../missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md)  
Amendment: [`../missions/MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md`](../missions/MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md)  
Package: [`../../mac/mac-1-operator-console/`](../../mac/mac-1-operator-console/)  
Evidence: [`../evidence/mac-1/`](../evidence/mac-1/)

---

## Authorization

| Gate | Status |
|------|--------|
| Architecture direction accepted | ✅ |
| Scope amendment approved | ✅ |
| Mission scoped (operator only) | ✅ |
| No production mutation | ✅ required |
| Spec + bootstrap scripts in repo | ✅ |
| Operator evidence on Mac | ✅ |
| Certification decision | ✅ **APPROVED** |

---

## Decision

```text
Status:             CERTIFIED
Certification:      PASS
Blocking Issues:    None
RESULT:             APPROVED
LIFECYCLE:          CERTIFIED
DATE:               2026-07-24
EVIDENCE:           mac-1-evidence-20260724.md
COMMIT:             4ea7e3d · origin/master
COLLECTOR:          verification-20260724-023724.txt
VERIFY:             PASS=56 FAIL=0 WARN=4 SKIP=2
```

### Known Backlog (non-blocking)

```text
- ssh arch (waiting for bare-metal)
- Firewall hardening (currently Off)
- brew doctor (macOS 27 Tier 2)
- Ubuntu backup mission (/root/backups/n8n · DEPLOYED_COMMIT.txt — Mission 20 / Ubuntu authority)
```

---

## PASS criteria (amended)

- [x] zsh default shell · Terminal.app recovery usable
- [x] Homebrew healthy · required CLI toolchain verified
- [x] GNU tools policy respected (no silent system binary override)
- [x] SSH keys/config permissions · `ssh -T git@github.com`
- [x] Git identity · `gh auth` · clone/fetch (push deferred OK)
- [x] Cursor operational
- [x] `~/Projects/` required repos present
- [x] Dotfiles installed from `shared/operator` (secret-free)
- [x] Operator wrappers available (`lab-health`, `repos-status`, …)
- [x] `ssh lab` reachability documented; remote health invoked
- [x] Local `mac-verify` + shellcheck evidence
- [x] Arch not required for daily ops
- [x] No infrastructure redesign performed (ops-script sync only to restore Ubuntu authority path)
- [x] Evidence under `shared/evidence/mac-1/`

---

## Post-PASS expectations

* Mac is **primary operator console**
* Windows becomes **fallback**
* **Next active mission:** OFFLINE-1 (Offline NTFS Shrink) — not MAC-2
* MAC-2 deferred until **after Arch install + Arch bootstrap**
* Arch bare-metal remains independently gated by OFFLINE-1 PASS → `arch-install-spec.md`

---

*SmoothOperator™ · MAC-1 Certification*
