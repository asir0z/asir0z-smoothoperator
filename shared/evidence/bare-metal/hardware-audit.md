# Bare-Metal Hardware Audit — SmoothOperator Host

> **Date:** 2026-07-23  
> **Host:** Windows 11 Pro physical machine (Arch dual-boot target)  
> **Method:** Read-only inventory via PowerShell / WMI / PnP (no installs, no mutations)  
> **Operator:** asir0z  
> **Hostname (Windows):** DESKTOP-P53S8B0

---

## Executive Summary

This audit inventories the physical PC that will receive the first bare-metal Arch Linux installation. Collection was performed from **Windows 11** (non-elevated session where noted). Linux commands (`dmidecode`, `lscpu`, `sensors`, `bootctl`, `mokutil`) were **not run on bare metal**; Windows-equivalent queries were used.

| Category | Assessment |
|----------|------------|
| **CPU** | AMD Ryzen 5 7500F — fully supported on Arch (Zen 4, AM5) |
| **Motherboard** | ASUS PRIME A620M-K — standard AM5, UEFI firmware |
| **RAM** | 32 GB DDR5 (2×16 GB G.Skill) — supported |
| **GPU** | NVIDIA GeForce RTX 4060 Ti — **primary install consideration** (proprietary/open NVIDIA stack) |
| **Storage** | 1 TB NVMe (MLD M700) — GPT, Windows occupies ~931 GB; **no free unallocated space** |
| **Network** | Realtek GbE + Realtek USB Wi-Fi/BT combo — drivers available |
| **Audio** | Realtek ALC897 + NVIDIA HDMI/DP audio — PipeWire compatible |
| **Firmware** | UEFI confirmed; Secure Boot / BitLocker / TPM state **requires elevated verification** |
| **Blockers for install plan** | Disk shrink required · firmware security state unknown · BIOS age (May 2023) |

**Verdict:** Hardware is Arch-compatible. Installation planning must address **partition shrink**, **NVIDIA driver strategy**, and **elevated firmware/disk-security checks** before execution.

---

## Hardware Inventory

### CPU

| Item | Value |
|------|--------|
| Model | AMD Ryzen 5 7500F 6-Core Processor |
| Cores | 6 |
| Threads | 12 |
| Max clock (reported) | 3701 MHz |
| Manufacturer | AuthenticAMD |
| Virtualization (firmware enabled) | **Yes** (`VirtualizationFirmwareEnabled: True`) |
| Integrated GPU | **None** (7500F — discrete GPU required for display) |
| Microcode vendor | **AMD** → Arch package: `amd-ucode` |
| Power scheme (Windows governor analogue) | **High performance** (`8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c`) |

**Arch notes:** Zen 4 / Raphael support is mature in mainline kernel. Early microcode via `amd-ucode` initramfs hook recommended.

**Linux command mapping (for live ISO verification):**

```bash
lscpu
grep -E 'model name|cpu cores|siblings|vendor_id' /proc/cpuinfo
```

---

### Motherboard

| Item | Value |
|------|--------|
| Vendor | ASUSTeK COMPUTER INC. |
| Model | **PRIME A620M-K** |
| Version | Rev 1.xx |
| Serial | 230520951101825 |
| Chipset class | AMD A620 (AM5 entry) |

### BIOS / UEFI

| Item | Value |
|------|--------|
| Vendor | American Megatrends Inc. |
| Version | **0401** |
| Release date | 2023-05-16 |
| Firmware type | **UEFI** (`BiosFirmwareType: Uefi`) |
| Secure Boot | **Unknown** — `Confirm-SecureBootUEFI` access denied (non-admin) |
| CSM/Legacy | Not queried — assume UEFI-only on AM5 |

**Related PCI platform devices:** AMD PSP 11.0 (`1022:1649`) — platform security processor (fTPM candidate).

**Linux command mapping:**

```bash
sudo dmidecode -t baseboard
sudo dmidecode -t bios
```

---

### RAM

| Item | Value |
|------|--------|
| Total installed | **32 GB** (34,078,605,312 bytes) |
| Sticks | **2** |
| Per stick | 16 GB |
| Manufacturer | G Skill Intl |
| Part number | F5-6000J3636F16G |
| Rated speed (SPD) | 6000 MT/s |
| **Currently reported speed** | **4800 MT/s** (JEDEC / profile — verify EXPO/XMP in BIOS) |
| Form factor | DIMM (8) |
| Slots | P0 CHANNEL A DIMM 0 · P0 CHANNEL B DIMM 0 |
| Free (at collection) | ~18.3 GB of 31.7 GB visible |

