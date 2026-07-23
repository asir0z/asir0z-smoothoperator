# Migration — engineering-platform → SmoothOperator™

> **Status:** **100% COMPLETE · CERTIFIED · FROZEN** · see [`shared/certification/MIGRATION.md`](shared/certification/MIGRATION.md)

**Date:** 2026-07-23

## Canonical names

| Context | Name |
|---------|------|
| Product | **SmoothOperator™** |
| Repository | **asir0z-smoothoperator** |
| Legacy | `engineering-platform` — this document only |

## What changed

| Before | After |
|--------|--------|
| Repo folder `asir0z-engineering-platform` | `asir0z-smoothoperator` |
| `bootstrap/` | `linux/bootstrap/` |
| `install/` | `linux/install/` |
| `bootstrap/base-install.md` | `linux/arch-vm/base-install.md` |
| (none) | `shared/evidence/` + `shared/certification/` |
| (none) | `windows/win-0-audit/` |

WS-1 script behavior unchanged. Guest path remains `/mnt/bootstrap/*`.

---

## Operator sequence

### Step 1 — Local rename (operational)

Close **all** Cursor windows and terminals using `C:\Projects\asir0z-engineering-platform`.

```powershell
cd C:\Projects
Rename-Item asir0z-engineering-platform asir0z-smoothoperator
Test-Path C:\Projects\asir0z-smoothoperator\.git   # must be True
```

Or run the bundled script:

```powershell
& C:\Projects\asir0z-engineering-platform\scripts\complete-migration.ps1
# (script renames, validates paths, updates VBox shared folder)
```

### Step 2 — Local validation

```powershell
cd C:\Projects\asir0z-smoothoperator
git status
git log --oneline -3
Test-Path linux/bootstrap/run-ws1-system.sh
Test-Path shared/evidence/ws-1/verification.txt
Test-Path shared/certification/WIN-0.md
```

VBox (Arch VM powered off):

```powershell
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" showvminfo "Arch-Engineering-Workstation" |
  Select-String "Shared folders" -Context 0,3
# Host path must be: C:\Projects\asir0z-smoothoperator\linux\bootstrap
```

### Step 3 — GitHub (after local validation)

Create or rename repository on GitHub → **`asir0z-smoothoperator`**

Do **not** create a second repo; preserve history on the existing remote if one exists.

```powershell
cd C:\Projects\asir0z-smoothoperator
git remote add origin https://github.com/asir0z/asir0z-smoothoperator.git
# or: git remote set-url origin ...
git push -u origin master
```

### Step 4 — Reopen workspace

Open Cursor on `C:\Projects\asir0z-smoothoperator` only.

Update `shared/certification/MIGRATION.md` → **100% COMPLETE**.

---

## SSH config

No change: `Host arch-ws` → `127.0.0.1:2223`

## Validation checklist

- [ ] `Test-Path C:\Projects\asir0z-smoothoperator\.git`
- [ ] `linux/bootstrap/run-ws1-system.sh` exists
- [ ] `shared/evidence/ws-1/verification.txt` shows PASS
- [ ] VBox shared folder host path updated
- [ ] `git remote -v` → `asir0z-smoothoperator`
- [ ] `git push -u origin master` succeeded
- [ ] `ssh arch-ws` works (after Arch VM start)
