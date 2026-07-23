# WIN-2.5 Setup Guide — Engineering Workflow Convergence

> **Status:** OUTLINE — populate during **authorized execution** only  
> **Spec:** [WIN-2.5-SPEC.md](WIN-2.5-SPEC.md) · [COMPONENT-EVALUATION-MATRIX.md](COMPONENT-EVALUATION-MATRIX.md)

---

## Before you start

1. Confirm WIN-1 Core complete (or operator waiver documented)
2. Capture baseline: `verify-win-2.5.ps1 -BaselineOnly` *(when implemented)*
3. Review component decisions in `shared/evidence/win-2.5/component-decisions.md`

---

## 1. Package layer (winget)

Declarative manifest target: `scripts/install-win-2.5.ps1`

Expected packages (evaluate before pin):

| Package | Id (candidate) | Purpose |
|---------|----------------|---------|
| Windows Terminal | Microsoft.WindowsTerminal | Terminal |
| PowerToys | Microsoft.PowerToys | Run + FancyZones |
| Everything | voidtools.Everything | File search |
| Flow Launcher | Flow-Launcher.Flow-Launcher | Launcher *(if selected)* |
| JetBrains Mono Nerd Font | *(TBD — manual or font winget)* | Shared font |
| Oh My Posh | JanDeDobbeleer.OhMyPosh | Prompt |

---

## 2. Terminal

- Import profile: `config/windows-terminal/settings.json`
- Default profile: PowerShell 7
- Font: JetBrains Mono Nerd Font
- Colors: align with Arch terminal where practical (document delta)

---

## 3. Launcher

- Install selected launcher
- Bind global hotkey (document in `config/shortcuts.json`)
- Plugins: shell, program, window switcher

---

## 4. Search

- Everything: index `C:\Projects` + dev paths
- Launcher: application search

---

## 5. Window management

- FancyZones: engineering layout presets only (editor + terminal + browser)
- No forced tiling

---

## 6. Git · SSH · Cursor

- Git global config matches Linux (`core.autocrlf=false`, `core.eol=lf`)
- SSH config unchanged unless WIN-2.5 adds documented aliases
- Cursor: export keybindings to `config/cursor/keybindings.json`

---

## 7. Verification

```powershell
.\verify\verify-win-2.5.ps1 | Tee-Object ..\..\shared\evidence\win-2.5\verification.txt
```

---

## 8. Rollback

See [ROLLBACK.md](ROLLBACK.md).

---

*Outline · execution fills in pinned versions and final paths*
