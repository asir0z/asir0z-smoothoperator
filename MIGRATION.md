# Migration — engineering-platform → SmoothOperator™

**Date:** 2026-07-23

## What changed

| Before | After |
|--------|--------|
| Repo folder `asir0z-engineering-platform` | `asir0z-smoothoperator` |
| `bootstrap/` | `linux/bootstrap/` |
| `install/` | `linux/install/` |
| `bootstrap/base-install.md` | `linux/arch-vm/base-install.md` |
| (none) | `shared/evidence/ws-1/` |
| (none) | `windows/win-0-audit/` |

WS-1 script behavior unchanged. Guest path remains `/mnt/bootstrap/*`.

## Operator checklist

### 1. Local folder

Target canonical path:

```text
C:\Projects\asir0z-smoothoperator
```

If rename is blocked (Cursor lock), a **junction** may point `asir0z-smoothoperator` → `asir0z-engineering-platform` until reboot. Close IDE/terminals, then:

```powershell
Rename-Item C:\Projects\asir0z-engineering-platform C:\Projects\asir0z-smoothoperator
```

### 1b. VirtualBox bootstrap path (interim)

If shared folder still maps to `...\engineering-platform\bootstrap`, a junction links it to `linux\bootstrap`:

```powershell
cmd /c mklink /J "C:\Projects\asir0z-engineering-platform\bootstrap" "C:\Projects\asir0z-engineering-platform\linux\bootstrap"
```

Update to final path when VM is powered off (see §3).

### 2. GitHub (when remote exists)

Rename repository on GitHub: `asir0z-engineering-platform` → `asir0z-smoothoperator`

Then:

```powershell
cd C:\Projects\asir0z-smoothoperator
git remote set-url origin git@github.com:asir0z/asir0z-smoothoperator.git
git push -u origin master
```

### 3. VirtualBox shared folder

VM **powered off**:

```powershell
$VBox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
& $VBox sharedfolder remove "Arch-Engineering-Workstation" --name bootstrap 2>$null
& $VBox sharedfolder add "Arch-Engineering-Workstation" `
  --name bootstrap `
  --hostpath "C:\Projects\asir0z-smoothoperator\linux\bootstrap" `
  --automount
```

Share name stays `bootstrap` — WS-1 guest commands unchanged.

### 4. SSH config

No change: `Host arch-ws` → `127.0.0.1:2223`

## Validation

- [ ] `git log --oneline` shows full history
- [ ] `linux/bootstrap/run-ws1-system.sh` exists
- [ ] `shared/evidence/ws-1/verification.txt` shows PASS
- [ ] VBox shared folder host path updated
- [ ] `ssh arch-ws` works
