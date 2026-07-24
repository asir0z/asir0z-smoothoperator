# SmoothOperator™

Operator engineering platform — Windows, Linux, and shared certification/evidence.

Separate from [asir0z-devopslab](https://github.com/asir0z/asir0z-devopslab) (production infrastructure laboratory).

```text
SmoothOperator™
├── windows/     WIN-0, WIN-1, WIN-1A, WIN-2.5, …
├── linux/       WS-1 (FROZEN), WS-2, …
├── mac/         MAC-1 operator console bootstrap
├── shared/
│   ├── architecture/    platform architecture decisions
│   ├── evidence/        raw audit output, logs, screenshots
│   └── certification/   reviewer decisions (WS-1.md, WIN-0.md, MAC-1.md, …)
└── scripts/     operational helpers (migration completion)
```

---

## Status

**Canonical:** [`shared/certification/PLATFORM-STATE.md`](shared/certification/PLATFORM-STATE.md)

```text
Foundation · Governance · Lifecycle · Migration  →  FROZEN ✅
Execution  →  ACTIVE (WIN-1 OPEN · Mission 20 Ready)
```

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

## Mac — primary operator console (target)

**MAC-1** bootstraps a **full** Mac operator console: zsh, Terminal.app, CLI toolchain, SSH, Git, Cursor, Git-tracked dotfiles, and wrappers that call Ubuntu canonical ops over SSH. No infrastructure mutation.

Mac Engineering Station documentation hierarchy (Foundation → Certification):

[`docs/README.md`](docs/README.md)

```bash
# On the Mac:
cd ~/Projects/asir0z-smoothoperator
bash scripts/bootstrap/mac-bootstrap.sh
bash scripts/bootstrap/mac-verify.sh | tee shared/evidence/mac-1/verification-$(date +%Y%m%d).txt
```

Missions: [`shared/missions/README.md`](shared/missions/README.md) · Package: [`mac/mac-1-operator-console/`](mac/mac-1-operator-console/) · Architecture: [`shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md)

---

## Windows roadmap

```text
Migration FROZEN ✅ → WIN-1 (Core ∥ Infra) 🟢 → MAC-1 → WIN-2.5 → WS-2 → Mission 20 → WIN-1A
```

| Sprint | Doc |
|--------|-----|
| **P0** | `P0-CLOSEOUT.md` · `shared/certification/MIGRATION.md` |
| Transition VM | `shared/evidence/win-1a/TRANSITION-INFRASTRUCTURE-REPORT.md` |
| WIN-1 | `shared/certification/WIN-1.md` |
| **MAC-1** | `mac/mac-1-operator-console/` · `shared/certification/MAC-1.md` |
| WIN-2.5 | `shared/certification/WIN-2.5.md` · `windows/win-2.5-workflow-convergence/` |
| WIN-1A | `windows/win-1-baseline/WIN-1A-TRANSITION-VM-REMOVAL.md` |
| Mission 20 | `asir0z-devopslab/missions/phase-2/MISSION-20-PRODUCTION-RUNTIME-MIGRATION.md` |
| WS-2 | Sprint 2 APPROVED — see `shared/evidence/ws-2/sprint-2/` |

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

See `MIGRATION.md` (historical checklist). Migration **FROZEN ✅** — see [`shared/certification/MIGRATION.md`](shared/certification/MIGRATION.md).
