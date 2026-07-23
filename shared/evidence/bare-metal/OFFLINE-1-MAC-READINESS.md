# OFFLINE-1 — Mac Operator Readiness (activation)

```text
Date:       2026-07-24
Activated:  after MAC-1 CERTIFIED
Role:       Mac documents · tracks · does not execute shrink
Execution:  Windows host + Arch ISO live environment
```

## Gate status (from existing evidence)

| # | Precondition | Mac-visible status |
|---|--------------|-------------------|
| 1–3 | NTFS clean · CHKDSK · BitLocker OFF | PASS — EDR `WINDOWS-ONLINE-SHRINK-EXHAUSTED.md` |
| 4–6 | Boot · Fast Startup · Hibernate OFF | PASS — prior Windows evidence |
| 7–8 | Backup posture · AC power | Operator confirm at execution time |
| 9 | Recovery layout recorded | Fill `offline-shrink-evidence.txt` BEFORE live boot |
| 10 | Install USB `ARCH_202607` | Operator — UEFI boot test if possible |

## Do not reopen

Windows online shrink is **exhausted**. Next resize is offline only (this mission).

## Operator sequence

1. On Windows: capture BEFORE block into `shared/evidence/bare-metal/offline-shrink-evidence.txt`
2. Boot Arch ISO live (`ARCH_202607`)
3. Execute OFFLINE-1 per `shared/missions/OFFLINE-1-NTFS-SHRINK.md`
4. Reboot Windows → validate gates → stamp PASS
5. Proceed to `shared/evidence/bare-metal/arch-install-spec.md` (same ISO session OK)

## Mac responsibilities during OFFLINE-1

* Keep mission + evidence in Git
* Do **not** invent alternate partition tooling
* After PASS: update PLATFORM-STATE + certification when evidence lands

---

*SmoothOperator™ · OFFLINE-1 activation · Mac operator*