**Linux command mapping:**

```bash
sudo dmidecode -t memory
free -h
```

---

### GPU

| GPU | Vendor | PCI ID | Windows driver | Arch kernel module (expected) |
|-----|--------|--------|----------------|-------------------------------|
| **NVIDIA GeForce RTX 4060 Ti** | NVIDIA | `10DE:2803` (rev A1) | 32.0.16.1074 (2026-07-02) | `nvidia` / `nvidia_modeset` / `nvidia_uvm` **or** `nvidia-open` modules |
| NVIDIA HD Audio (HDMI/DP) | NVIDIA | `10DE:22BD` | NVIDIA HD Audio | `snd_hda_intel` |

| Item | Value |
|------|--------|
| Discrete GPU count | 1 |
| Integrated GPU | **None** (7500F) |
| VRAM (reported) | ~4 GB |
| Primary display output | NVIDIA (both monitors attached to GPU) |

**Connected displays (via NVIDIA audio endpoints + EDID):**

| Monitor | EDID | Role | Resolution | Refresh | Connector (inferred) |
|---------|------|------|------------|---------|----------------------|
| **LG ULTRAGEAR** | GSM `5C1C` | Primary (`DISPLAY1`) | 1920×1080 | **143 Hz** | DisplayPort (high refresh) |
| **ASUS VS228** | ACI `22FD` | Secondary (`DISPLAY2`) | 1920×1080 | 60 Hz (typical; not separately queried) | HDMI or DP |

Desktop layout: primary at `(0,0)`, secondary at `(1920,365)` — dual 1080p, offset vertical alignment.

**Linux command mapping:**

```bash
lspci -k | grep -A3 -E 'VGA|3D|Audio.*NVIDIA'
```

---

### Storage

#### Disk 0 — System NVMe (bare-metal target)

| Item | Value |
|------|--------|
| Model | **MLD M700 NVMe SSD** |
| Serial | `6479_A77E_BAC0_04F3.` |
| Interface | **NVMe** |
| Controller PCI | `1987:5018` (Phison-class NVM Express) |
| Capacity | **931.51 GB** (1,000,204,886,016 bytes) |
| Partition table | **GPT** |
| Health | Healthy / Online |

| Part | Type | Size | FS | Mount | Notes |
|------|------|------|-----|-------|-------|
| 1 | EFI System | 100 MB | FAT32 | — | `{c12a7328-…}` shared EFI candidate |
| 2 | Microsoft reserved | 16 MB | — | — | MSR |
| 3 | Basic | **930.56 GB** | NTFS | **C:** | Windows system (~356 GB free at audit) |
| 4 | Recovery | 860 MB | NTFS | — | Windows recovery |
| — | **Unallocated** | **~0 GB** | — | — | **~3.7 MB only** — no Arch space without shrink |

#### Disk 1 — USB (install media, not bare-metal disk)

| Item | Value |
|------|--------|
| Model | SanDisk 3.2Gen1 USB |
| Serial | `0101246b8ed620cf7660…` |
| Interface | USB |
| Capacity | ~57.3 GB |
| Partition | 1 × Basic ~57.2 GB FAT32 |
| Label | **ARCH_202607** |
| Mount | **E:** |

**Linux command mapping:**

```bash
lsblk -f
sudo fdisk -l
```

---

### Network

| Adapter | Type | Hardware | PCI/USB ID | Windows status | Arch driver (expected) |
|---------|------|----------|------------|----------------|------------------------|
| **Realtek PCIe GbE** | Ethernet | Onboard | `10EC:8168` rev 15 | Up · 1 Gbps | `r8169` (or `r8168-dkms` if instability) |
| **Realtek RTL8723B** | Wi-Fi | USB combo | `0BDA:B720` | Disconnected at audit | `rtl8xxxu` / `rtl8723bu` + firmware |
| **Realtek Bluetooth 4.0** | Bluetooth | USB combo (same dongle) | `0BDA:B720` MI_00 | Present | `btusb` + `rtl_bt` firmware |
| Hyper-V / Tailscale / WAN miniports | Virtual | — | — | Present | Exclude from bare-metal plan |

**Linux command mapping:**

```bash
lspci -k
lsusb
```

---

### Audio

