# BIOS/UEFI Checklist — Bare-Metal Arch Install Prep

> **Date:** 2026-07-23 · updated 2026-07-24  
> **Host:** ASUS PRIME A620M-K · AMD Ryzen 5 7500F · NVIDIA RTX 4060 Ti  
> **Purpose:** Verify firmware settings **before** disk shrink and Arch installation  
> **Prerequisite:** [hardware-audit.md](hardware-audit.md)  
> **Next step:** Disk shrink plan (after this checklist is PASS)

**Rule:** Do not shrink `C:` until Secure Boot and BitLocker states are documented and decisions are recorded below.

---

## Executive Summary

| Area | Pre-audit state | Operator verify |
|------|-----------------|-----------------|
| Boot mode | UEFI (Windows confirmed) | ⏸️ |
| BIOS version | 0401 (2023-05-16) | ⏸️ |
| Secure Boot | Registry hint `1` (non-canonical) | ⏸️ admin `Confirm-SecureBootUEFI` |
| BitLocker | Unknown — **critical gate** | ⏸️ admin `manage-bde -status C:` |
| SATA/NVMe mode | NVMe (implicit AHCI/NVMe) | ⏸️ |
| fTPM | AMD PSP present — state unknown | ⏸️ |
| EXPO/XMP | RAM at 4800 MT/s (6000 kit) | ⏸️ |
| SVM | Enabled (Windows reported) | ⏸️ |

**Overall status:**

```text
PENDING — Phase A canonical admin verification required (single blocking gate)
```

---

## Engineering decisions (pre-approved — operator 2026-07-24)

These apply **after** Phase A admin output confirms state. No disk or BIOS mutations until then.

### Secure Boot strategy — RTX 4060 Ti

| Path | Approach | First bare-metal install |
|------|----------|--------------------------|
| **Yol 1 (recommended)** | Secure Boot **off** · NVIDIA proprietary/open DKMS | **Preferred** — least surprise |
| Yol 2 | Secure Boot on · MOK enrollment · signed DKMS | Defer until system stable |

**Recommendation:** Yol 1 for first install. Re-evaluate Secure Boot after bare-metal validation.

### BitLocker

If `Protection Status: Protection On`:

1. Confirm recovery key is documented offline.
2. **Suspend** (not full disable) before shrink — re-enable after partitioning.
3. Do not shrink until suspend is confirmed.

### Fast Startup

**Disable before install/shrink** (currently `HiberbootEnabled = 0x1` — Enabled per non-admin registry read).

Reason: NTFS may remain hibernated · unsafe Linux access · unnecessary dual-boot risk.

### Registry vs canonical evidence

| Source | Secure Boot hint | Evidence grade |
|--------|------------------|----------------|
| `UEFISecureBootEnabled = 1` (registry) | Likely on | **Indicative only** |
| `Confirm-SecureBootUEFI` (admin) | — | **Canonical** |

---

## Phase A — Windows checks (before BIOS)

Run in **elevated** PowerShell **before** entering BIOS or shrinking disk.

**Canonical command block** (all four required for Phase A PASS):

```powershell
Confirm-SecureBootUEFI
manage-bde -status C:
bcdedit | Select-String bootmgfw
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled
```

### A0. Non-admin pre-read (Cursor session 2026-07-23 — not PASS)

| Check | Result | Grade |
|-------|--------|-------|
| Registry `UEFISecureBootEnabled` | `1` | Indicative — Secure Boot likely on |
| `manage-bde -status C:` | Access denied | **Blocked — admin required** |
| `bcdedit` | Access denied | **Blocked — admin required** |
| `HiberbootEnabled` | `0x1` (Enabled) | Confirmed — disable before shrink |
| `BiosFirmwareType` | Uefi | Confirmed |
| `C:\Windows\Boot\EFI` | Exists | UEFI layout present |

### A1. Secure Boot

```powershell
Confirm-SecureBootUEFI
```

