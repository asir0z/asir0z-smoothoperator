#!/usr/bin/env bash
# Collect audio verification evidence for WS-2 Sprint 2.
# Run inside Hyprland session (kitty): bash linux/arch-workstation/scripts/verify-audio.sh
set -euo pipefail

OUT="${1:-shared/evidence/ws-2/sprint-2/audio-verification.txt}"
REPO="${REPO:-$HOME/Projects/asir0z-smoothoperator}"
cd "$REPO"

{
  echo "WS-2 Sprint 2 — Audio Verification"
  echo "Collected: $(date -Iseconds)"
  echo ""
  echo "=== SESSION ==="
  echo "USER=$USER"
  echo "XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-unset}"
  echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-unset}"
  pgrep -a Hyprland || echo "WARN: Hyprland not running"
  echo ""
  echo "=== PIPEWIRE ==="
  systemctl --user is-active pipewire wireplumber pipewire-pulse
  pactl info 2>&1 | grep -E 'Server Name|Default Sink|Default Source'
  echo "--- sinks ---"
  pactl list sinks short
  echo "--- mute/volume ---"
  pactl get-sink-mute @DEFAULT_SINK@ 2>&1 || true
  pactl get-sink-volume @DEFAULT_SINK@ 2>&1 || true
  echo ""
  echo "=== PLAYBACK TEST ==="
  if pw-play --version >/dev/null 2>&1; then
    # 0.5s 440Hz tone via sox if present, else silent format test
    if command -v sox >/dev/null; then
      sox -n -t raw -r 44100 -c 1 -b 16 - trim 0.0 0.5 synth 440 sine 2>&1 | pw-play - --format s16 -r 44100 -c 1 2>&1
    else
      dd if=/dev/zero bs=44100 count=1 2>/dev/null | pw-play - --format s16 -r 44100 -c 1 2>&1
    fi
    echo "pw-play exit: $?"
  else
    echo "pw-play not found"
  fi
  echo ""
  echo "=== SINK AFTER PLAY ==="
  pactl list sinks short
  echo ""
  echo "RESULT: PASS (if default sink is Built-in Audio / ICH and pw-play exit 0)"
} | tee "$OUT"

echo "Wrote $OUT"
