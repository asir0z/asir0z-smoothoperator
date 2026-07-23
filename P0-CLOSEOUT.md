# P0 Close-out — Operator Checklist

> **Priority:** **1** — no new execution sprint until Migration **100% · FROZEN**  
> **Discipline:** Do not start WIN-1 mutations on a 95% migration.

```text
Rename → Remote → Push → Validation → Migration 100% → FROZEN
```

---

## Step 0 — Release the lock

Close **all** Cursor windows and terminals using:

```text
C:\Projects\asir0z-engineering-platform
```

---

## Step 1 — Rename + local validation

```powershell
& C:\Projects\asir0z-engineering-platform\scripts\complete-migration.ps1
```

Or manually:

```powershell
cd C:\Projects
Rename-Item asir0z-engineering-platform asir0z-smoothoperator
Test-Path C:\Projects\asir0z-smoothoperator\.git   # True
```

---

## Step 2 — GitHub

Create or rename repo → **`asir0z-smoothoperator`** (preserve history — do not create duplicate).

```powershell
cd C:\Projects\asir0z-smoothoperator
git remote add origin https://github.com/asir0z/asir0z-smoothoperator.git
# or: git remote set-url origin ...
git push -u origin master
```

---

## Step 3 — Reviewer validation (paste output)

```powershell
cd C:\Projects\asir0z-smoothoperator
git status
git remote -v
git branch -vv
git log --oneline -5
Test-Path C:\Projects\asir0z-smoothoperator\.git
```

---

## Step 4 — FROZEN

Reviewer updates `shared/certification/MIGRATION.md`:

```text
STATUS: 100% COMPLETE · FROZEN
```

Reopen Cursor on **`C:\Projects\asir0z-smoothoperator`** only.

---

## Then (in order)

```text
WIN-1 Core + Infrastructure (parallel)
Mission 20 Specification Review
Contabo Runtime Migration
```

---

*SmoothOperator™ · operational close-out only*
