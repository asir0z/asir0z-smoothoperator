#!/usr/bin/env bash
# Hyprland developer stack for Arch-Engineering-Workstation (VirtualBox NAT VM).
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo bash $0" >&2
  exit 1
fi

TARGET_USER="${TARGET_USER:-asir0z}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
HYPRCFG="$TARGET_HOME/.config/hypr/hyprland.conf"

echo "[1/6] packages"
pacman -Syu --noconfirm
pacman -S --needed --noconfirm \
  hyprland hyprpaper waybar wofi kitty \
  polkit-gnome \
  pipewire wireplumber pipewire-pulse pipewire-alsa \
  xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd \
  qt5-wayland qt6-wayland \
  sddm \
  inetutils git curl wget

echo "[2/6] hostname + groups"
hostnamectl set-hostname arch-workstation
usermod -aG video,input,wheel,vboxsf "$TARGET_USER"

AUTH_KEYS="$TARGET_HOME/.ssh/authorized_keys"
PUB_URL="http://10.0.2.2:8765/windows_id_ed25519.pub"
if curl -fsSL "$PUB_URL" -o /tmp/windows_id_ed25519.pub 2>/dev/null; then
  install -d -m 700 -o "$TARGET_USER" -g "$TARGET_USER" "$TARGET_HOME/.ssh"
  touch "$AUTH_KEYS"
  chown "$TARGET_USER:$TARGET_USER" "$AUTH_KEYS"
  chmod 600 "$AUTH_KEYS"
  if ! grep -qF "$(cat /tmp/windows_id_ed25519.pub)" "$AUTH_KEYS" 2>/dev/null; then
    cat /tmp/windows_id_ed25519.pub >>"$AUTH_KEYS"
  fi
fi

echo "[3/6] hyprland config"
install -d -m 755 -o "$TARGET_USER" -g "$TARGET_USER" \
  "$TARGET_HOME/.config/hypr" \
  "$TARGET_HOME/.config/waybar"

cat >"$HYPRCFG" <<'EOF'
monitor=,preferred,auto,1

env = WLR_NO_HARDWARE_CURSORS,1

exec-once = waybar
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

input {
    kb_layout = tr,us
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
}

general {
    gaps_in = 4
    gaps_out = 8
    border_size = 2
    col.active_border = rgba(89b4faff) rgba(cba6f7ff) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 8
    blur {
        enabled = true
        size = 3
        passes = 1
    }
}

animations {
    enabled = true
}

dwindle {
    pseudotile = true
    preserve_split = true
}

bind = SUPER, Return, exec, kitty
bind = SUPER, Q, killactive,
bind = SUPER, M, exit,
bind = SUPER, E, exec, wofi --show drun
bind = SUPER, P, pseudo,
bind = SUPER, J, togglesplit,
bind = SUPER, left, movefocus, l
bind = SUPER, right, movefocus, r
bind = SUPER, up, movefocus, u
bind = SUPER, down, movefocus, d
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5
bind = SUPER, mouse_down, workspace, e+1
bind = SUPER, mouse_up, workspace, e-1
bindm = SUPER, mouse:272, movewindow
bindm = SUPER, mouse:273, resizewindow
EOF

cat >"$TARGET_HOME/.config/waybar/config" <<'EOF'
{
  "layer": "top",
  "modules-left": ["hyprland/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["network", "pulseaudio", "battery", "tray"],
  "clock": { "format": "{:%H:%M %d.%m.%Y}" },
  "network": { "format-wifi": "{signalStrength}% ", "format-ethernet": "", "format-disconnected": "⚠" },
  "pulseaudio": { "format": "{volume}% " },
  "battery": { "format": "{capacity}% {icon}" }
}
EOF

cat >"$TARGET_HOME/.config/waybar/style.css" <<'EOF'
* { border: none; border-radius: 0; min-height: 0; font-family: "JetBrainsMono Nerd Font", sans-serif; font-size: 13px; }
window#waybar { background: #1e1e2e; color: #cdd6f4; }
#workspaces button.active { background: #89b4fa; color: #1e1e2e; }
EOF

chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.config"

echo "[4/6] sddm + pipewire"
systemctl enable sddm
loginctl enable-linger "$TARGET_USER"
if ! machinectl shell "${TARGET_USER}@" /bin/bash -lc 'systemctl --user enable pipewire wireplumber pipewire-pulse'; then
  echo "warn: enable pipewire user units after first graphical login if needed"
fi

echo "[5/6] sddm hyprland session"
install -d -m 755 /usr/share/wayland-sessions
cat >/usr/share/wayland-sessions/hyprland.desktop <<'EOF'
[Desktop Entry]
Name=Hyprland
Comment=Hyprland Wayland compositor
Exec=/usr/bin/Hyprland
Type=Application
DesktopNames=Hyprland
EOF

echo "[6/6] done"
echo "Reboot, then log in via SDDM as $TARGET_USER (Hyprland session)."
echo "SSH remains available on host port 2223."
