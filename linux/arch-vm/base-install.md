# Base Arch install (operator session)

Run on live ISO after VM boots. Prefer **`archinstall`** (guided).

## Recommended preset

| Setting | Value |
|---------|--------|
| Disk | Entire VDI (~64 GB) |
| Filesystem | ext4 (simple) or btrfs (snapshots later) |
| Hostname | `arch-workstation` |
| User | `asir0z` (wheel) |
| Profile | Minimal — **no desktop yet** |
| Network | DHCP (NAT) |
| Multilib | yes (future 32-bit if needed) |

After reboot, verify:

```bash
ping -c 2 archlinux.org
sudo pacman -Syu
```

Then SSH server for Cursor/operator access:

```bash
sudo pacman -S openssh
sudo systemctl enable --now sshd
ip a
```

Record `ip` from NAT — port-forward from host if needed (same pattern as DevOps Lab NAT :2222).

Hyprland and developer stack come **after** base system boots reliably.

```bash
# shared folder: /mnt/bootstrap → host .../linux/bootstrap/
sudo bash /mnt/bootstrap/hyprland-stack.sh
sudo reboot
```

Log in via SDDM → Hyprland. SSH stays on host `:2223`.

WS-1 (FROZEN): `sudo bash /mnt/bootstrap/run-ws1-system.sh` — see `shared/evidence/ws-1/`.