| Device | Type | Hardware ID | Codec / role | Arch driver (expected) |
|--------|------|-------------|--------------|------------------------|
| **Realtek(R) Audio** | Onboard HDA | `10EC:0897` (ALC897) | Analog line/out, digital | `snd_hda_intel` + `linux-firmware` |
| **NVIDIA High Definition Audio** | GPU HDA | `10DE:00A6` | HDMI/DP audio to monitors | `snd_hda_intel` |
| M-Audio AIR 192 4 | USB audio interface | `0763:410B` | External interface | `snd-usb-audio` |
| THX Spatial (Razer) | Virtual | Razer stack | Windows-only spatial | **Not required on Arch** |
| Bluetooth audio endpoints | BT | Various paired devices | AirPods, HK Onyx, etc. | PipeWire + `bluez` |

**Primary bare-metal path:** PipeWire + WirePlumber (already in SmoothOperator workstation stack).

---

### USB — Connected devices (audit snapshot)

| Device | VID:PID | Notes |
|--------|---------|-------|
| Razer Ornata V3 X | `1532:02A2` | Keyboard |
| Logitech Unifying receiver | `046D:C52B` | Keyboard/mouse combo |
| Logitech LIGHTSPEED receiver | `046D:C53F` | Wireless input |
| Realtek RTL8723B Wi-Fi/BT dongle | `0BDA:B720` | Network + Bluetooth |
| ASUS USB device | `0B05:19AF` | Likely ASUS Aura/USB service |
| M-Audio AIR 192 4 | `0763:410B` | USB audio interface |
| SanDisk 3.2Gen1 | `0781:5591` | **Arch install USB** (`ARCH_202607`) |

---

### Monitors

| Monitor | EDID manufacturer | Product code | Resolution | Refresh | Position |
|---------|-------------------|--------------|------------|---------|----------|
| LG ULTRAGEAR | GSM | 5C1C | 1920×1080 | **143 Hz** (primary) | (0, 0) |
| ASUS VS228 | ACI | 22FD | 1920×1080 | ~60 Hz (secondary) | (1920, 365) |

Physical size hints (WMI): LG ~60×34 cm · ASUS ~48×27 cm.

EDID raw dump not collected — available on live ISO via `edid-decode` / `hyprctl monitors`.

---

### Firmware & Boot

| Item | Status |
|------|--------|
| Boot mode | **UEFI** (confirmed) |
| Secure Boot | **Unknown** — admin required (`Confirm-SecureBootUEFI`: access denied) |
| TPM | **Unknown** — `Get-Tpm` returned empty (access denied); AMD PSP 11.0 present |
| BitLocker (C:) | **Unknown** — `manage-bde` access denied |
| Device Guard | Off |
| Hypervisor present | Not confirmed in this session |

**Linux commands (run on live ISO before install):**

```bash
bootctl status
mokutil --sb-state
systemd-analyze
```

---

### Filesystems (mounted at audit)

| Mount | FS | Label | Size | Free | Role |
|-------|-----|-------|------|------|------|
| **C:** | NTFS | — | ~931 GB | ~357 GB | Windows system |
| **E:** | FAT32 | ARCH_202607 | ~57 GB | ~56 GB | Arch install USB |
| Recovery (WinRE) | NTFS | — | ~860 MB | ~115 MB | Windows recovery |

No Linux native filesystems present on NVMe.

---

### Sensors

| Item | Status |
|------|--------|
| `sensors` (lm-sensors) | **Not available on Windows** — collect on Arch live ISO |
| CPU temperature | Unknown — verify with `sensors`, `ryzenadj` optional post-install |
| Fan control | Unknown — ASUS board typically UEFI-controlled; no evidence collected |
| Available sensor chips | Expected: `k10temp` (AMD), possibly `asus-ec-sensors` |

---

## Arch Compatibility Assessment

### Supported / low risk

- AMD Ryzen 5 7500F (Zen 4) — mainline kernel
- ASUS PRIME A620M-K — standard ACPI, no exotic hardware
- NVMe Phison-class SSD — `nvme` built-in
- Realtek RTL8168 ethernet — widely used
- Realtek ALC897 — HDA supported
- Dual 1080p monitors — Hyprland/Wayland multi-monitor supported
- USB input/audio devices — class drivers

### Requires planning

