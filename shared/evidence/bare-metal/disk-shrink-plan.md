# Disk Shrink Plan — Bare-Metal Arch Dual-Boot

> **Date:** 2026-07-24  
> **Host:** MLD M700 NVMe · ASUS PRIME A620M-K · Windows 11 Pro  
> **Prerequisites:** [Phase A PASS](bios-uefi-checklist.md) · [hardware-audit.md](hardware-audit.md)  
> **Status:** Windows online shrink **exhausted** (2026-07-24) — see [decisions/WINDOWS-ONLINE-SHRINK-EXHAUSTED.md](decisions/WINDOWS-ONLINE-SHRINK-EXHAUSTED.md)  
> **Next:** [`OFFLINE-1-NTFS-SHRINK.md`](../../missions/OFFLINE-1-NTFS-SHRINK.md) (Arch ISO live) → [arch-install-spec.md](arch-install-spec.md)

**Rule:** This is the **first irreversible-ish step** on bare metal. Execute only after pre-shrink checklist PASS. Record evidence before and after.

---

## Operator-approved decisions (2026-07-24)

| Decision | Status |
|----------|--------|
| Reuse existing EFI — no new ESP | ✅ Approved |
| BitLocker off → shrink proceeds | ✅ Approved |
| Secure Boot off on install day (Yol 1) | ✅ Approved |
| No separate swap partition (swapfile + zram) | ✅ Approved |
| Separate `/home` partition | ✅ Approved — enables reinstall without touching projects |
| Recovery partition untouched | ✅ Approved |
| Leave unallocated **unformatted** in Windows | ✅ Approved |
| `/` size 150 GB | ✅ Approved |

---

## Executive Summary

| Item | Decision |
|------|----------|
| Shrink target disk | **Disk 0** — MLD M700 NVMe (~931 GB) |
| BitLocker | **Off** — shrink safe ✅ |
| UEFI | **Confirmed** — reuse existing EFI ✅ |
| New EFI partition | **No** — shared 100 MB ESP (part 1) |
| Windows recovery (part 4) | **Do not touch** |
| Arch `/` | **150 GB** · ext4 |
| Arch `/home` | **Remaining unallocated** · ext4 |
| Swap partition | **None** — swapfile + zram post-install |
| Filesystem | **ext4** (root + home) |
| Target unallocated | **350 GB** (stretch) · **300 GB minimum** |

---

## Phase A gate (complete)

```text
Secure Boot:     True  → disable in BIOS on install day (Yol 1)
BitLocker:       Protection Off · Fully Decrypted ✅
UEFI:            bootmgfw.efi ✅
Fast Startup:    Enabled → MUST disable before shrink
```

Evidence: [phase-a-output.txt](phase-a-output.txt)

---

## Current layout (before shrink)

Collected: 2026-07-24

| Part | Type | Size | FS | Mount | Action |
|------|------|------|-----|-------|--------|
| 1 | EFI System | 100 MB | FAT32 | — | **Keep — shared** |
| 2 | Microsoft reserved | 16 MB | — | — | Keep |
| 3 | Basic (Windows) | **930.56 GB** | NTFS | **C:** | **Shrink** |
| 4 | Recovery | 860 MB | NTFS | WinRE | **Do not modify** |
| — | Unallocated | ~4 MB | — | — | — |

| Metric | Value |
|--------|--------|
| Disk total | 931.51 GB |
| C: free space | **~355.7 GB** |
| Max realistic shrink | **~330–350 GB** (after Fast Startup off) |

**Post-shrink Windows size (target):** ~**580 GB** (930.56 − 350)

Windows retains ample space for Unreal, games, and daily use until Phase 2 reset.

---

## Target layout (after shrink + Arch install)

```text
┌─────────────────────────────────────────────────────────────┐
│  Disk 0 — MLD M700 NVMe — GPT                               │
├──────────┬──────┬─────────────┬────────────┬───────────────┤
│ EFI      │ MSR  │ Windows C:  │ Arch /     │ Arch /home    │ Recovery │
│ (exist)  │      │ (shrunk)    │ 150 GB     │ (remainder)   │ (exist)  │
│ 100 MB   │ 16MB │ ~580 GB     │ ext4       │ ext4          │ 860 MB   │
│ FAT32    │      │ NTFS        │            │               │          │
└──────────┴──────┴─────────────┴────────────┴───────────────┴──────────┘
                              ↑
                    unallocated created here first
                    (between C: and Recovery)
```

### Partition sizing (install day)

