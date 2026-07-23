# GUI Validation — WS-2 Sprint 2

> **Date:** 2026-07-23  
> **Purpose:** Operator acceptance test for WS-2 Sprint 2 certification

---

## Current status

| Area | Status |
|------|--------|
| Windows sync | PASS (`ee2063d` / branch `cursor/ws2-validation-evidence`) |
| Keyboard config | PASS (repo + hyprctl — see [keyboard-verification.txt](keyboard-verification.txt)) |
| Display investigation | PASS (VM-specific — see [display-scaling-investigation.md](display-scaling-investigation.md)) |
| Timezone | PASS (`Europe/Istanbul` — see [timezone-verification.txt](timezone-verification.txt)) |
| Audio investigation | PASS (root cause + host fix — see [audio-investigation.txt](audio-investigation.txt)) |
| Audio playback (Hyprland) | **PENDING** — run [verify-audio.sh](../../../linux/arch-workstation/scripts/verify-audio.sh) after SDDM login |
| GUI interactive tests | **PENDING** — requires Hyprland session (SDDM login) |
| Certification | **Pending GUI + audio playback completion** |

---

## Automated verification (complete)

Remote checks collected via SSH and Hyprland runtime socket:

| Check | Result |
|-------|--------|
| Hyprland session active (when logged in) | PASS |
| Cursor installed (`~/.local/opt/cursor/`) + launchers | PASS |
| Keyboard: `tr,us` · `grp:alt_shift_toggle` | PASS |
| Monitor: 1920×1080 · scale 1.00 | PASS (no repo regression) |
| Timezone `Europe/Istanbul` | PASS (survives reboot — SSH verify 2026-07-23) |
| VirtualBox audio host fix | PASS (`audio=default`, `audio_out=on`) |
| Guest PipeWire stack | PASS (active when user session running) |

Detailed evidence: [keyboard-verification.txt](keyboard-verification.txt) · [timezone-verification.txt](timezone-verification.txt) · [display-scaling-investigation.md](display-scaling-investigation.md) · [audio-investigation.txt](audio-investigation.txt) · [audio-verification.txt](audio-verification.txt)

---

## Operator acceptance test (pending)

Mark each item **PASS** or **FAIL** after real use in Hyprland session (SDDM login required after boot).

| # | Test | Status |
|---|------|--------|
| 1 | Cursor launches (wofi or terminal) | ⏸️ |
| 2 | Opens `~/Projects/asir0z-smoothoperator` | ⏸️ |
| 3 | Clipboard: `Ctrl+Shift+C` / `Ctrl+Shift+V` in terminal | ⏸️ |
| 4 | Clipboard: Cursor ↔ Terminal | ⏸️ |
| 5 | Turkish keyboard: `ğüşiöç` | ⏸️ |
| 6 | `Alt+Shift` toggles TR ↔ US | ⏸️ |
| 7 | US keyboard: `[]{}@#` | ⏸️ |
| 8 | Audio (test sound or video playback) | ⏸️ — host fix applied; run `verify-audio.sh` in Hyprland |
| 9 | Reboot → Hyprland starts | ⏸️ — SDDM greeter present; manual login required |
| 10 | Reboot → keyboard layout preserved | ⏸️ |
| 11 | Reboot → timezone still `Europe/Istanbul` | ✅ PASS (SSH after reboot: `Europe/Istanbul`) |
| 12 | Reboot → Cursor launches · repo accessible | ⏸️ |

### Operator steps to close GUI gate

1. VirtualBox → start VM (GUI) → SDDM login as `asir0z` → Hyprland
2. `cd ~/Projects/asir0z-smoothoperator && git pull`
3. `bash linux/arch-workstation/scripts/verify-audio.sh` (item 8)
4. Complete checklist items 1–7, 9–10, 12 interactively
5. Update this file → commit `docs(ws-2): finalize sprint-2 validation evidence`

---

## Observation — display scaling (not a certification criterion)

Operator reported UI appearing larger after re-login. Investigation confirmed Hyprland scale 1.00 at 1920×1080; repository monitor config unchanged. Classified **VM-specific** (VirtualBox display / host scaling). No shared dotfiles change required.

---

## Observation — audio (resolved at host)

Root cause: VirtualBox VM created with `--audio-driver none`. Guest PipeWire was healthy; playback failed with I/O error until host audio enabled via `linux/install/enable-vm-audio.ps1`. See [audio-investigation.txt](audio-investigation.txt).

---

## Overall status

```text
PENDING — operator Hyprland session required

Completed remotely:
  Engineering · timezone · keyboard config · display investigation · audio host fix · reboot timezone

Remaining:
  SDDM login → interactive GUI checklist → Hyprland audio playback confirm
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
