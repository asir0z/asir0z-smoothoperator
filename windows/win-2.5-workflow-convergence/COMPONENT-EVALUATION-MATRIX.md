# WIN-2.5 — Component Evaluation Matrix

> **Status:** APPROVED WITH RECOMMENDATIONS ✅ · selections locked only after **Evaluation → Selection** phase  
> **Spec:** [WIN-2.5-SPEC.md](WIN-2.5-SPEC.md)

Decisions must be scored against criteria — not "I liked it."

---

## Adoption gates (every component)

| Gate | Question | Required |
|------|----------|----------|
| A1 | Does this **reduce context switching**? | **YES** |
| A2 | Can this be **reproduced from the repo**? | **YES** |

Fail either → **exclude from standard**.

---

## Evaluation matrix

Score during trial: **1–5** per criterion · notes in `shared/evidence/win-2.5/evaluation/<component>.md`

| Component | Candidates | Evaluation criteria | Operator preference |
|-----------|------------|---------------------|---------------------|
| **Launcher** | PowerToys Run · Flow Launcher | Startup time · extensibility · indexing · RAM · keyboard flow | 🥇 Flow · 🥈 PowerToys Run |
| **Window management** | FancyZones (PowerToys) | Keyboard workflow · layout presets · stability · no tiling hacks | 🥇 FancyZones |
| **File search** | Everything · Windows Search | Search speed · index control · path coverage · CPU at idle | 🥇 Everything |
| **Terminal** | Windows Terminal · (Git Bash if justified) | Tabs · profiles · SSH integration · font rendering | 🥇 Windows Terminal |
| **Terminal prompt** | Oh My Posh · plain prompt | Startup latency · readability · theme reproducibility | 🥇 Oh My Posh (light theme) |
| **Clipboard** | Windows Clipboard History · Ditto | Multi-entry · hotkey · reliability · no instability | 🥇 Win history first · Ditto if insufficient |
| **Font** | JetBrains Mono Nerd · FiraCode Nerd | Cross-platform · Nerd glyphs · terminal rendering | 🥇 JetBrains Mono Nerd |
| **Screenshot** | Snipping Tool · ShareX · PowerToys | Speed · hotkey · minimal overhead | TBD at evaluation |
| **Package mgmt** | winget | Declarative manifest · idempotency | 🥇 winget |
| **Git** | existing global config | Parity with Linux (`autocrlf`, `eol`) | align with Arch |
| **SSH** | OpenSSH | Same keys/config pattern as Arch | keep current |
| **Cursor** | existing | Keyboard-first · documented bindings | document only |

---

## Evaluation procedure

```text
1. Baseline capture (verify-win-2.5.ps1 -BaselineOnly)
2. For contested components (launcher, clipboard):
     a. Install candidate A · use ≥3 days · score matrix
     b. Install candidate B · use ≥3 days · score matrix
3. Selection meeting — record in component-decisions.md
4. Implementation scripts pin exact versions
5. Verification + certification
```

**Do not** script permanent config until Selection completes.

---

## Selection record template

`shared/evidence/win-2.5/evaluation/component-decisions.md`:

```markdown
## Launcher
- Selected: Flow Launcher
- Rejected: PowerToys Run
- Scores: ...
- Adoption: context-switch YES · reproducible YES
- Trial period: YYYY-MM-DD → YYYY-MM-DD
```

---

*SmoothOperator™ · WIN-2.5 Engineering Workflow Convergence*
