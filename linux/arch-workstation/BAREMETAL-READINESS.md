# Bare-metal readiness — Arch + Windows dual-boot

> **NOT authorized for execution yet.** VM remains canonical until operator opens bare-metal sprint.

---

## Principle

Configure **now** on VM with profiles that survive bare-metal install. **Apply** GPU/disk/boot changes **only** when migrating off VirtualBox.

---

## What is already aligned (VM today)

| Item | State |
|------|--------|
| Username | `asir0z` |
| Hostname | `arch-workstation` |
| Git identity | Same as Windows (`Asır` · `asir01oz@gmail.com`) |
| Project path | `~/Projects/asir0z-smoothoperator` |
| Hyprland | Base + `vm` profile (software render) |
| Keyboard | `tr,us` · Alt+Shift toggle |
| SSH template | `contabo` · `devops-lab` (NAT note) |

---

## What changes on bare-metal (future sprint)

```text
1. archinstall on spare partition (Windows untouched)
2. Copy or reuse ~/.ssh keys from Windows backup
3. git clone into ~/Projects/*
4. GPU drivers (inventory GPU first):
     AMD  → mesa vulkan-radeon
     NVIDIA → nvidia-open-dkms
5. WORKSTATION_PROFILE=baremetal apply-config.sh
6. Remove VirtualBox Guest Additions / vboxsf
7. devops-lab SSH: switch from 127.0.0.1:2222 to Tailscale/direct
8. Evidence → certification → update PLATFORM-STATE
```

---

## Hardware reference (host — 2026-07-23)

| Component | Value |
|-----------|--------|
| CPU | AMD Ryzen 5 7500F 6-Core |
| RAM | 32 GB |
| System disk | MLD M700 NVMe ~931 GB |
| VM RAM today | 8 GB (adjust before bare-metal) |
| GPU | **Inventory on bare-metal install** — 7500F has no iGPU |

---

## Explicitly deferred

- Partition layout / dual-boot with Windows
- Bootloader (systemd-boot / GRUB)
- NTFS `C:` mount policy from Arch
- Chromium/browser install (install when daily use requires)
- Bootstrap vboxsf automount fix (WS-2 friction)

---

*Document only · execution when operator requests bare-metal sprint*
