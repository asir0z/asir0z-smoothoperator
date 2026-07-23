# Arch Install Specification — SmoothOperator Bare-Metal

> **Canonical bare-metal installation specification** for SmoothOperator™  
> **Date:** 2026-07-24  
> **Host:** ASUS PRIME A620M-K · Ryzen 5 7500F · RTX 4060 Ti · 32 GB · MLD M700 NVMe  
> **Status:** ✅ Complete — approved **before** disk shrink; execute on install day only  
> **Install media:** USB `ARCH_202607` (SanDisk · FAT32)  
> **Prerequisites:** [hardware-audit.md](hardware-audit.md) · [bios-uefi-checklist.md](bios-uefi-checklist.md) · [disk-shrink-plan.md](disk-shrink-plan.md)

**Purpose:** Answer **how** and **why** — no architectural decisions on install day. Execute this document; record evidence in `installation-evidence/`.

**Policy:** **Zero AUR dependency** on first boot. Official Arch repos only until validation PASS. AUR (`yay`) is **Phase 2** (post-validation).

---

## Why this specification exists

```text
A VM may disappear tomorrow.
The engineering laboratory must not.
```

Bare-metal install is reproducible when:

- Partition layout is pre-approved
- Bootloader choice is justified
- Package set is minimal and official
- NVIDIA + Wayland path is explicit
- Bootstrap comes from Git — not ad-hoc dotfiles

---

## Pre-install gates (do not start installer until PASS)

| Gate | Document | Status |
|------|----------|--------|
| Hardware known | hardware-audit.md | ✅ |
| Phase A admin | phase-a-output.txt | ✅ |
| Fast Startup off | bios-uefi-checklist.md | ✅ (online prep) |
| OFFLINE-1 CERTIFIED (Phases A–D · 5 gates) | [offline-shrink-evidence.txt](offline-shrink-evidence.txt) · [OFFLINE-1](../../missions/OFFLINE-1-NTFS-SHRINK.md) | ⏸️ **required before this mission** |
| BIOS Secure Boot **off** | bios-uefi-checklist.md | ⏸️ install day |
| USB boot | ARCH_202607 | ✅ |
| This spec read end-to-end | — | ⏸️ operator |

---

## Operator constants (fixed)

| Item | Value | Why |
|------|-------|-----|
| Username | `asir0z` | Windows / VM parity |
| Hostname | `arch-workstation` | Repo + SSH identity |
| Timezone | `Europe/Istanbul` | Operator locale |
| Locale | `en_US.UTF-8` | WS-2 baseline |
| Keyboard | `tr,us` · Alt+Shift | Hyprland dotfiles |
| Project root | `/home/asir0z/Projects` | Reinstall-safe on separate `/home` |
| Git identity | `Asır` · `asir01oz@gmail.com` | apply-config.sh |

---

# Phase 1 — Base System

## 1.1 Disk layout

**Why separate `/` and `/home`?**

- Reinstall Arch without touching projects, Docker data, Cursor cache, or clones
- Root holds OS churn; home holds long-lived operator state
- Matches SmoothOperator reproducibility: bootstrap re-runs on `/`, data survives on `/home`

**Layout** (after [disk-shrink-plan.md](disk-shrink-plan.md)):

| Device | Size | FS | Mount | Notes |
|--------|------|-----|-------|-------|
| `nvme0n1p1` | 100 MB | FAT32 | `/boot/efi` | **Existing ESP** — do not format if possible |
| `nvme0n1p3` | ~580 GB | NTFS | — | Windows — untouched |
| **new** | **150 GB** | **ext4** | **`/`** | Root |
| **new** | **remainder** | **ext4** | **`/home`** | Projects + cache |
| `nvme0n1p4` | 860 MB | NTFS | — | Windows Recovery — untouched |

**Why ext4?** Mature, well-tested, easy recovery, aligns with minimal first install. Btrfs snapshots deferred.

**Why no swap partition?** 32 GB RAM · flexibility via swapfile · no partition table waste · zram for desktop responsiveness.

## 1.2 Installer partition steps (manual / archinstall)

