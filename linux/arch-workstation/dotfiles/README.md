# Arch workstation dotfiles

Managed configuration for Arch development workstation (VM validation → bare-metal).

## Classification

| Path | Class | Notes |
|------|-------|-------|
| `hypr/` | TRANSFERABLE | Base + profile overlay; VM adds software render env |
| `waybar/` | TRANSFERABLE | Top bar; battery module ignored on desktop bare-metal |
| `ssh/config.template` | TRANSFERABLE | Host aliases; operator merges into `~/.ssh/config` |
| `git/gitconfig.fragment` | TRANSFERABLE | Identity + LF defaults; applied if global unset |
| `bash/profile.d/` | TRANSFERABLE | PATH for `~/.local/bin` (Cursor launcher) |
| `../scripts/install-cursor.sh` | TRANSFERABLE | Reproducible Cursor AppImage install |
| `../scripts/set-operator-timezone.sh` | TRANSFERABLE | One-time `Europe/Istanbul` (requires sudo) |

**HOST SPECIFIC:** `~/.ssh/config` after merge (IPs, NAT ports)  
**VM SPECIFIC:** `hyprland.vm.conf` software rendering env  
**SECRET:** SSH private keys, gh tokens, `.env` — never committed  
**CACHE:** AppImage download cache, Cursor state under `~/.config/Cursor`

## Apply

```bash
bash linux/arch-workstation/apply-config.sh
```
