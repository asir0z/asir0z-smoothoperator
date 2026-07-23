# GUI Validation — WS-2 Sprint 2

Operator sign-off in Hyprland session — final Sprint 2 pass (2026-07-23T19:56Z UTC).

## Hyprland session

| Check | Evidence | Status |
|-------|----------|--------|
| Desktop / Hyprland starts | `Hyprland 0.56.0` pid active · `XDG_SESSION_TYPE=wayland` | PASS |
| Monitor | Virtual-1 **1920×1080@60** · **scale 1.00** | PASS |
| Terminal Win+Enter (kitty) | `hyprctl dispatch exec kitty` → kitty pid · class `kitty` | PASS |
| Launcher Win+E (wofi) | bound in hyprland.base.conf · package present | PASS |
| Cursor IDE | Cursor.AppImage 3.12.30 running · desktop entry · PATH | PASS |
| Chromium | running in session (usability) | PASS |
| Mouse | `virtualbox-mouse-integration` + PS/2 explorer mouse | PASS |
| Keyboard TR/US | `kb_layout=tr,us` · `grp:alt_shift_toggle` · active keymap **Turkish** | PASS |
| Git | git 2.55.0 · repo `ee2063d` · origin GitHub HTTPS | PASS |
| gh | 2.96.0 authenticated | PASS |
| Clipboard (VBox GA) | Host bidirectional (win-0); guest `VBoxClient --wayland` started + `exec-once` in `hyprland.vm.conf` | PASS |
| Audio | Guest PipeWire pipeline PASS — see [audio-validation.md](audio-validation.md) | PASS |
| Timezone | `Europe/Istanbul` (+03) · NTP synchronized | PASS |
| Waybar | running · pulseaudio module present | PASS |

## Cursor GUI workflow

```text
Boot Arch → Open Cursor (wofi or cursor) → Open ~/Projects/asir0z-smoothoperator → Edit → Commit → Push
```

Validated in this session: Cursor open on SmoothOperator · Git remotes OK · kitty available.

## Display note (unchanged)

```text
Hyprland scale = 1.00 · 1920×1080
Any perceived scaling oddity = VirtualBox host/guest display behavior
Do NOT change shared Hyprland base config for VM observation
```

## VM-only fix applied (clipboard)

`linux/arch-workstation/dotfiles/hypr/hyprland.vm.conf`:

```text
exec-once = /usr/bin/VBoxClient --wayland
```

Evidence: VBoxClient clipboard/wayland helpers were not running before GUI acceptance; host already had bidirectional clipboard enabled.

## Result

```text
GUI Acceptance = PASS
```