1. Boot UEFI USB → **Arch Linux install medium (x86_64, UEFI)**
2. Verify disks: `lsblk -f` · expect unallocated between Windows and Recovery
3. **Do not** create a new EFI partition
4. Create **`/`** 150 GB ext4 → mount `/mnt`
5. Create **`/home`** ext4 in remaining unallocated → mount `/mnt/home`
6. Mount ESP: `mount /dev/nvme0n1p1 /mnt/boot/efi`
7. **Do not** format ESP unless empty/corrupt — if must format, Windows boot entry must be restored

## 1.3 Base packages (pacstrap)

**Why `linux` not `linux-lts`?** RTX 4060 Ti + current NVIDIA DKMS tracks mainline well; no special stability requirement for this workstation. Pin LTS only if validation finds kernel regressions.

```text
base
base-devel
linux
linux-firmware
amd-ucode
```

**Why amd-ucode?** Ryzen 5 7500F — early microcode load via initramfs.

`genfstab -U /mnt >> /mnt/etc/fstab`

### fstab expectations

| Mount | UUID | Options |
|-------|------|---------|
| `/` | UUID | `defaults` |
| `/home` | UUID | `defaults` |
| `/boot/efi` | UUID | `defaults,fmask=0137,dmask=0277` |

## 1.4 Swapfile (post-install — not during pacstrap)

**Why post-install?** Keeps installer partition step simple; size tuned after real use.

```bash
# As root, after first boot — example 16 GB
fallocate -l 16G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

## 1.5 zram (post-install)

**Why zram?** Desktop responsiveness under memory pressure without swap partition; pairs well with 32 GB RAM.

```bash
pacman -S zram-generator
# /etc/systemd/zram-generator.conf — default often sufficient
systemctl enable --now systemd-zram-setup@zram0
```

Record final config in installation evidence.

---

# Phase 2 — Boot

## 2.1 Bootloader choice: **systemd-boot**

| Criterion | systemd-boot | GRUB |
|-----------|--------------|------|
| UEFI integration | Native | Extra layer |
| Config complexity | Minimal | Higher |
| Dual-boot maintenance | Simple entries | Flexible but heavier |
| SmoothOperator minimalism | **Match** | Overkill for this layout |

**Decision:** **systemd-boot** — not GRUB.

## 2.2 Installation

Inside arch-chroot (`arch-chroot /mnt`):

```bash
bootctl install
```

ESP mounted at `/boot/efi`. Creates `/boot/efi/loader/`.

## 2.3 Loader config

`/boot/efi/loader/loader.conf`:

```ini
default arch.conf
timeout 3
editor no
```

## 2.4 Arch entry

`/boot/efi/loader/entries/arch.conf`:

```ini
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=<ROOT-UUID> rw nvidia_drm.modeset=1 quiet loglevel=3
```

Replace `<ROOT-UUID>` with `blkid` output for `/` partition.

**Why `nvidia_drm.modeset=1` on cmdline?** Required for reliable Wayland + Hyprland + NVIDIA headless/display stack; set from day one.

## 2.5 Windows entry (dual-boot)

`/boot/efi/loader/entries/windows.conf`:

```ini
title   Windows 11
efi     /EFI/Microsoft/Boot/bootmgfw.efi
```

**Why preserve Windows EFI path?** Phase 1 validation runs dual-boot; Windows reset comes later.

## 2.6 mkinitcpio

`/etc/mkinitcpio.conf` — HOOKS must include:

```text
HOOKS=(base udev autodetect microcode modconf block filesystems keyboard fsck)
```

(`microcode` loads amd-ucode)

```bash
mkinitcpio -P
```

---

# Phase 3 — Core Packages

**Why official repos only?** First boot diagnosability — every package traceable to pacman. AUR deferred to post-validation Phase.

**Phase 1 pacstrap already provides:** `base` · `linux` · `linux-firmware` · `amd-ucode`

Additional packages (chroot or first boot):

```bash
pacman -S --needed \
  networkmanager \
  sudo \
  git \
  openssh \
  pipewire wireplumber pipewire-pulse pipewire-alsa \
  kitty \
  jq curl wget \
  vim nano \
  man-db man-pages texinfo \
  tmux
