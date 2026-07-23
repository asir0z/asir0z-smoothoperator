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
✅ Phase A (admin)
✅ Disk shrink plan (operator-approved)
✅ Windows online shrink attempted — exhausted (EDR)
⏸️ Offline NTFS shrink → partition validation
```

---

## Installation roadmap

```text
────────────────────────────
PHASE 1 — PREP (Windows, no rush)
────────────────────────────

1. BIOS/UEFI checklist          ✅ Phase A
2. Offline C: shrink + unallocated (Windows online exhausted — see decisions/)
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
| Prep | [bios-uefi-checklist.md](bios-uefi-checklist.md) | ✅ Phase A complete |
| Prep | [disk-shrink-plan.md](disk-shrink-plan.md) | ✅ Operator-approved |
| Prep | [shrink-evidence.txt](shrink-evidence.txt) | ✅ Online attempt recorded |
| Decision | [decisions/WINDOWS-ONLINE-SHRINK-EXHAUSTED.md](decisions/WINDOWS-ONLINE-SHRINK-EXHAUSTED.md) | ✅ Accepted |
| Install | [arch-install-spec.md](arch-install-spec.md) | ✅ **Canonical install spec** |
| Install | [installation-evidence/](installation-evidence/) | ⏸️ Install day |
| Archive | [CURSOR-SESSION-ARCHIVE-da3c00b3.md](../working-notes/CURSOR-SESSION-ARCHIVE-da3c00b3.md) | ✅ Full Cursor chat summary |

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

## Next actions

**Parallel tracks:**

1. **Operator:** Offline NTFS shrink → partition validation → evidence update
2. **Repo:** ✅ [arch-install-spec.md](arch-install-spec.md) — install after offline shrink PASS

See [disk-shrink-plan.md](disk-shrink-plan.md) · [bios-uefi-checklist.md](bios-uefi-checklist.md).

**Archive:** [CURSOR-SESSION-ARCHIVE-da3c00b3.md](../working-notes/CURSOR-SESSION-ARCHIVE-da3c00b3.md)

---

*SmoothOperator™ · bare-metal readiness · evidence-driven · reproducible*
