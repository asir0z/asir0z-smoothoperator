# GUI Validation — WS-2 Sprint 2

> **Date:** 2026-07-23  
> **Purpose:** Operator acceptance test for WS-2 Sprint 2 certification

---

## Current status

| Area | Status |
|------|--------|
| Windows sync | PASS (`ee2063d`) |
| Keyboard config | PASS (repo + hyprctl — see [keyboard-verification.txt](keyboard-verification.txt)) |
| Display investigation | PASS (VM-specific observation — see [display-scaling-investigation.md](display-scaling-investigation.md)) |
| Timezone | PASS (`Europe/Istanbul` — see [timezone-verification.txt](timezone-verification.txt)) |
| Evidence | Updated |
| GUI interactive tests | **Operator pending** |
| Certification | **Pending GUI completion** |

---

## Automated verification (complete)

Remote checks collected via SSH and Hyprland runtime socket:

| Check | Result |
|-------|--------|
| Hyprland session active | PASS |
| Cursor installed (`~/.local/opt/cursor/`) + launchers | PASS |
| Keyboard: `tr,us` · `grp:alt_shift_toggle` | PASS |
| Monitor: 1920×1080 · scale 1.00 | PASS (no repo regression) |
| Timezone `Europe/Istanbul` | PASS |

Detailed evidence: [keyboard-verification.txt](keyboard-verification.txt) · [timezone-verification.txt](timezone-verification.txt) · [display-scaling-investigation.md](display-scaling-investigation.md)

---

## Operator acceptance test (pending)

Mark each item **PASS** or **FAIL** after real use in Hyprland session.

| # | Test | Status |
|---|------|--------|
| 1 | Cursor launches (wofi or terminal) | ⏸️ |
| 2 | Opens `~/Projects/asir0z-smoothoperator` | ⏸️ |
| 3 | Clipboard: `Ctrl+Shift+C` / `Ctrl+Shift+V` in terminal | ⏸️ |
| 4 | Clipboard: Cursor ↔ Terminal | ⏸️ |
| 5 | Turkish keyboard: `ğüşiöç` | ⏸️ |
| 6 | `Alt+Shift` toggles TR ↔ US | ⏸️ |
| 7 | US keyboard: `[]{}@#` | ⏸️ |
| 8 | Audio (test sound or video playback) | ⏸️ |
| 9 | Reboot → Hyprland starts | ⏸️ |
| 10 | Reboot → keyboard layout preserved | ⏸️ |
| 11 | Reboot → timezone still `Europe/Istanbul` | ⏸️ |
| 12 | Reboot → Cursor launches · repo accessible | ⏸️ |

---

## Observation — display scaling (not a certification criterion)

Operator reported UI appearing larger after re-login. Investigation confirmed Hyprland scale 1.00 at 1920×1080; repository monitor config unchanged. Classified **VM-specific** (VirtualBox display / host scaling). No shared dotfiles change required.

---

## Overall status

```text
PENDING — operator acceptance test incomplete
```

When all items in **Operator acceptance test** are PASS, replace this section with:

```text
PASS

WS-2 Sprint 2 is ready for certification review.

Outstanding issues:
None.

Interactive GUI validation completed.
Evidence complete.
```

Then commit evidence (`docs(ws-2): finalize sprint-2 validation evidence`) and request DevOps Lab certification review.
