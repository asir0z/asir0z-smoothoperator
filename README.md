# SmoothOperator™

Operator engineering platform — Windows, Linux, and shared certification/evidence.

Separate from [asir0z-devopslab](https://github.com/asir0z/asir0z-devopslab) (production infrastructure laboratory).

```text
SmoothOperator™
├── windows/     WIN-0, WIN-1, …
├── linux/       WS-1 (FROZEN), WS-2, …
└── shared/      evidence, certification records
```

---

## Linux — Arch workstation

**VM:** `Arch-Engineering-Workstation` · SSH: `ssh arch-ws` (`127.0.0.1:2223`)

| Sprint | Status |
|--------|--------|
| **WS-1** Developer Stack | ✅ FROZEN — see `shared/evidence/ws-1/` |
| **WS-2** Developer Experience | ⏸️ after WIN-1 |

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

VBox share `bootstrap` → host path `...\asir0z-smoothoperator\linux\bootstrap\`

---

## Windows

| Sprint | Status |
|--------|--------|
| **WIN-0** Current State Audit | 📋 spec — `windows/win-0-audit/` |
| **WIN-1** Engineering Baseline | 📋 spec — `windows/win-1-baseline/` |
| **WIN-1.1** Legacy VM removal (`DevOps-Lab-Ubuntu`) | ⏸️ blocked until Contabo Host Acceptance (DevOps Lab gate) |

---

## Not installed by WS-1

- Docker / Podman on workstation
- Cloud CLIs
- Language version managers (fnm, pyenv)
- Dotfiles / Hyprland rice
- Merge into DevOps Lab

---

## Repository migration (2026-07-23)

Renamed from `asir0z-engineering-platform` → `asir0z-smoothoperator`.  
If VirtualBox shared folder still points at the old host path, update (VM powered off):

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" sharedfolder add "Arch-Engineering-Workstation" `
  --name bootstrap --hostpath "C:\Projects\asir0z-smoothoperator\linux\bootstrap" --automount
```

See `MIGRATION.md` for full checklist.
