# WIN-2.5 Rollback

> **Status:** TEMPLATE — refine during execution with exact package versions  
> **Principle:** User-scope config first; reversible winget uninstalls

---

## Pre-mission snapshot

Before WIN-2.5 execution, capture:

```powershell
# Save to shared/evidence/win-2.5/pre-state/
winget list > winget-pre.txt
Get-Command wt, pwsh -ErrorAction SilentlyContinue | Format-List > commands-pre.txt
# Copy existing Windows Terminal settings if present:
Copy-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json" `
  pre-state/settings.json -ErrorAction SilentlyContinue
```

---

## Per-component rollback

| Component | Rollback |
|-----------|----------|
| **Windows Terminal** | Restore `pre-state/settings.json` · or uninstall via winget |
| **PowerToys** | Disable modules in PowerToys UI · winget uninstall Microsoft.PowerToys |
| **Everything** | Uninstall voidtools.Everything · remove service if added |
| **Flow Launcher** | Uninstall · remove startup entry |
| **Oh My Posh** | Remove `$PROFILE` hooks · winget uninstall JanDeDobbeleer.OhMyPosh |
| **Nerd Font** | Uninstall font · revert Terminal font setting |
| **FancyZones layouts** | Delete custom layouts in PowerToys or restore defaults |

---

## Full rollback (mission abort)

```text
1. Run per-component uninstall (winget)
2. Restore pre-state settings files
3. Remove repo config symlinks/copies if any were applied
4. Reboot (optional — clears launcher hotkey hooks)
5. Verify: verify-win-2.5.ps1 -ExpectAbsent (when implemented)
```

---

## Non-goals

Rollback does **not** require Windows reset.  
Rollback does **not** undo WIN-1 cleanup — separate mission.

---

*Template · SmoothOperator™*