| Result | Record here |
|--------|-------------|
| True / False / Unsupported | ⏸️ |

**Arch impact:**

| Secure Boot | NVIDIA DKMS (`nvidia-open-dkms`) | Recommendation |
|-------------|-----------------------------------|----------------|
| **Off** | Works without MOK enrollment | **Yol 1 — preferred first install** |
| **On** | Requires MOK enroll or signed modules | Yol 2 — defer |

**Decision for this install** *(pre-approved: Yol 1 pending A1 confirm)*:

- [ ] Keep Secure Boot **ON** — Yol 2 (MOK)
- [x] Disable Secure Boot **for install** — **Yol 1 (recommended)** — re-enable later if desired
- [ ] Undecided — blocked until A1 complete

### A2. BitLocker (C:)

```powershell
manage-bde -status C:
Get-BitLockerVolume -MountPoint C:
```

| Item | Record here |
|------|-------------|
| Protection status | ⏸️ |
| Encryption % | ⏸️ |
| Method | ⏸️ |

**If `Protection Status: Protection On`:** suspend before shrink — **mandatory**. Prefer **suspend** over full disable; re-enable after partitioning.

Key lines to record from `manage-bde -status C:`:

```text
Conversion Status
Protection Status
Lock Status
Encryption Method
```

```powershell
manage-bde -protectors -get C:
# Suspend (only when ready to shrink — not now unless proceeding):
# manage-bde -protectors -disable C: -RebootCount 1
```

| Action | Status |
|--------|--------|
| Recovery key documented (offline) | ⏸️ |
| BitLocker suspended before shrink | ⏸️ N/A until shrink phase |
| Full disable avoided (suspend preferred) | Policy ✅ |

### A3. Fast Startup (dual-boot hygiene)

```powershell
powercfg /a
# Disable Fast Startup via: Control Panel → Power Options → Choose what power buttons do → Uncheck "Turn on fast startup"
```

| Item | Target | Actual |
|------|--------|--------|
| Fast Startup | **Off** before partition work | ⏸️ |

### A4. UEFI boot path (canonical)

```powershell
bcdedit | Select-String bootmgfw
```

Expected line:

```text
path \EFI\Microsoft\Boot\bootmgfw.efi
```

| Item | Expected | Actual |
|------|----------|--------|
| `bootmgfw.efi` in bcdedit output | Present | ⏸️ |
| BiosFirmwareType (supplementary) | Uefi | ✅ (non-admin) |

### A5. Windows-side checklist summary

| # | Check | PASS / FAIL / N/A | Notes |
|---|-------|---------------------|-------|
| A1 | Secure Boot state recorded | ⏸️ | |
| A2 | BitLocker state recorded | ⏸️ | |
| A3 | Fast Startup off (before shrink) | ⏸️ | |
| A4 | UEFI boot confirmed | ⏸️ | |
| A5 | Recovery key accessible (if BitLocker) | ⏸️ | |

---

## Phase B — BIOS entry (ASUS PRIME A620M-K)

| Item | Value |
|------|--------|
| Enter BIOS | Power on → press **Del** or **F2** repeatedly |
| Advanced Mode | **F7** (if EZ Mode shown) |
| Current BIOS | **0401** (2023-05-16) — verify on screen |
| Optional | Check ASUS support for newer BIOS before install sprint |

**Screenshot or phone photo of Main screen** (BIOS version, memory speed) — recommended for evidence.

---

## Phase C — BIOS/UEFI settings checklist

Mark **Target**, **Actual**, and **PASS/FAIL** after inspection.

### C1. Boot & compatibility

