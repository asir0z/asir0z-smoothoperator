# Bare-Metal Evidence — Index

> **Track:** First bare-metal Arch Linux installation  
> **Host:** ASUS PRIME A620M-K · Ryzen 5 7500F · RTX 4060 Ti · 32 GB DDR5  
> **Principle:** Evidence before action · no rush · verify before every critical change

---

## Completed prerequisites

```text
✅ SmoothOperator Sprint 2
✅ DevOps Lab Certification
✅ USB ready (ARCH_202607)
✅ Hardware audit
⏸️ BIOS/UEFI checklist (Phase A admin verify pending)
```

---

## Installation roadmap

```text
────────────────────────────
PHASE 1 — PREP (Windows, no rush)
────────────────────────────

1. BIOS/UEFI checklist          ← active
2. C: shrink + unallocated space
3. Arch bare-metal installation
4. SmoothOperator bootstrap
5. Hyprland + NVIDIA + Cursor + Git validation
6. All repos operational
7. 2–3 days daily use
8. Everything PASS

────────────────────────────
PHASE 2 — WINDOWS RESET (after Phase 1 PASS only)
────────────────────────────

9.  Windows Reset
10. Clean Windows install as secondary OS
11. Minimal apps only (games, Adobe/Office if needed, firmware tools)
```

**Windows reset is explicitly deferred** until bare-metal Arch is validated in daily use.

---

## Role separation (post-reset target)

### Arch Linux — primary development

| Role |
|------|
| Daily development |
| Cursor |
| Git |
| Docker (when needed) |
| DevOps Lab |
| Product Intelligence |
| Cortex |
| Project Pulse |
| SmoothOperator |

### Windows — secondary / utility

| Role |
|------|
| Gaming |
| Adobe / Office (if needed) |
| BIOS updates |
| Firmware utilities |
| OEM hardware software |
| Emergency fallback OS |

Arch = canonical engineering laboratory. Windows = utility + fallback — not primary dev.

---

## Evidence documents

| Phase | Document | Status |
|-------|----------|--------|
| Inventory | [hardware-audit.md](hardware-audit.md) | ✅ Complete |
| Prep | [bios-uefi-checklist.md](bios-uefi-checklist.md) | ⏸️ Phase A admin pending |
| Prep | disk-shrink-plan.md | Pending |
| Install | arch-install-spec.md | Pending |
| Install | installation-evidence/ | Pending |

---

## Engineering decisions (locked for first install)

| Topic | Decision |
|-------|----------|
| Secure Boot | **Yol 1** — disable for first install (RTX 4060 Ti + DKMS) |
| BitLocker | Suspend if on — not full disable; recovery key required |
| Fast Startup | Disable before shrink/install |
| EFI | Reuse existing ~100 MB ESP |
| VM | Reference/fallback only — no new development |

---

## Next action

Admin PowerShell → Phase A canonical four commands → checklist PASS → disk shrink plan.

See [bios-uefi-checklist.md](bios-uefi-checklist.md).

---

*SmoothOperator™ · bare-metal readiness · evidence-driven · reproducible*
