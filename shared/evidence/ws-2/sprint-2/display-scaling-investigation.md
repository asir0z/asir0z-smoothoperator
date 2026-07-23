# Display Scaling Investigation — WS-2 Sprint 2

> **Reported:** Everything suddenly looks much larger than before  
> **Collected:** 2026-07-23 post logout/login (via Hyprland runtime socket)

---

## Evidence collected

### `hyprctl monitors` (active session)

```text
Monitor Virtual-1 (ID 0):
  1920x1080@60.00000 at 0x0
  scale: 1.00
  transform: 0
  disabled: false
```

### Repository-managed configuration

```text
# linux/arch-workstation/dotfiles/hypr/hyprland.base.conf
monitor=,preferred,auto,1
```

Applied on guest matches repo exactly (`~/.config/hypr/hyprland.base.conf`).

### Git history

Monitor line unchanged since WS-1 modular config (`6a780ee` / Sprint 2 dotfiles migration `6afa57e`).  
**No repository configuration change introduced a scale increase.**

### Virtual environment

```text
systemd-detect-virt: oracle (VirtualBox)
product: VirtualBox
monitor name: Virtual-1
```

---

## Analysis

| Hypothesis | Finding |
|------------|---------|
| Hyprland monitor scale increased | **Rejected** — `scale: 1.00` |
| Repo monitor line changed | **Rejected** — same `monitor=,preferred,auto,1` since WS-1 |
| Hyprland picked higher scale factor | **Rejected** — scale remains 1.00 |
| VirtualBox display resize / host window scaling | **Plausible · VM-SPECIFIC** |
| VirtualBox guest display auto-resize after re-login | **Plausible · VM-SPECIFIC** |
| Application-level scaling (Cursor/Electron) | **Possible · operator confirm** |

The perceived size change is **not caused by a Sprint 2 repository regression**. Hyprland reports 1080p at 1× scale — consistent with prior repo policy.

---

## Classification

```text
VM-SPECIFIC · ACCEPTED FOR VALIDATION VM
Do not modify shared dotfiles for VirtualBox display ergonomics.
```

### Operator checks (VM-only, not repo-managed)

1. VirtualBox **View → Virtual Screen 1 → Scale to 100%** (or desired host zoom)  
2. VirtualBox **View → Auto-resize Guest Display** on/off comparison  
3. Cursor **Settings → Window: Zoom Level** if only IDE appears enlarged  

On bare-metal, `monitor=,preferred,auto,1` applies to physical panel — VBox `Virtual-1` behaviour does not transfer.

---

## Conclusion

**No shared configuration fix required.** Document and accept as VM display ergonomics unless operator confirms app-only scaling inside Cursor.

RESULT: **Investigation complete · no repo change**
