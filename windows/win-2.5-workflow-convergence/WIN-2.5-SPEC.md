# WIN-2.5 — Engineering Workflow Convergence

> **Subtitle:** Inspired by the Hyprland workflow — not a Linux desktop clone  
> **Version:** 0.2 · 2026-07-23  
> **Lifecycle:** WAITING FOR WIN-1 · execution NOT authorized  
> **Platform:** SmoothOperator™ · Windows  
> **Repository:** `asir0z-smoothoperator`  
> **Certification:** `shared/certification/WIN-2.5.md`

---

## Vision

Standardize the **engineering experience** — not the operating system.

```text
Today:     Windows  ↔  Arch  (minimize context switching)
Tomorrow:  Windows  ↔  Arch  ↔  macOS  (same workflow principles)
```

SmoothOperator™ delivers reproducible engineering workflow across platforms. WIN-2.5 is the Windows convergence layer.

**This is not rice.** **This is not “make Windows look like Hyprland.”**

It asks:

> Which workflow patterns reduce friction for an engineer — and can be reproduced on Windows with stable, supported tools?

---

## 1. Philosophy

| Principle | Meaning |
|-----------|---------|
| **Stability over appearance** | Productivity over cosmetic tweaks |
| **Keyboard first** | Frequent actions get shortcuts |
| **Reproducibility** | Scriptable; nothing hidden in undocumented GUI-only state |
| **Evidence-based selection** | Decisions by criteria matrix — not preference alone |
| **Adoption criteria** | Every component must pass context-switch + reproducibility gates |
| **Windows stays Windows** | Native compatibility; no Linux emulation |

---

## 2. Execution gate

```text
Specification         APPROVED WITH RECOMMENDATIONS ✅
Execution             NOT AUTHORIZED
```

**Prerequisites before execution:**

| Prerequisite | Status |
|--------------|--------|
| WIN-1 Complete (Core + Infrastructure certified) | ⏳ pending |
| Windows baseline stable | ⏳ pending |
| Component Evaluation Plan approved | ✅ matrix in spec |
| Explicit execution authorization | ❌ |

WIN-2.5 does **not** wait for WIN-1A, Host Acceptance, or Mission 20 — pure Windows DX.

---

## 3. Roadmap position

```text
WIN-0 ✅
  ↓
P0 rename · Transition VM review ✅
  ↓
WIN-1 (Core → Infrastructure)
  ↓
WIN-2.5 ← Engineering Workflow Convergence (this mission)
  ↓
WS-2 (Arch developer experience — parallel convergence)
  ↓
Mission 20 · Host Acceptance · Observation
  ↓
WIN-1A (transition VM retirement)
```

**WIN-2.5 and WS-2 are sibling convergence sprints** — same goal, different platforms.

---

## 4. Lifecycle (evaluation before standardization)

Do not lock tools on day one. Use a trial period.

```text
WIN-2.5
  ↓
Evaluation        (install candidates · use 3+ days each where contested)
  ↓
Selection         (matrix scores + adoption criteria)
  ↓
Implementation    (scripted config · winget manifest)
  ↓
Verification      (verify-win-2.5.ps1)
  ↓
Certification     (shared/certification/WIN-2.5.md → FROZEN)
```

Evidence per phase: `shared/evidence/win-2.5/evaluation/` · `implementation/` · `verification.txt`

---

## 5. Adoption criteria (mandatory per component)

Every selected tool must answer:

```text
Does this reduce context switching?     YES / NO
Can this be reproduced from the repo?   YES / NO
```

**If either is NO → does not enter the standard.**

Additional matrix criteria: see [COMPONENT-EVALUATION-MATRIX.md](COMPONENT-EVALUATION-MATRIX.md).

---

## 6. Component evaluation matrix

Full matrix: **[COMPONENT-EVALUATION-MATRIX.md](COMPONENT-EVALUATION-MATRIX.md)**

Operator draft preferences (subject to evaluation phase — not locked until Selection):

| Component | 🥇 Primary | 🥈 Alternate | Notes |
|-----------|------------|--------------|-------|
| Launcher | Flow Launcher | PowerToys Run | Plugin architecture · long-term extensibility |
| File search | Everything | — | Non-negotiable vs Windows Search |
| Window management | FancyZones | — | Stable; no tiling hacks |
| Terminal | Windows Terminal | — | Tabs · profiles |
| Prompt | Oh My Posh | — | Lightweight theme only |
| Clipboard | Windows Clipboard History | Ditto | Try built-in first |
| Font | JetBrains Mono Nerd Font | — | Shared Windows · Arch · future macOS |

---

## 7. Scope

### Allowed

Window management · keyboard workflow · terminal · launcher · fonts · file search · clipboard · screenshots · winget · Git/SSH alignment · Cursor keybindings

### Not allowed

Registry hacks · unsupported shell replacements · unstable Explorer mods · debloat packs · visual stability risks

### Out of scope

Explorer replacement · Linux/macOS desktop emulation · Rainmeter · custom ISOs

---

## 8. Success criteria

- [ ] Context switching reduced vs pre-WIN-2.5 baseline (operator attestation + evidence)
- [ ] Keyboard covers: terminal · launcher · Cursor · Explorer · file search · browser
- [ ] All selected components pass adoption criteria
- [ ] Full setup reproducible from repo scripts
- [ ] Rollback documented
- [ ] Windows stable

**Qualitative acceptance:** Move Windows ↔ Arch (`ssh arch-ws`) with minimal mental model change for daily engineering tasks.

---

## 9. Deliverables

| Artifact | Path | Status |
|----------|------|--------|
| Specification | `WIN-2.5-SPEC.md` | ✅ v0.2 |
| Evaluation matrix | `COMPONENT-EVALUATION-MATRIX.md` | ✅ |
| Setup guide | `SETUP-GUIDE.md` | 📋 at execution |
| Evaluation log | `shared/evidence/win-2.5/evaluation/` | 📋 |
| Scripts | `scripts/` | 📋 at implementation |
| Verification | `verify/verify-win-2.5.ps1` | 📋 skeleton |
| Rollback | `ROLLBACK.md` | 📋 template |
| Certification | `shared/certification/WIN-2.5.md` | ✅ spec gate only |

---

## 10. Boundaries

| Allowed | Forbidden |
|---------|-----------|
| winget · supported tools | Registry hacks |
| Windows Terminal · PowerToys · Everything | Explorer replacement |
| Evaluation trials (reversible) | Premature freeze before Selection |
| Document Cursor keybindings | DevOps Lab production mutation |
| Shared Nerd Font | Modify WS-1 frozen stack without WS-2 gate |

---

## 11. Expected outcome

Windows becomes an efficient, reproducible engineering platform. The operator converges workflow with Arch (and eventually other hosts) without sacrificing Windows native behavior.

> **Standardize engineering experience — not operating systems.**

---

*Specification APPROVED WITH RECOMMENDATIONS · Execution NOT AUTHORIZED · SmoothOperator™*