| Setting | BIOS path (ASUS typical) | Target | Actual | PASS |
|---------|--------------------------|--------|--------|------|
| **Boot Mode** | Boot → Boot Mode | **UEFI** | ⏸️ | ⏸️ |
| **CSM / Legacy** | Boot → CSM | **Disabled** | ⏸️ | ⏸️ |
| **Secure Boot** | Boot → Secure Boot → OS Type | Record state; see decision A1 | ⏸️ | ⏸️ |
| **Fast Boot** | Boot → Fast Boot | **Disabled** during install USB boot (optional) | ⏸️ | ⏸️ |
| **Boot Priority (install day)** | Boot → Boot Option #1 | **USB** first (install media only) | ⏸️ | ⏸️ |
| **Boot Priority (normal use)** | Boot → Boot Option #1 | **Windows Boot Manager** or **Arch** per preference | ⏸️ | ⏸️ |

**Notes:**

- AM5 platforms are UEFI-native; CSM should remain off.
- Install USB: SanDisk `ARCH_202607` (~57 GB FAT32) — already prepared per hardware audit.
- After install, restore boot order so daily boot is intentional (not accidental USB).

### C2. Storage

| Setting | BIOS path (ASUS typical) | Target | Actual | PASS |
|---------|--------------------------|--------|--------|------|
| **SATA Mode** | Advanced → SATA Configuration | **AHCI** (if visible; NVMe primary disk may not expose this) | ⏸️ | ⏸️ |
| **NVMe OPROM / VMD** | Advanced → NVMe configuration | Default / no Intel VMD (N/A on AMD) | ⏸️ | ⏸️ |
| **Primary disk** | Boot overview | **MLD M700 NVMe** recognized | ⏸️ | ⏸️ |

**Notes:**

- System disk is **NVMe** (not SATA) — AHCI applies to SATA ports only; confirm no RAID mode enabled.
- Do **not** change storage mode if Windows already boots — unexpected mode change can break boot.

### C3. Security & TPM

| Setting | BIOS path (ASUS typical) | Target | Actual | PASS |
|---------|--------------------------|--------|--------|------|
| **fTPM / TPM** | Advanced → AMD fTPM configuration | **Record state** (Enabled/Disabled) | ⏸️ | ⏸️ |
| **Secure Boot keys** | Boot → Secure Boot → Key Management | Do not clear unless planned | ⏸️ | ⏸️ |
| **BIOS password** | Security | Optional — record if set | ⏸️ | ⏸️ |

**Notes:**

- AMD PSP 11.0 detected in hardware audit — fTPM likely available.
- Changing TPM state can affect Windows BitLocker — correlate with Phase A2.

### C4. CPU & virtualization

| Setting | BIOS path (ASUS typical) | Target | Actual | PASS |
|---------|--------------------------|--------|--------|------|
| **SVM Mode** | Advanced → CPU Configuration → SVM | **Enabled** (keep on — VirtualBox/reference VM) | ⏸️ | ⏸️ |
| **Above 4G Decoding** | Advanced → PCI Subsystem | **Enabled** (recommended for discrete GPU) | ⏸️ | ⏸️ |
| **Re-Size BAR** | Advanced → PCI Subsystem | Record state (Auto/Enabled typical for RTX 40) | ⏸️ | ⏸️ |

### C5. Memory (EXPO/XMP)

| Setting | BIOS path (ASUS typical) | Target | Actual | PASS |
|---------|--------------------------|--------|--------|------|
| **EXPO / DOCP profile** | Ai Tweaker → Memory profile | **Record current** — do not change during install unless stable | ⏸️ | ⏸️ |
| **Reported speed** | Main screen / Ai Tweaker | Audit: **4800 MT/s** · Kit: **6000 MT/s** | ⏸️ | ⏸️ |

**Decision:**

- [ ] Leave memory at current profile for install (recommended — reduce variables)
- [ ] Enable EXPO to 6000 before install — only if already stable in Windows
- [ ] Tune later after bare-metal validation

### C6. USB & install boot

| Setting | BIOS path (ASUS typical) | Target | Actual | PASS |
|---------|--------------------------|--------|--------|------|
| **USB 2.0/3.0 ports** | Physical | Install USB in **rear panel USB 3** port | ⏸️ | ⏸️ |
| **USB boot option** | Boot menu **F8** (ASUS typical) | SanDisk / UEFI USB detected | ⏸️ | ⏸️ |
| **Install media** | — | `ARCH_202607` SanDisk 57 GB | ⏸️ | ⏸️ |

