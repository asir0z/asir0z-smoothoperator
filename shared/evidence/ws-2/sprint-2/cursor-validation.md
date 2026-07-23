# Cursor Validation — WS-2 Sprint 2

## Installation

| Check | Result |
|-------|--------|
| Canonical path `~/.local/opt/cursor/Cursor.AppImage` | PASS |
| Terminal launcher `~/.local/bin/cursor` | PASS |
| Desktop entry `cursor.desktop` | PASS |
| Version file (3.12.30) | PASS |
| Reproducible script in repo | PASS |

## Launch surfaces

| Surface | Expected | Result |
|---------|----------|--------|
| Terminal `cursor .` | Opens repo in Cursor | PASS (PATH via dotfiles bash fragment) |
| wofi (Win+E) | Cursor in drun list | PASS (desktop entry) |
| Desktop applications | Cursor icon | PASS |

## Integrated tooling

| Check | Result |
|-------|--------|
| Git in PATH | PASS (git 2.55.0) |
| gh authenticated | PASS (HTTPS) |
| Repository open `~/Projects/asir0z-smoothoperator` | PASS |

## Headless limitation

`Cursor.AppImage --version` over SSH without DISPLAY segfaults. This is not a failed install — GUI launch in Hyprland session is the validation path.

## Operator GUI confirmation (Sprint 2 closure)

- [x] Clipboard — VBox bidirectional (host) + `VBoxClient --wayland` (guest VM profile)
- [x] Audio — guest PipeWire pipeline PASS ([audio-validation.md](audio-validation.md)); host VBox playback off is VM-SPECIFIC
- [x] Keyboard TR/US toggle — `tr,us` · `grp:alt_shift_toggle` · active Turkish

RESULT: PASS — install, launcher integration, and GUI checklist closed
