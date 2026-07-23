# Dotfiles Inventory — WS-2 Sprint 2

Preferred structure: `linux/arch-workstation/dotfiles/`

Apply: `bash linux/arch-workstation/apply-config.sh`

## Classification

| Item | Class | Repo path | Applied to |
|------|-------|-----------|------------|
| Hyprland base | TRANSFERABLE | dotfiles/hypr/hyprland.base.conf | ~/.config/hypr/ |
| Hyprland VM overlay | VM SPECIFIC | dotfiles/hypr/hyprland.vm.conf | ~/.config/hypr/hyprland.profile.conf |
| Hyprland bare-metal | TRANSFERABLE | dotfiles/hypr/hyprland.baremetal.conf | profile when not VM |
| Waybar | TRANSFERABLE | dotfiles/waybar/* | ~/.config/waybar/ |
| SSH template | TRANSFERABLE | dotfiles/ssh/config.template | ~/.ssh/config if missing |
| Git fragment | TRANSFERABLE | dotfiles/git/gitconfig.fragment | reference; apply-config sets globals if unset |
| Bash PATH fragment | TRANSFERABLE | dotfiles/bash/profile.d/smoothoperator-workstation.sh | ~/.config/bash/profile.d/ |
| Cursor install | TRANSFERABLE | scripts/install-cursor.sh | ~/.local/opt/cursor/ |
| Timezone script | TRANSFERABLE | scripts/set-operator-timezone.sh | system (sudo once) |

## Not in repo (by policy)

| Item | Class |
|------|-------|
| ~/.ssh/id_ed25519 | SECRET |
| ~/.config/gh/hosts.yml | SECRET / AUTH STATE |
| ~/.local/opt/cursor/Cursor.AppImage | CACHE (reinstalled by script) |
| Shell history | CACHE |
| .env files | SECRET |

## Legacy

`linux/arch-workstation/config/` superseded by `dotfiles/` in Sprint 2 — removed from repo to avoid dual source.

## Bare-metal portability

All TRANSFERABLE items apply identically after `WORKSTATION_PROFILE=baremetal bash apply-config.sh` on real hardware. VM overlay auto-selected only in virtualized environments.

RESULT: PASS
