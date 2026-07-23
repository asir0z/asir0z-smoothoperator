# WS-2 Sprint 1 — Bare-Metal Portability Review

Inspected: `linux/arch-workstation/` · guest `~/.config/hypr/` · bootstrap paths · SSH template

| Dependency | Classification | Notes |
|------------|----------------|-------|
| `linux/arch-workstation/apply-config.sh` | **Shared** | Auto-detects vm vs baremetal |
| `hyprland.base.conf` | **Shared** | Keybinds, TR keyboard |
| `hyprland.vm.conf` | **VM profile** | WLR software render env vars |
| `hyprland.baremetal.conf` | **Bare-metal profile** | GPU driver notes only |
| `~/Projects/asir0z-smoothoperator` | **Shared** | Mirrors Windows C:\Projects |
| Git global identity | **Shared** | Asır · asir01oz@gmail.com |
| `gh auth` credential helper | **Shared** | User layer · not in bootstrap scripts |
| `/mnt/bootstrap` vboxsf mount | **VM profile** | Bare metal uses repo path only |
| `vboxservice` / vboxsf | **VM profile** | Remove on bare metal |
| `Host devops-lab` 127.0.0.1:2222 | **VM profile** | Replace with Tailscale/direct on bare metal |
| `Host contabo` | **Shared** | Operator production access |
| Hardcoded username `asir0z` | **Shared** | Intentional operator convention |
| VirtualBox NAT 10.0.2.15 | **VM profile** | Not referenced in shared config |
| Hyprland software render | **VM profile** | Not in baremetal profile |

## Refactor status

Shared configuration does **not** require VirtualBox. VM-specific items isolated to:

- `hyprland.vm.conf`
- bootstrap mount workflow (optional on bare metal)
- devops-lab SSH alias

## Target bare-metal flow (unchanged)

```text
Install Arch → clone ~/Projects/asir0z-smoothoperator → apply-config.sh (baremetal) → daily use
```

RESULT: PASS — portability model sound; VM profile separation in place