```

`tmux` optional — omit if not wanted.

Enable services:

```text
NetworkManager.service
```

User systemd (after first login):

```text
pipewire.service
wireplumber.service
pipewire-pulse.service
```

---

# Phase 4 — NVIDIA

## 4.1 Strategy

| Item | Decision | Why |
|------|----------|-----|
| Driver | **Proprietary NVIDIA** | RTX 4060 Ti · mature Wayland path with modeset |
| Build | **DKMS** | Survives kernel updates |
| Secure Boot | **Off** (BIOS) | Yol 1 — no MOK enrollment on first install |
| Open driver | **Not used** | Operator spec: proprietary for first bare-metal |

## 4.2 Packages

```bash
pacman -S --needed nvidia-dkms nvidia-utils
```

Optional 32-bit:

```bash
pacman -S lib32-nvidia-utils
```

## 4.3 Kernel module + Wayland

`/etc/modprobe.d/nvidia.conf`:

```text
options nvidia_drm modeset=1
```

Already on kernel cmdline (Phase 2) — both for redundancy.

## 4.4 mkinitcpio (NVIDIA)

If early KMS needed, add modules per Arch NVIDIA wiki after first boot test. Start minimal; add only if validation FAIL.

## 4.5 Validation command (Phase 7)

```bash
nvidia-smi
lsmod | grep nvidia
echo $XDG_SESSION_TYPE   # wayland in Hyprland
```

---

# Phase 5 — Desktop (minimal at install)

**Why minimal?** Reduce variables before SmoothOperator bootstrap; Hyprland stack proven on VM.

```bash
pacman -S --needed \
  hyprland \
  waybar wofi \
  polkit-gnome \
  sddm \
  xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd \
  qt5-wayland qt6-wayland \
  seatd
```

| Package | Why |
|---------|-----|
| hyprland | Wayland compositor — operator desktop |
| sddm | Display manager — graphical login |
| polkit-gnome | Auth agent for GUI elevation |
| xdg-desktop-portal* | Cursor/Electron + desktop integration |
| seatd | Seat management if logind insufficient for Hyprland |

Enable:

```bash
systemctl enable sddm
systemctl enable seatd
```

**Not installed during base install:** Cursor (bootstrap script) · Docker · browser · AUR helpers.

---

# Phase 6 — SmoothOperator Bootstrap

**Why repository enters here?** OS is bootable; operator identity and dotfiles are **Git-managed**, not installer defaults.

## 6.1 First login

1. SDDM → Hyprland session (or default Hyprland if configured)
2. Network: `nmtui` or `nmcli` if needed
3. Verify: `ping -c1 archlinux.org`

## 6.2 SSH keys

Copy from Windows backup or generate — **never commit private keys**.

```bash
install -d -m 700 ~/.ssh
# operator transfer: id_ed25519 + known_hosts
```

## 6.3 Clone repositories

```bash
mkdir -p ~/Projects
cd ~/Projects

git clone https://github.com/asir0z/asir0z-smoothoperator.git
git clone https://github.com/asir0z/asir0z-devopslab.git
git clone https://github.com/asir0z/asir0z-web.git
git clone https://github.com/asir0z/asir0z-product-intelligence.git
# asir0z-cortex — defer until GitHub repo restored
```

## 6.4 Bootstrap sequence

```text
Clone
  ↓
cd ~/Projects/asir0z-smoothoperator
  ↓
WORKSTATION_PROFILE=baremetal bash linux/arch-workstation/apply-config.sh
  ↓
hyprctl reload                    # in Hyprland session
  ↓
bash linux/arch-workstation/scripts/set-operator-timezone.sh
  ↓
bash linux/arch-workstation/scripts/install-cursor.sh   # official API — no AUR
  ↓
