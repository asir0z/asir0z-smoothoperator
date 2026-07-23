# Audio Validation — WS-2 Sprint 2

> **Collected:** 2026-07-23T19:54:45Z (UTC) · Arch-Engineering-Workstation (VirtualBox)  
> **Operator session:** Hyprland · asir0z

## Question

Why is audio unavailable (inaudible) inside the Arch VM?

## Guest stack (this session)

| Check | Result |
|-------|--------|
| Virt | VirtualBox (`oracle` / innotek GmbH) |
| PipeWire | 1.6.8 · `pipewire.service` active |
| WirePlumber | 0.5.15 · active · enabled |
| pipewire-pulse | active (socket-enabled) |
| Default sink | `alsa_output.pci-0000_00_05.0.analog-stereo` |
| Mute | **no** |
| Volume | 40% (`wpctl` 0.40) |
| ALSA card | Intel 82801AA-ICH AC'97 (`snd_intel8x0`) |
| PCI | `00:05.0` Intel 82801AA AC'97 Audio Controller |
| `/dev/snd` ACL | session user `asir0z` rw on pcm/control |
| `paplay` 440 Hz WAV | exit **0** · sink SUSPENDED → IDLE |
| Journal errors | none (RTKit/BlueZ/UPower warnings only — non-blocking) |

Packages present: `pipewire` · `wireplumber` · `pipewire-pulse` · `pipewire-alsa`.  
`alsa-utils` not installed (optional; PipeWire path sufficient).

## Host evidence (pre-existing)

From [`shared/evidence/win-0/windows-health-report-20260723.md`](../../win-0/windows-health-report-20260723.md) — Arch-Engineering-Workstation:

```text
Audio | Null/AC97 (enabled, playback off)
```

## Root cause

```text
Guest PipeWire/ALSA pipeline: OPERATIONAL
Host VirtualBox Audio Output: OFF (playback disabled)
```

Inaudible speakers are explained by the **Windows host VirtualBox setting**, not by missing or broken Arch audio configuration.

Classification: **VM-SPECIFIC · HOST SETTING** (same class as display/VirtualBox observation).

## Changes applied (guest / repo)

**None** for audio.

No PipeWire/WirePlumber/dotfiles/bootstrap changes. Shared configuration must not be altered for host VirtualBox playback state.

## Operator host action (optional audible confirm)

On Windows host:

```text
VirtualBox → Arch-Engineering-Workstation → Settings → Audio
  → enable Audio Output (playback)
```

Then re-run `paplay` / waybar volume test. Does **not** require Arch repo change.

## Decision

```text
Audio (guest pipeline)     PASS
Audible host speakers      blocked by VBox playback=off (documented)
Arch config change         NOT INDICATED
```

RESULT: **PASS** — guest validated; inaudible output is host VirtualBox playback off.
