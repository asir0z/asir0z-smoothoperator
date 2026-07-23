# MAC-1 — Operator Console Bootstrap (package index)

```text
Status:       AUTHORIZED ✅ · OPERATOR EXECUTION
Canonical:    shared/missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md
Amendment:    shared/missions/MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md (Approved)
Date:         2026-07-23
```

This directory is the **operator package** (runbook + thin wrappers).  
**Authoritative mission text** lives under `shared/missions/`.

---

## Purpose

Full operator console baseline — not merely Git/Cursor:

* zsh + Terminal.app recovery
* Homebrew CLI toolchain (incl. shellcheck/shfmt/GNU helpers)
* SSH aliases · Git · Cursor · `~/Projects`
* Git-tracked dotfiles (`shared/operator`)
* Mac wrappers that call **Ubuntu canonical** ops scripts over SSH

Architecture: [`shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](../../shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md)

---

## Entry points

| Action | Command |
|--------|---------|
| Bootstrap | `bash scripts/bootstrap/mac-bootstrap.sh` |
| Packages only | `bash scripts/bootstrap/mac-packages.sh` |
| Verify / evidence | `bash scripts/bootstrap/mac-verify.sh` |
| Install dotfiles | `bash shared/operator/scripts/install-dotfiles.sh` |
| Legacy wrapper | `bash mac/mac-1-operator-console/scripts/bootstrap-mac1.sh` → delegates |

Operator runbook: [`SETUP-GUIDE.md`](SETUP-GUIDE.md)

---

## Responsibility split

```text
Mac wrappers (this repo)  →  ssh lab  →  Ubuntu ~/scripts/ops/*  (production authority)
```

Do not duplicate production logic on the Mac.

---

## Certification gate (summary)

See full checklist in the canonical mission doc and [`shared/certification/MAC-1.md`](../../shared/certification/MAC-1.md).

Amended PASS requires: zsh baseline · Terminal.app · GitHub auth · repo ops · `ssh lab` · remote script invocation · local bootstrap/verify · Git-tracked config restore · Arch not required.

---

*SmoothOperator™ · MAC-1 package index*