---

## Phase D — Live ISO cross-check (optional, before or during install)

Boot Arch install USB → **UEFI Arch Linux** entry (not legacy).

```bash
# Boot mode
[ -d /sys/firmware/efi ] && echo UEFI || echo LEGACY

# Secure Boot
mokutil --sb-state 2>/dev/null || echo "mokutil unavailable"

# TPM (if needed)
cat /sys/class/tpm/tpm0/tpm_version_major 2>/dev/null || echo "no tpm node"

# Storage
lsblk -f
fdisk -l /dev/nvme0n1

# GPU (expect discrete NVIDIA only)
lspci -k | grep -A3 -E 'VGA|3D'
```

| Check | Expected | Actual | PASS |
|-------|----------|--------|------|
| UEFI boot | `/sys/firmware/efi` exists | ⏸️ | ⏸️ |
| Secure Boot state | Matches Phase A/C decision | ⏸️ | ⏸️ |
| NVMe visible | `nvme0n1` ~931 GB | ⏸️ | ⏸️ |
| Existing EFI partition | ~100 MB FAT32 part 1 | ⏸️ | ⏸️ |
| NVIDIA GPU | RTX 4060 Ti in lspci | ⏸️ | ⏸️ |

---

## Decision record (complete before disk shrink)

| Decision | Choice | Date | Notes |
|----------|--------|------|-------|
| Secure Boot for install | **Yol 1 — disable for install** (recommended) | 2026-07-24 | Pending A1 canonical confirm |
| BitLocker action before shrink | **Suspend if On** (not full disable) | 2026-07-24 | Pending A2 admin output |
| Fast Startup before shrink | **Disable** | 2026-07-24 | Currently Enabled (`0x1`) |
| EXPO profile for install | Leave as-is (recommended) | | Reduce variables |
| Reuse existing EFI partition | **Yes** (planned) | | ~100 MB ESP part 1 — monitor free space |
| Windows reset timing | **After** bare-metal validation | | Not in this phase |

---

## Risks if skipped

| Skipped check | Risk |
|---------------|------|
| BitLocker state | Shrink/resize failure or data loss; recovery harder |
| Secure Boot state | NVIDIA module load failure; install succeeds but no GUI |
| CSM/Legacy mismatch | USB boots legacy; ESP/dual-boot confusion |
| Storage mode change | Windows boot break |
| Fast Startup on | Filesystem unclean; shrink issues |
| Boot order | Accidental wrong-disk boot |

---

## PASS criteria

This checklist is **PASS** when:

```text
Phase A — all items recorded (Secure Boot + BitLocker known)
Phase C — Boot Mode UEFI, CSM Disabled, storage mode unchanged/safe
Phase C — SVM Enabled, fTPM/EXPO states recorded
Decision record — complete (Secure Boot strategy chosen)
Operator sign-off — ready for disk shrink plan
```

When PASS, update **Overall status** to:

```text
PASS — BIOS/UEFI verified; ready for disk shrink plan.
```

---

## Operator sign-off

| Field | Value |
|-------|--------|
| Operator | asir0z |
| BIOS session date | ⏸️ |
| BIOS version confirmed | ⏸️ |
| Ready for disk shrink | ⏸️ |

---

## Cross-references

| Document | Link |
|----------|------|
| Hardware audit | [hardware-audit.md](hardware-audit.md) |
| Bare-metal readiness (repo) | `linux/arch-workstation/BAREMETAL-READINESS.md` |
| Platform state | `shared/certification/PLATFORM-STATE.md` (bare-metal NOT AUTHORIZED until install sprint) |

---

*SmoothOperator™ · BIOS/UEFI checklist · evidence only · no mutations performed*
