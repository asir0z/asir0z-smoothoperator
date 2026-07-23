# MISSION — OFFLINE-1 NTFS SHRINK & PARTITION PREPARATION

```text
Status: AUTHORIZED
Scope: Bare-Metal Preparation
Priority: Critical (blocks Arch installation)
Type: Evidence-Based Operation Specification
Prerequisite: Windows online shrink exhausted (EDR)
```

**Authorizing decision:** [`shared/evidence/bare-metal/decisions/WINDOWS-ONLINE-SHRINK-EXHAUSTED.md`](../evidence/bare-metal/decisions/WINDOWS-ONLINE-SHRINK-EXHAUSTED.md)  
**Next after PASS:** [`shared/evidence/bare-metal/arch-install-spec.md`](../evidence/bare-metal/arch-install-spec.md)  
**Naming:** `OFFLINE-1` is a SmoothOperator bare-metal mission — **not** DevOps Lab `MISSION-XX`.

---

## 1. Purpose

### Why Windows online shrink was abandoned

Windows Disk Management allowed only **~84 GB** shrink despite:

- Clean NTFS · CHKDSK PASS · BitLocker OFF
- Fast Startup / hibernation / pagefile / System Protection disabled
- Defrag 22% → 0% · 12 unmovable NTFS structures remain

Target was **350 GB** unallocated (minimum **300 GB**). Online optimization is exhausted.

### What this mission authorizes

Perform **offline NTFS shrink** and create **raw unallocated space** between Windows (`C:`) and the Windows Recovery partition — **without** formatting that space.

### What this mission does **not** do

- Does not install Arch (that is `arch-install-spec.md` — same ISO session, separate phase)
- Does not modify Ubuntu / Contabo infrastructure
- Does not require a second USB stick when using the Arch install medium

### Phase outcome

When OFFLINE-1 **PASS**:

```text
Bare-Metal Preparation  →  COMPLETE
Arch Installation       →  AUTHORIZED (arch-install-spec.md)
```

---

## 2. Preconditions

All must be **PASS** before booting the live environment.

| # | Check | Evidence |
|---|-------|----------|
| 1 | NTFS clean · not dirty | `fsutil dirty query C:` → NOT Dirty |
| 2 | CHKDSK PASS | No errors |
| 3 | BitLocker OFF · fully decrypted | Phase A / shrink evidence |
| 4 | Windows boots normally | Operator confirm |
| 5 | Fast Startup OFF | `HiberbootEnabled = 0x0` |
| 6 | Hibernation OFF | `powercfg /h off` |
| 7 | Backup / recovery posture verified | Operator confirm — no unique data at risk |
| 8 | AC power connected | Operator confirm |
| 9 | Recovery layout recorded | BEFORE evidence below |
| 10 | Install USB ready | `ARCH_202607` · UEFI boot tested if possible |

Record Windows-side baseline **before** live boot → [`offline-shrink-evidence.txt`](../evidence/bare-metal/offline-shrink-evidence.txt)

---

## 3. Tool Selection

### Decision matrix

| Tool | Status | When |
|------|--------|------|
| **Arch ISO live** (`ntfsresize` + `parted`) | **Primary** | Default — same USB as installation |
| GParted Live | Alternative | Only if Arch live tools fail or operator prefers GUI rescue |

### Why Arch ISO is primary

- Arch installation is already planned on `ARCH_202607`
- **One USB · one live session:** shrink → validate → reboot Windows → later boot same ISO for install
- Aligns with [`arch-install-spec.md`](../evidence/bare-metal/arch-install-spec.md) and existing bare-metal pipeline
- Avoids maintaining a separate GParted USB

### When GParted Live is acceptable

- `ntfsresize` refuses shrink after `--info` review
- `parted` resizepart fails and operator needs visual partition map
- Emergency rollback inspection

GParted is **not** the default path.

---

## 4. Disk constants (locked)

From [hardware-audit.md](../evidence/bare-metal/hardware-audit.md) and [disk-shrink-plan.md](../evidence/bare-metal/disk-shrink-plan.md):

