# MAC-1 Certification Gate

```text
MISSION:     MAC-1 — Operator Console Bootstrap
PLATFORM:   SmoothOperator™ · Mac
STATUS:     AUTHORIZED ✅ · AWAITING EVIDENCE
EXECUTION:  OPERATOR (macOS)
DATE:       2026-07-23
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
| Spec + bootstrap scripts in repo | ✅ / in progress |
| Operator evidence on Mac | ⏳ |
| Certification decision | ⏳ |

---

## Decision (pending evidence)

```text
RESULT:     — (APPROVED | CHANGES REQUIRED | REJECTED)
LIFECYCLE:  —
DATE:       —
COMMIT:     —
```

---

## PASS criteria (amended)

- [ ] zsh default shell · Terminal.app recovery usable
- [ ] Homebrew healthy · required CLI toolchain verified
- [ ] GNU tools policy respected (no silent system binary override)
- [ ] SSH keys/config permissions · `ssh -T git@github.com`
- [ ] Git identity · `gh auth` · clone/fetch/push
- [ ] Cursor operational
- [ ] `~/Projects/` required repos present
- [ ] Dotfiles installed from `shared/operator` (secret-free)
- [ ] Operator wrappers available (`lab-health`, `repos-status`, …)
- [ ] `ssh lab` reachability documented; remote health invoked **or** deferred with reason
- [ ] Local `mac-verify` + shellcheck evidence
- [ ] Arch not required for daily ops
- [ ] No infrastructure changes performed
- [ ] Evidence under `shared/evidence/mac-1/`

---

## Post-PASS expectations

* Mac is primary operator console
* Windows becomes fallback
* MAC-2 may enhance terminal/shell/Tailscale/runtimes
* Arch bare-metal remains independently gated

---

*SmoothOperator™ · MAC-1 Certification*
