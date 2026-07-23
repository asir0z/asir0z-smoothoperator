# WS-2 Sprint 1 — Bare-Metal Hardware Discovery Plan

> **Planning evidence only** — no disk, firmware, or installation mutations authorized

Collected from Windows host 2026-07-23 (read-only where permitted)

## CPU

| Item | Value |
|------|--------|
| Model | AMD Ryzen 5 7500F 6-Core |
| Cores / threads | 6 / 12 |

## GPU

| Item | Value |
|------|--------|
| Discrete | **NVIDIA GeForce RTX 4060 Ti** |
| iGPU | None (7500F) |
| Bare-metal driver target | `nvidia-open-dkms` or operator-validated proprietary stack |

## Motherboard

| Item | Value |
|------|--------|
| Vendor / product | *(not returned in non-elevated query — collect in elevated session before install)* |

## Network

| Adapter | Type |
|---------|------|
| Realtek PCIe GbE Family Controller | Ethernet |
| Realtek RTL8723B Wireless LAN 802.11n USB 2.0 | Wi-Fi |

## Storage (Windows view)

| Partition | Size | Notes |
|-----------|------|-------|
| EFI System | ~100 MB | Disk 0 part 1 |
| Microsoft reserved | 16 MB | |
| **C:** | ~931 GB | Primary Windows system |
| Recovery | ~860 MB | |

Unallocated space for Arch: **NOT measured** — requires elevated disk management before install planning.

## Firmware / security (requires elevation)

| Item | Status |
|------|--------|
| Secure Boot | Query denied (non-admin) — verify before archinstall |
| BitLocker C: | Query denied (non-admin) — verify before dual-boot |

## Pre-install checklist (future sprint)

- [ ] Elevated inventory: motherboard, unallocated space, Secure Boot state
- [ ] BitLocker suspend or recovery key documented
- [ ] Windows recovery media available
- [ ] NVIDIA driver plan validated on live ISO or archinstall
- [ ] Wi-Fi firmware if headless install needed

RESULT: Planning baseline sufficient for WS-2 audit · full install gate remains separate