cursor ~/Projects/asir0z-smoothoperator
```

**Why `WORKSTATION_PROFILE=baremetal`?** Forces `hyprland.baremetal.conf` — no VM software-render overrides.

## 6.5 Dotfiles source

```text
linux/arch-workstation/dotfiles/
├── hypr/          tr,us · Alt+Shift · monitor config
├── waybar/
├── ssh/config.template
├── git/gitconfig.fragment
└── bash/profile.d/
```

## 6.6 devops-lab SSH note

Template `devops-lab` uses `127.0.0.1:2222` (Windows NAT). On bare metal, update to Tailscale/direct IP — post-validation friction item.

---

# Phase 7 — Validation

Record results in `installation-evidence/validation-checklist.md`.

| # | Check | Command / action | PASS |
|---|-------|------------------|------|
| 1 | Boot | systemd-boot → Arch · reboot twice | ⏸️ |
| 2 | Windows boot | systemd-boot → Windows entry | ⏸️ |
| 3 | Network | Ethernet + Wi-Fi (USB dongle) | ⏸️ |
| 4 | Audio | PipeWire · `wpctl status` · playback | ⏸️ |
| 5 | NVIDIA | `nvidia-smi` · Hyprland no software render | ⏸️ |
| 6 | Monitors | `hyprctl monitors` · dual 1080p | ⏸️ |
| 7 | Keyboard | TR/US · Alt+Shift · `ğüşiöç` | ⏸️ |
| 8 | Clipboard | kitty · Cursor ↔ terminal | ⏸️ |
| 9 | Git | `git pull` in smoothoperator | ⏸️ |
| 10 | SSH | `ssh` to contabo (if keys present) | ⏸️ |
| 11 | Cursor | Launch · open repo | ⏸️ |
| 12 | Repos | All planned clones present | ⏸️ |
| 13 | Timezone | `timedatectl` → Europe/Istanbul | ⏸️ |
| 14 | Docker | **Deferred** — separate sprint if needed | N/A |

**Daily use gate:** 2–3 days production work → then consider Windows reset (Phase 2 of platform roadmap).

---

# Phase 2 (post-validation) — AUR

**Why deferred?** Isolate first-boot failures to official packages only.

```text
Validation PASS
  ↓
Install yay (or paru) — operator choice
  ↓
AUR packages as friction demands
```

Do not install `yay` during initial install.

---

# Install day checklist (operator)

| Step | Action |
|------|--------|
| 1 | BIOS: Secure Boot **off** · USB first boot |
| 2 | Boot Arch ISO UEFI |
| 3 | `timedatectl set-timezone Europe/Istanbul` |
| 4 | Partition per Phase 1 — **no new EFI** |
| 5 | pacstrap + genfstab + chroot |
| 6 | Phase 2 bootctl + entries (Arch + Windows) |
| 7 | Phase 3–5 packages |
| 8 | Phase 4 NVIDIA |
| 9 | `useradd -m -G wheel,video,input,audio,network,seat -s /bin/bash asir0z` |
| 10 | `EDITOR=visudo` → wheel sudo |
| 11 | `passwd asir0z` |
| 12 | `exit` · `umount -R /mnt` · reboot |
| 13 | Phase 6 bootstrap |
| 14 | Phase 7 validation |
| 15 | swapfile + zram if not done |

---

# Evidence

| Artifact | Path |
|----------|------|
| Install log | `installation-evidence/install-log.txt` |
| Validation | `installation-evidence/validation-checklist.md` |
| fstab copy | `installation-evidence/fstab.txt` |
| loader entries | `installation-evidence/loader-entries/` |

---

# Platform progress

| Phase | Status |
|-------|--------|
| Hardware Audit | ✅ |
| BIOS/UEFI | ✅ (Phase A) · install-day BIOS ⏸️ |
| Disk Shrink | ⏸️ |
| **Install Spec** | ✅ |
| Installation | ⏸️ |
| Bootstrap | ⏸️ |
| Validation | ⏸️ |
| Windows Reset | ⏸️ |

---

# Cross-references

| Document | Role |
|----------|------|
| [disk-shrink-plan.md](disk-shrink-plan.md) | Partition sizes |
| [hardware-audit.md](hardware-audit.md) | GPU, NIC, disk |
| [bios-uefi-checklist.md](bios-uefi-checklist.md) | Secure Boot · Fast Startup |
| `linux/arch-workstation/` | Bootstrap + dotfiles |
| [README.md](README.md) | Evidence index |

---

*SmoothOperator™ · canonical bare-metal installation specification · reproducible engineering*