| Part | Role | Action |
|------|------|--------|
| `nvme0n1p1` | EFI ~100 MB | **Do not modify** |
| `nvme0n1p2` | MSR ~16 MB | **Do not modify** |
| `nvme0n1p3` | Windows C: ~930 GB NTFS | **Shrink only** |
| *(new)* | Unallocated | **Create** — leave raw |
| `nvme0n1p4` | Windows Recovery | **Do not modify** |

### Size targets

| Metric | Value |
|--------|-------|
| Unallocated target | **350 GB** (358400 MB) |
| Unallocated minimum | **300 GB** (307200 MB) |
| Windows C: after shrink | **~580 GB** (930.56 − 350) |
| Arch `/` (install day) | 150 GB ext4 — from unallocated |
| Arch `/home` (install day) | Remainder ext4 — from unallocated |

**Do not** create ext4 partitions during OFFLINE-1 — unallocated only.

---

## 5. Offline Procedure — Arch ISO (primary)

### 5.1 Boot

1. BIOS: Secure Boot **off** (install-day policy — required for live session)
2. Boot **UEFI** from `ARCH_202607`
3. Select **Arch Linux install medium (x86_64, UEFI)** → live shell

### 5.2 BEFORE live evidence

```bash
lsblk -f /dev/nvme0n1
fdisk -l /dev/nvme0n1
```

Save output to evidence file (photo or copy).

Verify partition numbers match preconditions (`p3` = NTFS Windows, `p4` = Recovery).

### 5.3 Install tools (if missing on live ISO)

```bash
pacman -Sy --noconfirm ntfs-3g parted
```

### 5.4 Read-only NTFS analysis

```bash
ntfsresize --info --no-action /dev/nvme0n1p3
```

Record:

- Current NTFS size
- Minimum / suggested shrink size
- Confirm ≥ **300 GB** can be freed **before** destructive step

If `--info` shows insufficient shrink potential → **STOP** · do not proceed · capture evidence · consider GParted alternative.

### 5.5 Calculate target NTFS size

```text
new_ntfs_size ≈ current_C_size − target_unallocated
              ≈ 930 GB − 350 GB ≈ 580 GB
```

Use **MiB** values from `ntfsresize --info` — do not guess if numbers disagree. Prefer **slightly conservative** (smaller NTFS) over overshooting.

Example (verify on live system):

```bash
# Illustrative — replace NEW_SIZE_MiB after --info review
export NEW_SIZE_MiB=593920   # ~580 GiB — adjust per --info
ntfsresize --size ${NEW_SIZE_MiB}M /dev/nvme0n1p3
```

**Rules:**

- Run `ntfsresize` **before** `parted resizepart`
- Do **not** mount `/dev/nvme0n1p3` read-write during resize
- Do **not** touch `p1`, `p2`, `p4`

### 5.6 Shrink GPT partition entry

After filesystem shrink succeeds:

```bash
parted /dev/nvme0n1
print
# Note exact end of partition 3 before change
resizepart 3 NEW_END
quit
```

`NEW_END` must match the shrunk NTFS size — use `parted` unit `MiB` or `GB` consistently.

Alternative one-liner (after verifying end sector):

```bash
parted ---pretend-input-tty /dev/nvme0n1 <<EOF
print
resizepart 3 END-XXXGiB
quit
EOF
```

### 5.7 Post-resize verification (live)

```bash
lsblk -f /dev/nvme0n1
parted /dev/nvme0n1 print
```

Expected layout:

```text
p1 EFI → p2 MSR → p3 NTFS (smaller) → [unallocated ≥300 GB] → p4 Recovery
```

### 5.8 Exit live environment

```bash
reboot
```

Remove USB if prompted · boot **Windows** first — do **not** start Arch install until Windows validation gates PASS.

---

## 6. Alternative Procedure — GParted Live

Use only when Section 5 fails or operator explicitly chooses GUI path.