| Partition | Size | FS | Mount | Notes |
|-----------|------|-----|-------|-------|
| Existing EFI (part 1) | 100 MB | FAT32 | `/boot/efi` | Add `systemd-boot` or GRUB entry only |
| `/` | **150 GB** | ext4 | `/` | OS · packages · `/var/lib/docker` optional |
| `/home` | **All remaining unallocated** | ext4 | `/home` | Projects · cache · Cursor · builds |
| Swap | — | swapfile | — | 16–32 GB file on `/` post-install |
| zram | — | — | — | Enable via systemd/zram-generator post-install |

**Example if 350 GB unallocated:**

| | Size |
|---|------|
| `/` | 150 GB |
| `/home` | ~200 GB |

**Example if 300 GB unallocated (minimum acceptable):**

| | Size |
|---|------|
| `/` | 150 GB |
| `/home` | ~150 GB |

Operator records **actual** unallocated size in [shrink-evidence.txt](shrink-evidence.txt) after shrink.

---

## Why these sizes?

| Need | Covered by |
|------|------------|
| DevOps Lab · Product Intelligence · Cortex · Pulse | `/home/Projects` |
| Docker images/volumes | `/home` or `/var/lib/docker` on `/` |
| AI model cache | `/home` (large) |
| Cursor · dotfiles · build artifacts | `/home` |
| System · NVIDIA · Hyprland · packages | `/` 150 GB headroom |
| Unreal Engine | **Windows** until reset — not Arch |
| Long-term growth | `/home` takes remainder; expand later only if needed |

150 GB root avoids early `/` pressure from Docker + system updates without btrfs complexity.

**`/` holds:** Arch base · Hyprland · NVIDIA · Docker · Cursor · toolchain · Flatpak · cache · logs — long-term headroom without daily monitoring.

### `/home` layout (canonical — operator)

All projects live under `/home` so a future reinstall only formats `/`:

```text
/home/asir0z/
└── Projects/
    ├── asir0z-smoothoperator
    ├── asir0z-devopslab
    ├── asir0z-product-intelligence
    ├── asir0z-web
    └── asir0z-cortex          # when repo restored
```

Matches VM/Windows parity: `~/Projects/` · SmoothOperator bootstrap clones here.

**Reinstall pattern:** format `/` only · mount existing `/home` · re-run bootstrap.

## Pre-shrink checklist (mandatory)

Execute in order. **Do not shrink until all PASS.**

| # | Step | PASS |
|---|------|------|
| 1 | Phase A complete | ✅ |
| 2 | **Disable Fast Startup** — Control Panel → Power Options → Choose what power buttons do → Change settings currently unavailable → uncheck **Turn on fast startup** | ⏸️ |
| 3 | Verify: `reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled` → `0x0` | ⏸️ |
| 4 | Optional but recommended: run **Disk Cleanup** on C: (no hurry) | ⏸️ |
| 5 | **Windows recovery media** or recovery partition confirmed working | ⏸️ |
| 6 | Record **before** evidence (commands below) → `shrink-evidence.txt` | ⏸️ |
| 7 | Close heavy apps (games, Docker Desktop, VMs) | ⏸️ |
| 8 | **Arch install USB** ready but not required for shrink | ✅ |

**Not required (BitLocker off):** suspend BitLocker, recovery key for encryption.

---

## Shrink procedure (operator)

### Method — Windows Disk Management (recommended)

1. `Win + X` → **Disk Management** (`diskmgmt.msc`)
2. Right-click **C:** → **Shrink Volume**
3. Wait for query (may take minutes)
4. **Enter shrink amount:**

   ```text
   Target: 358400 MB  (350 GB)
   Minimum acceptable: 307200 MB (300 GB)
   ```

   Windows reports **maximum available** — use the **largest safe value** ≥ 300 GB. Do not exceed what the dialog allows.

5. Click **Shrink**
6. Verify new **Unallocated** block appears **immediately after C:** and **before** Recovery
7. **Do not** create new volumes in unallocated space — leave for Arch installer
8. **Do not** delete or move Recovery partition

**Windows must NOT after shrink:**

- Create partition in unallocated space
- Format unallocated
- Assign drive letter to unallocated

Leave as raw **Unallocated** — Arch Installer handles partitioning cleanly.

### Alternative — PowerShell (admin, after verifying math)

```powershell
# Query maximum shrink (read-only)
$max = (Get-PartitionSupportedSize -DriveLetter C)
$max.SsizeMaxBytes / 1GB

# Shrink ONLY after confirming target — example 350 GB:
# Resize-Partition -DriveLetter C -Size ((Get-Partition -DriveLetter C).Size - (350GB))
```

