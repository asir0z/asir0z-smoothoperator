# Arch Workstation — operator config

> **Status:** Active on VM · bare-metal **deferred**  
> **Host target:** Same PC as Windows (Ryzen 5 7500F · 32 GB · NVMe dual-boot planned)

Config lives in repo so VM and future bare-metal share one source of truth.

---

## Paths (Windows parity)

| Windows | Arch (canonical) |
|---------|------------------|
| `C:\Projects\asir0z-smoothoperator` | `~/Projects/asir0z-smoothoperator` |
| `C:\Projects\asir0z-devopslab` | `~/Projects/asir0z-devopslab` |

User: **`asir0z`** · hostname: **`arch-workstation`** · timezone: **`Europe/Istanbul`**

---

## Apply config

```bash
cd ~/Projects/asir0z-smoothoperator
bash linux/arch-workstation/apply-config.sh
hyprctl reload    # in Hyprland session
```

Auto-detects **VM** vs **bare-metal** (`systemd-detect-virt`).

Force profile:

```bash
WORKSTATION_PROFILE=vm bash linux/arch-workstation/apply-config.sh
WORKSTATION_PROFILE=baremetal bash linux/arch-workstation/apply-config.sh
```

---

## Layout

```text
linux/arch-workstation/
├── apply-config.sh
├── BAREMETAL-READINESS.md
└── config/
    ├── hypr/
    │   ├── hyprland.base.conf      # shared keybinds, TR keyboard
    │   ├── hyprland.vm.conf        # VirtualBox software render
    │   └── hyprland.baremetal.conf # GPU — empty until install
    ├── ssh/config.template
    └── waybar/
```

---

## Hyprland quick reference

| Key | Action |
|-----|--------|
| **Win + Enter** | Terminal (kitty) |
| **Win + E** | App launcher (wofi) |
| **Win + Q** | Close window |
| **Win + M** | Logout |

---

*SmoothOperator™ · WS-1 frozen · WS-2 friction-driven*
