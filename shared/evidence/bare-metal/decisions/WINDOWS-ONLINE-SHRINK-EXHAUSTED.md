# DECISION RECORD — Windows Online Shrink Exhausted

```text
Status: Accepted
Type: Engineering Decision Record
Scope: Bare-Metal Preparation
Date: 2026-07-24
```

---

## Purpose

Document the evidence collected during Windows-based partition shrinking attempts and formally conclude whether additional online optimization is justified.

---

## Objective

Target shrink:

- Desired: **350 GB (358400 MB)**
- Minimum acceptable: **300 GB (307200 MB)**

Windows repeatedly allowed only approximately **84 GB** of shrink space.

---

## Evidence Summary

### File System Health

Result:

- NTFS: Clean
- Dirty Bit: Not set
- CHKDSK: No errors
- Bad sectors: 0

Evidence:

```text
fsutil dirty query C:
Volume - C: is NOT Dirty
```

```text
Windows has scanned the file system and found no problems.
No further action is required.
```

---

### BitLocker

Result:

```text
Protection Status: Protection Off
Conversion Status: Fully Decrypted
Encryption Method: None
```

BitLocker is not restricting partition movement.

---

### Windows Optimizations Performed

Completed:

- Fast Startup disabled
- Hibernation disabled (`powercfg /h off`)
- Pagefile disabled
- System Protection disabled
- Restore points removed
- Multiple reboots
- `defrag /X`
- `defrag /D /U /V`

All completed successfully.

Related evidence: [shrink-evidence.txt](../shrink-evidence.txt)

---

### Defragmentation Result

Final report:

```text
Fragmentation:
    Total fragmented space = 0%

Largest free space size = 65.38 GB

Unmovable files and folders = 12

MFT fragments = 0
```

Observations:

- Fragmentation reduced from 22% to 0%.
- Free-space consolidation completed.
- Largest contiguous free extent remained unchanged.
- Windows Disk Management still reports only ~84 GB shrinkable space.

---

## Conclusion

The limiting factor is no longer fragmentation.

The remaining limitation is consistent with Windows online partition movement constraints caused by unmovable NTFS structures.

Additional online optimization is unlikely to produce a meaningful increase in shrinkable space.

Continuing to tweak Windows settings is expected to have diminishing returns.

---

## Decision

**Windows online shrinking is considered exhausted.**

Future partition resizing should be performed **offline**.

---

## Approved Next Step

Mission specification: [`shared/missions/OFFLINE-1-NTFS-SHRINK.md`](../../missions/OFFLINE-1-NTFS-SHRINK.md)

**Primary tool:** Arch install ISO live environment — `ntfsresize` + `parted` (same USB as installation).

**Alternative:** GParted Live — only if Arch live tools fail or operator requires GUI rescue.

---

## Current Roadmap

```text
Windows verification (complete)
        │
        ▼
Offline NTFS shrink
        │
        ▼
Mission OFFLINE-1 (Arch ISO · ntfsresize + parted)
        │
        ▼
Arch installation (arch-install-spec.md)
        │
        ▼
Bootstrap
        │
        ▼
Mac becomes primary operator console
```

---

## Notes

This decision does **not** indicate Windows failure.

It documents that the Windows online partitioning tool has reached its practical limit despite a healthy filesystem and exhaustive optimization attempts.

The move to offline partitioning is an engineering decision based on collected evidence rather than assumption.

---

*SmoothOperator™ · Bare-Metal Prep · Engineering Decision Record*