Prefer **Disk Management** for first bare-metal shrink — visual confirmation of Recovery boundary.

---

## Post-shrink verification (Windows admin)

Run immediately after shrink; append to `shrink-evidence.txt`:

```powershell
Get-Disk 0 | Select Number, Size, PartitionStyle
Get-Partition -DiskNumber 0 | Select PartitionNumber, Type, DriveLetter, @{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}}
Get-Volume C | Select SizeRemaining, @{N='FreeGB';E={[math]::Round($_.SizeRemaining/1GB,2)}}
```

**PASS criteria:**

| Check | Expected |
|-------|----------|
| C: still boots Windows | Normal reboot test |
| Unallocated ≥ **300 GB** | Between C: and Recovery |
| Recovery partition intact | Part 4 ~860 MB unchanged |
| EFI unchanged | Part 1 ~100 MB |
| C: free space reasonable | Operator sanity check |

### Post-shrink gate (operator — three checks)

Before Windows-side work is considered **complete**:

```text
1. Windows boots normally          → PASS / FAIL
2. Explorer behaves normally       → PASS / FAIL
3. Disk Management shows ~350 GB
   Unallocated (≥300 GB min)       → PASS / FAIL
```

Record in [shrink-evidence.txt](shrink-evidence.txt). All three PASS → ready for install spec execution.

Optional live ISO check before install:

```bash
lsblk -f /dev/nvme0n1
sudo fdisk -l /dev/nvme0n1
```

---

## What NOT to do

| Action | Risk |
|--------|------|
| Delete Recovery partition | Lose Windows recovery |
| Create new EFI partition | Wastes space · complicates boot |
| Shrink with Fast Startup on | Reduced shrink max · NTFS hibernation |
| Shrink with BitLocker on | N/A — currently off ✅ |
| Move partitions with third-party tools | Unnecessary · high risk |
| Format unallocated from Windows | Leave raw for Arch installer |
| Shrink below Windows comfort | Leave ~580 GB target on C: |

---

## Bootloader plan (install day — not shrink day)

| Item | Plan |
|------|------|
| ESP | Reuse part 1 (100 MB) |
| Windows Boot Manager | Preserved |
| Linux loader | `systemd-boot` or GRUB — decide in arch-install-spec |
| Secure Boot | **Disabled in BIOS** before install (Yol 1) |

Monitor ESP free space after adding Linux entry — 100 MB is tight but usually sufficient for two entries.

---

## Swap strategy (post-install — no partition)

```text
No dedicated swap partition.

Post-install:
  1. swapfile on / (e.g. 16–32 GB) — swapon + fstab
  2. zram-generator (optional, recommended for 32 GB RAM desktop)
```

32 GB RAM → heavy swap rarely needed; swapfile sufficient for hibernation-less desktop.

---

## Rollback

If shrink causes issues **before Arch install**:

- Unallocated can remain unused — Windows unaffected if C: boots
- Extending C: back: Disk Management → extend into unallocated (if adjacent)

If Windows fails to boot after shrink (rare):

- Windows Recovery / install USB
- `bootrec` / Startup Repair from WinRE

Record any incident in `shrink-evidence.txt`.

---

## Evidence files

| File | When |
|------|------|
| [shrink-evidence.txt](shrink-evidence.txt) | Before + after shrink (operator) |
| [phase-a-output.txt](phase-a-output.txt) | ✅ Complete |
| [bios-uefi-checklist.md](bios-uefi-checklist.md) | Phase A ✅ |

---

## Execution sign-off

| Field | Value |
|-------|--------|
| Plan approved | 2026-07-24 |
| Fast Startup disabled | ⏸️ |
| Shrink executed | ⏸️ |
| Unallocated achieved (GB) | ⏸️ |
| Windows boot verified post-shrink | ⏸️ |
| Ready for arch-install-spec | ⏸️ after shrink PASS |

When complete, update status to:

```text
PASS — Disk shrink complete; unallocated space ready for Arch install.
```

---

## Pipeline position

```text
✅ Hardware Audit
✅ BIOS/UEFI Checklist (Phase A)
✅ Disk Shrink Plan (operator-approved)
⏸️ Fast Startup OFF → Shrink → post-shrink 3-check PASS
⏳ Arch Install Specification  ← draft before install (evidence-first)
⏸️ Bare-metal installation
⏸️ SmoothOperator bootstrap → validation → (later) Windows reset
```

**Evidence-first rule:** All four prep documents complete **before** Arch Installer starts — no ad-hoc decisions during install.

---

*SmoothOperator™ · evidence-first · first physical mutation on bare metal*