| Item | Consideration |
|------|---------------|
| **NVIDIA RTX 4060 Ti** | Use `nvidia-open-dkms` (preferred modern stack) or validated proprietary `nvidia-dkms`. Hyprland requires Wayland + NVIDIA support (GBM, kernel ≥ 6.2, driver ≥ 535). Test on live ISO. |
| **No iGPU** | Install media must boot with NVIDIA driver or nomodeset fallback until drivers loaded. Live ISO GUI may need proprietary modules. |
| **Disk layout** | **Zero unallocated space** — shrink Windows `C:` before install (recommend 100–200 GB minimum for Arch root + home). |
| **EFI partition (100 MB)** | Shared EFI works but tight; monitor after adding Linux boot entries. Some operators expand EFI in separate maintenance window. |
| **Secure Boot unknown** | If enabled, DKMS modules need signing or Secure Boot disabled for NVIDIA. Verify before install. |
| **BitLocker unknown** | If enabled on C:, suspend before partition shrink. Recovery key must be documented. |
| **Wi-Fi USB dongle** | Required for wireless install; ensure `rtl8723` firmware (`linux-firmware`) on install media. Ethernet preferred for first install. |
| **BIOS 0401 (May 2023)** | Consider ASUS BIOS update before bare-metal sprint (stability, EXPO, fTPM) — operator decision, not executed in this audit. |
| **RAM speed 4800 vs 6000** | Verify EXPO/XMP profile in BIOS during install planning. |

### Unsupported hardware

**None identified** in this audit.

---

## Risks

| Risk | Severity | Mitigation |
|------|----------|------------|
| No unallocated NVMe space | **High** | Shrink C: in elevated Windows Disk Management; verify BitLocker off/suspended |
| Secure Boot + NVIDIA DKMS | **Medium** | Check `mokutil --sb-state`; plan MOK enroll or disable Secure Boot |
| BitLocker on system partition | **High** | Admin `manage-bde -status`; suspend + document recovery key |
| NVIDIA Wayland/Hyprland regression | **Medium** | Validate on live ISO; pin driver version in install plan |
| 100 MB EFI partition | **Low–Medium** | Monitor free space; avoid duplicate EFI partitions |
| USB Wi-Fi only (if no Ethernet) | **Medium** | Prefer wired install; pack `linux-firmware` |
| BIOS age | **Low** | Review ASUS release notes for 7500F / A620 stability |
| Windows recovery partition | **Low** | Do not delete recovery during shrink |

---

## Recommended Arch Packages

### Essential (install plan baseline)

```text
base linux linux-firmware amd-ucode
networkmanager
pipewire wireplumber pipewire-pulse pipewire-alsa
hyprland waybar wofi kitty polkit-gnome
git openssh curl wget
```

### GPU (NVIDIA RTX 4060 Ti)

```text
nvidia-open-dkms          # preferred for RTX 40-series (verify on live ISO)
# OR nvidia-dkms          # fallback if open stack issues
nvidia-utils
lib32-nvidia-utils        # optional 32-bit GL/Vulkan
```

### Network

```text
linux-firmware            # Realtek Wi-Fi/BT firmware
# r8168-dkms              # only if onboard NIC unstable with r8169
bluez                     # Bluetooth
```

### Filesystem tools

```text
btrfs-progs               # if btrfs chosen
dosfstools                # EFI mount
ntfs-3g                   # optional read/write Windows C: (policy decision)
```

### Optional workstation parity

```text
cursor                    # via install-cursor.sh (AUR/manual)
xdg-desktop-portal xdg-desktop-portal-hyprland
noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd
```

---

## Recommended Firmware

| Package / action | Purpose |
|----------------|---------|
| `amd-ucode` | CPU microcode (initramfs hook) |
| `linux-firmware` | Wi-Fi, BT, audio, GPU firmware blobs |
| ASUS BIOS update (optional) | AM5 stability, memory profile, security |
| NVIDIA firmware | Bundled with `nvidia-utils` / driver package |
| fTPM | Enable in BIOS if TPM features needed; verify Windows BitLocker interaction |

---

## Recommended Partition Layout (draft — not authorized)

> **Planning only.** Requires Windows shrink + elevated verification before execution.

```text
Disk 0 (MLD M700 NVMe — GPT, existing Windows preserved)

┌─────────────────────────────────────────────────────────────┐
│ Part 1  EFI System     100 MB   FAT32   (existing, shared)  │
│ Part 2  MSR            16 MB    (existing)                  │
│ Part 3  Windows C:     ~730 GB  NTFS    (SHRINK from 931 GB)│
│ Part 4  Recovery       860 MB   (existing — do not touch)     │
│ Part 5  Linux root     80–120 GB ext4 OR btrfs (NEW)        │
│ Part 6  Linux home     80–100 GB ext4/btrfs (NEW, optional) │
│ Part 7  Linux swap     16–32 GB  swapfile preferred on btrfs│
└─────────────────────────────────────────────────────────────┘
```

**Guidelines:**

