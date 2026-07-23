# SmoothOperator™

Operator engineering platform — Windows, Linux, and shared certification/evidence.

Separate from [asir0z-devopslab](https://github.com/asir0z/asir0z-devopslab) (production infrastructure laboratory).

```text
SmoothOperator™
├── windows/     WIN-0, WIN-1, WIN-1A, WIN-2.5, …
├── linux/       WS-1 (FROZEN), WS-2, …
├── shared/
│   ├── evidence/        raw audit output, logs, screenshots
│   └── certification/   reviewer decisions (WS-1.md, WIN-0.md, …)
└── scripts/     operational helpers (migration completion)
```

---

## Status (2026-07-23)

> **P0 Close-out is PRIORITY 1.** No execution sprint until Migration **100% · FROZEN**. See `P0-CLOSEOUT.md`.

| Initiative | Status |
|------------|--------|
| **P0** Migration close-out | ⏳ **PRIORITY 1** — `P0-CLOSEOUT.md` |
| **Migration** | 95% · APPROVED — FROZEN gate open |
| **WS-1** | ✅ CERTIFIED · FROZEN |
| **WIN-0** | ✅ APPROVED |
| **Transition Infrastructure** | ✅ APPROVED |
| **WIN-1** | 🟢 AUTHORIZED · **exec blocked** until Migration FROZEN |
| **WIN-1A** | 🚫 BLOCKED (Mission 20 + observation) |
| **WIN-2.5** | 📋 SPEC APPROVED · **WAITING FOR WIN-1** |
| **WS-2** Developer Experience | 🔒 waiting |

---

## Linux — Arch workstation

**VM:** `Arch-Engineering-Workstation` · SSH: `ssh arch-ws` (`127.0.0.1:2223`)

Bootstrap scripts: `linux/bootstrap/`  
VM install: `linux/install/create-vm.ps1`  
Spec (DevOps Lab cross-project): [DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md](https://github.com/asir0z/asir0z-devopslab/blob/main/docs/cross-project/DEVOPS-CHATGPT-WORKSTATION-DEVSTACK.md)

### WS-1 install (frozen behavior)

```bash
# system layer (root)
mount -t vboxsf bootstrap /mnt/bootstrap 2>/dev/null || true
bash /mnt/bootstrap/run-ws1-system.sh

# evidence (asir0z)
bash /mnt/bootstrap/verify/verify-ws1.sh | tee ~/ws-1-evidence.txt
```

VBox share `bootstrap` → host path `C:\Projects\asir0z-smoothoperator\linux\bootstrap\`

---

## Windows roadmap

```text
P0 FROZEN → WIN-1 (Core ∥ Infra) → WIN-2.5 → WS-2 → Mission 20 → WIN-1A
```

| Sprint | Doc |
|--------|-----|
| **P0** | `P0-CLOSEOUT.md` · `shared/certification/MIGRATION.md` |
| Transition VM | `shared/evidence/win-1a/TRANSITION-INFRASTRUCTURE-REPORT.md` |
| WIN-1 | `shared/certification/WIN-1.md` |
| WIN-2.5 | `shared/certification/WIN-2.5.md` · `windows/win-2.5-workflow-convergence/` |
| WIN-1A | `windows/win-1-baseline/WIN-1A-TRANSITION-VM-REMOVAL.md` |
| Mission 20 | `asir0z-devopslab/missions/phase-2/MISSION-20-PRODUCTION-RUNTIME-MIGRATION.md` |
| WS-2 | (pending) |

---

## Not installed by WS-1

- Docker / Podman on workstation
- Cloud CLIs
- Language version managers (fnm, pyenv)
- Dotfiles / Hyprland rice
- Merge into DevOps Lab

---

## Repository migration

Canonical name: **`asir0z-smoothoperator`** · product: **SmoothOperator™**

Legacy name `engineering-platform` appears only in migration history (`MIGRATION.md`).

**Pending (operational):** close Cursor → run `scripts/complete-migration.ps1` → GitHub create/push.

See `MIGRATION.md` and `shared/certification/MIGRATION.md`. **Close-out:** [`P0-CLOSEOUT.md`](P0-CLOSEOUT.md).
