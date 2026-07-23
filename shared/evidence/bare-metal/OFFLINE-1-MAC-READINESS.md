# OFFLINE-1 — Mac Operator Readiness (activation)

```text
Date:       2026-07-24
Activated:  after MAC-1 CERTIFIED
Role:       Mac documents · tracks · does not execute shrink
Execution:  Windows host + Arch ISO live environment
```

## Phase model (do not merge with Arch install)

```text
A BEFORE → B offline shrink → C live validate → D Windows gates → OFFLINE-1 CERTIFIED
                                                                    ↓
                                              arch-install-spec.md (new session)
```

## Phase A status

| Item | Status |
|------|--------|
| `offline-shrink-evidence.txt` Phase A filled | ✅ seeded from `shrink-evidence.txt` (same-day layout) |
| Fresh Windows re-capture | Optional — `collect-offline-1-before.ps1` immediately before ISO boot |
| Operator confirm checkboxes | ⏸️ on Windows at execution |

## Next physical steps (Windows / ISO — not Mac)

1. On Windows: tick Phase A operator confirms · optional fresh `collect-offline-1-before.ps1`
2. Boot `ARCH_202607` UEFI · Phase B per mission §5
3. Phase C live validate · reboot to Windows
4. Phase D gates · stamp PASS · certify OFFLINE-1
5. **Only then** schedule Arch install session

## Do not reopen

Windows online shrink is **exhausted**. Next resize is offline only.

---

*SmoothOperator™ · OFFLINE-1 activation · Mac operator*