- Target **≥ 100 GB** for Arch root (operator workload: Cursor, Docker optional, `~/Projects/*`)
- Prefer **single partition** (`/` only) for simplicity if home separation not required
- **Swap:** swapfile on root (t32 GB RAM — 8–16 GB swapfile typical)
- **Bootloader:** `systemd-boot` (existing EFI, Windows Boot Manager preserved) **or** GRUB dual-boot — operator choice in install sprint
- **Filesystem:** **ext4** (simple, proven) or **btrfs** (snapshots — operator preference)

---

## Installation Considerations

1. **Authorization:** Bare-metal install is **NOT AUTHORIZED** per `PLATFORM-STATE.md` — this audit is evidence-only.
2. **Pre-flight (elevated Windows):** Secure Boot state · BitLocker state · disk shrink · recovery key · BIOS EXPO profile.
3. **Install media:** SanDisk `ARCH_202607` USB already present (FAT32, ~57 GB).
4. **Network during install:** Prefer **Ethernet** (Realtek 8168); Wi-Fi dongle as fallback with firmware.
5. **Display during install:** No iGPU — live environment must handle NVIDIA from start or use text install (`archinstall` TUI).
6. **Dual-boot:** Preserve existing EFI entry for Windows Boot Manager; add Linux loader to same ESP.
7. **Post-install:** `WORKSTATION_PROFILE=baremetal bash linux/arch-workstation/apply-config.sh` per repo readiness doc.
8. **Hyprland monitors:** Repo uses `monitor=,preferred,auto,1` — verify 143 Hz profile on LG after install (`hyprctl monitors`).
9. **NTFS policy:** Decide before mount Windows C: from Arch (read-only vs `ntfs-3g` write — security/data risk).
10. **Evidence gate:** Next sprint produces install plan → execution → certification (DevOps Lab).

---

## Unknown Items Requiring Manual Verification

| Item | How to verify |
|------|---------------|
| Secure Boot on/off | Admin PowerShell: `Confirm-SecureBootUEFI` · Linux: `mokutil --sb-state` |
| BitLocker on C: | Admin: `manage-bde -status C:` |
| TPM / fTPM state | BIOS setup · Linux: `systemd-cryptenroll --tpm2-device=list` |
| Exact secondary monitor refresh | `hyprctl monitors` on live ISO or Windows display advanced settings |
| RAM EXPO/XMP profile | BIOS → Ai Tweaker / EXPO → confirm 6000 MT/s if desired |
| Unallocated space after shrink | `diskmgmt.msc` (elevated) or `lsblk` on live ISO |
| CPU/GPU temps under load | `sensors` on live ISO / post-install stress test |
| NVIDIA driver choice (open vs proprietary) | Live ISO test: Hyprland session + `glxinfo` / `nvidia-smi` |
| ASUS BIOS update availability | ASUS support page for PRIME A620M-K |
| Windows Fast Startup | Disable before partition operations (dual-boot best practice) |

---

## Collection Log

| Source | Command / API |
|--------|---------------|
| CPU | `Get-CimInstance Win32_Processor` |
| Board / BIOS | `Get-CimInstance Win32_BaseBoard`, `Win32_BIOS` |
| RAM | `Get-CimInstance Win32_PhysicalMemory` |
| GPU | `Get-CimInstance Win32_VideoController`, PnP PCI |
| Storage | `Get-Disk`, `Get-Partition`, `Get-Volume`, `Get-PhysicalDisk` |
| Network | `Get-NetAdapter`, PnP Net class |
| Audio | PnP Media class, `Win32_SoundDevice` |
| USB | PnP USB present devices |
| Monitors | `WmiMonitorID`, `System.Windows.Forms.Screen`, `Win32_VideoController` |
| Firmware | `Get-ComputerInfo`, `Confirm-SecureBootUEFI` (denied), `Get-Tpm` (denied), `manage-bde` (denied) |
| Power | `powercfg /GETACTIVESCHEME` |

**Elevation gaps:** Secure Boot, BitLocker, TPM, and `bcdedit /enum firmware` require **Administrator** — flagged as unknown, not assumed safe.

---

## Cross-References

| Document | Relationship |
|----------|--------------|
| `shared/evidence/ws-2/readiness-audit/baremetal-hardware-plan.md` | Sprint 1 planning baseline (partial — this audit supersedes detail) |
| `linux/arch-workstation/BAREMETAL-READINESS.md` | Repo readiness notes (execution not authorized) |
| `shared/certification/PLATFORM-STATE.md` | Bare-metal **NOT AUTHORIZED** |

---

*SmoothOperator™ · Bare-metal hardware audit · evidence only · no mutations performed*
