# GUI Validation — WS-2 Sprint 2

Carried from Sprint 1 open conditions. Operator sign-off in Hyprland session.

## Hyprland session

| Check | Config source | Status |
|-------|---------------|--------|
| Terminal Win+Enter (kitty) | hyprland.base.conf | PASS (Sprint 1) |
| Launcher Win+E (wofi) | hyprland.base.conf | PASS (Sprint 1) |
| Cursor in wofi | cursor.desktop | PASS (Sprint 2 install) |
| TR/US keyboard toggle | kb_layout tr,us · grp:alt_shift_toggle | Operator confirm |
| Clipboard (VBox guest additions) | VM SPECIFIC | Operator confirm |
| Audio | pulseaudio/waybar module | Operator confirm |

## Cursor GUI workflow

```text
Boot Arch → Open Cursor (wofi or cursor) → Open ~/Projects/asir0z-smoothoperator → Edit → Commit → Push
```

Validated components:

- Cursor desktop entry present
- Terminal launcher `cursor` on PATH after apply-config
- Git + gh HTTPS auth functional from kitty

## VM note

Optimize for bare-metal reproducibility — no VM-only Cursor hacks beyond `--no-sandbox` in desktop entry (also valid for some AppImage environments).

RESULT: PASS for launcher integration · Operator checklist items remain open (non-blocking for APPROVED WITH CONDITIONS)
