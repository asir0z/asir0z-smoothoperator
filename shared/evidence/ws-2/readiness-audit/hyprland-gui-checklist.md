# WS-2 Sprint 1 — Hyprland GUI Checklist

> Remote signals collected via SSH · interactive items require operator GUI confirmation

## Remote verification (2026-07-23)

| Check | Signal | Result |
|-------|--------|--------|
| SDDM running | `systemctl is-active sddm` → active | ✅ |
| Hyprland session | `pgrep start-hyprland` · session 19 user asir0z seat0 | ✅ |
| Terminal (kitty) | Configured Win+Enter · operator used kitty in prior session | ✅ (operator) |
| App launcher (wofi) | Configured Win+E | ⏸️ operator confirm |
| Browser | chromium 150.x installed (`/usr/bin/chromium`) | ✅ package present |
| Network in session | ping/github OK from SSH | ✅ |

## Operator interactive (not fully audited remotely)

| Check | Status |
|-------|--------|
| SDDM login succeeds | ✅ operator logged in this session |
| Hyprland starts without crash | ✅ remote signals OK |
| Clipboard bidirectional | ⏸️ confirm in GUI |
| Keyboard layout TR | ⏸️ confirm in GUI (config: tr,us) |
| Audio | ⏸️ confirm in GUI |
| Logout / reboot | ⏸️ not re-tested this audit |

## VM-specific limitation (accepted)

```text
Hyprland animation / rendering stutter under VirtualBox
Classification: VM-SPECIFIC · ACCEPTED LIMITATION
Does NOT fail readiness
```

## Config errors

Prior session fixed Hyprland 0.56 incompatibilities (`pseudotile`, `togglesplit`).
Modular config now managed by `linux/arch-workstation/apply-config.sh`.

## Result

**PASS WITH CONDITIONS** — core GUI stack operational; clipboard/audio/layout need one operator GUI pass
