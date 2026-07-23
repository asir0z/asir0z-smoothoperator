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

## Cursor

```bash
bash linux/arch-workstation/scripts/install-cursor.sh
cursor ~/Projects/asir0z-smoothoperator
```

Canonical install: `~/.local/opt/cursor/Cursor.AppImage` · launcher: `~/.local/bin/cursor`

---

## Layout

```text
linux/arch-workstation/
├── apply-config.sh
├── BAREMETAL-READINESS.md
├── dotfiles/
│   ├── hypr/
│   ├── waybar/
│   ├── ssh/
│   ├── git/
│   └── bash/
└── scripts/
    ├── install-cursor.sh
    └── set-operator-timezone.sh
```

---

## Hyprland quick reference

| Key | Action |
|-----|--------|
| **Win + Enter** | Terminal (kitty) |
| **Win + E** | App launcher (wofi) — includes Cursor |
| **Win + Q** | Close window |
| **Win + M** | Logout |

---

*SmoothOperator™ · WS-2 Sprint 2*