1. Boot GParted Live UEFI
2. Select `/dev/nvme0n1`
3. Shrink **`ntfs` partition** (Windows C:) from the **right** (leave Recovery untouched)
4. Target: **350 GB unallocated** minimum **300 GB**
5. Apply · wait for completion
6. Screenshot before/after
7. Reboot to Windows

Same validation gates apply (Section 7).

---

## 7. Validation Gates

Evaluate **after reboot to Windows** — not in live session alone.

| Gate | PASS criteria | Result |
|------|---------------|--------|
| **Boot** | Windows starts normally | ⏸️ |
| **NTFS** | `fsutil dirty query C:` → NOT Dirty · Explorer OK | ⏸️ |
| **Partition Layout** | `C: → Unallocated (300–350 GB) → Recovery` | ⏸️ |
| **Recovery** | Recovery partition present · size plausible · position unchanged relative to disk end | ⏸️ |
| **Unallocated Size** | ≥ **300 GB** (stretch **350 GB**) | ⏸️ |

**Recovery gate:** exact MB match not required — presence + no meaningful size drift + correct ordering.

Collect Windows evidence:

```powershell
Get-Disk 0 | Format-List
Get-Partition -DiskNumber 0 | Format-Table -AutoSize
Get-Volume C | Format-List
```

Plus `diskmgmt.msc` screenshot.

---

## 8. Evidence

Capture to [`offline-shrink-evidence.txt`](../evidence/bare-metal/offline-shrink-evidence.txt) and optional screenshots in `shared/evidence/bare-metal/offline-1/`.

| Artifact | When |
|----------|------|
| Windows BEFORE (pre-live boot) | `Get-Disk` · `Get-Partition` · `Get-Volume C` |
| Live BEFORE | `lsblk -f` · `fdisk -l` · `ntfsresize --info` |
| Live AFTER | `lsblk -f` · `parted print` |
| Windows AFTER | PowerShell trio + Disk Management screenshot |
| Gate table | PASS/FAIL per gate |

---

## 9. Rollback

| Symptom | Action |
|---------|--------|
| Windows boots but unallocated too small | Document actual size · if ≥300 GB → may PASS minimum · if <300 GB → re-attempt offline shrink or reassess layout |
| Windows will not boot | Boot Windows Recovery / install USB · Startup Repair · `bootrec` if needed |
| NTFS dirty after reboot | `chkdsk C: /F` from Recovery · re-evaluate · do **not** install Arch until clean |
| Recovery missing or wrong | **STOP** · do not install Arch · restore from backup / professional recovery |
| Live resize failed mid-operation | **Do not panic-write** · reboot · assess with `lsblk` · GParted inspect · Windows Recovery if needed |

Unallocated space left unused does **not** harm Windows if C: boots.

---

## 10. Exit Criteria

Mission closes **only** when all five gates **PASS**.

```text
OFFLINE-1 = PASS
        ↓
Bare-Metal Preparation = COMPLETE
        ↓
arch-install-spec.md (Phase 1 — same ARCH_202607 USB, new boot session)
```

Record in evidence:

```text
=== RESULT ===
OFFLINE-1: PASS
Bare-Metal Prep: COMPLETE
Next: arch-install-spec.md
```

---

## 11. Post-mission roadmap

```text
Arch Installation     (arch-install-spec.md)
        ↓
Bootstrap + validation
        ↓
Mac Operator Console  (MAC-1 / MAC-2)
        ↓
Normal Development
```

Windows remains **emergency fallback** until Arch validation completes.

---

## 12. Do-not list

| Forbidden | Reason |
|-----------|--------|
| Format unallocated during OFFLINE-1 | Arch installer creates `/` and `/home` |
| Create new EFI partition | Reuse `p1` |
| Delete / move Recovery | Windows recovery lost |
| Install Arch before Windows gates PASS | Evidence-first |
| Continue tweaking Windows online settings | EDR — exhausted |
| Second USB for GParted when Arch ISO suffices | Operational simplicity |

---

*SmoothOperator™ · OFFLINE-1 · Bare-Metal Preparation · Evidence-Based Operation*
