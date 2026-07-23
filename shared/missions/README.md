# SmoothOperator™ — Missions

> Mission specifications for operator and platform work.  
> Canonical living state: [`../certification/PLATFORM-STATE.md`](../certification/PLATFORM-STATE.md)

---

**Naming:** `MAC-1`, `MAC-2`, … are **platform-independent operator missions** in SmoothOperator. They are **not** part of DevOps Lab `MISSION-XX` production numbering — keeps infra missions separate from personal operator environment setup.

## Active Mac track

| Mission | Status | Focus |
|---------|--------|-------|
| [MAC-1](MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md) | AUTHORIZED · operator execution | Full operator console baseline |
| [MAC-1 amendment](MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md) | **Approved** | Terminal · shell · scripts · remote ops |
| [MAC-2](MAC-2-DEVELOPMENT-EXPERIENCE.md) | PLANNED | Enhanced UX · Tailscale · runtimes |

Architecture: [`../architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](../architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md)

---

## Responsibility split

```text
Mac (operator console)
  ├── wrappers · aliases · local verify · Git · Cursor
  └── ssh lab → Ubuntu Server (canonical production scripts)

Arch (compute)
  └── on-demand AI / heavy workloads — not required for daily ops
```

**Rule:** Do not duplicate production logic on the Mac. Invoke server-side canonical scripts over SSH.

Example:

```bash
lab-health   # → ssh lab '~/scripts/ops/production-health-check.sh'
```

---

## Bootstrap entry points (repo)

| Path | Role |
|------|------|
| `scripts/bootstrap/mac-bootstrap.sh` | Full Mac operator bootstrap |
| `scripts/bootstrap/mac-packages.sh` | Homebrew package set |
| `scripts/bootstrap/mac-verify.sh` | Evidence collector |
| `scripts/ops/*.sh` | Local + remote operator wrappers |
| `shared/operator/` | Secret-free dotfiles + install |
| `mac/mac-1-operator-console/` | Mission package · setup guide (delegates to `scripts/`) |

---

## Bare-metal track

| Mission | Status | Focus |
|---------|--------|-------|
| [OFFLINE-1](OFFLINE-1-NTFS-SHRINK.md) | **AUTHORIZED** | Arch ISO offline NTFS shrink → unallocated space |

```text
Windows online shrink exhausted (EDR)
→ OFFLINE-1 (Arch ISO · ntfsresize + parted)
→ gate PASS → Bare-Metal Prep COMPLETE
→ arch-install-spec.md
→ Arch installation
```

Mac bootstrap proceeds independently.

---

*SmoothOperator™ · Missions*
