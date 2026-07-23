# SmoothOperator — Cursor Session Handoff

> **Read at session start** · 2026-07-23 post-reboot  
> **Canonical state:** [`shared/certification/PLATFORM-STATE.md`](../certification/PLATFORM-STATE.md)

---

## Platform snapshot

```text
Migration              CERTIFIED · FROZEN
WIN-1 Infrastructure   CERTIFIED · FROZEN
WIN-1 Core             ACTIVE (friction-driven)
WS-2 Sprint 1          APPROVED WITH CONDITIONS
WS-2 Sprint 2          APPROVED WITH CONDITIONS · GUI pending
Mission 20             OBSERVATION (DevOps Lab / Contabo)
Arch VM                ACTIVE DEVELOPMENT WORKSTATION (validation)
Windows                SAFE FALLBACK
Bare-metal Arch        FUTURE TARGET · NOT AUTHORIZED
```

**Engineering principle:**

```text
A VM may disappear tomorrow.
The engineering laboratory must not.
```

Critical knowledge lives in Git, evidence, and reproducible scripts — not in VM-only state or chat history.

---

## Repository

| Host | Path |
|------|------|
| Windows | `C:\Projects\asir0z-smoothoperator` |
| Arch | `~/Projects/asir0z-smoothoperator` |
| Remote | `https://github.com/asir0z/asir0z-smoothoperator.git` |
| Remote HEAD | `ee2063d` |

**Related repos (Arch `~/Projects/`):**

- `asir0z-devopslab` — production authority (separate repo)
- `asir0z-web`
- `asir0z-product-intelligence`
- `asir0z-cortex` — deferred (GitHub repo not found)

---

## WS-2 Sprint 2 — current gate

| Area | Status |
|------|--------|
| Engineering | ✅ Complete |
| Windows sync | ✅ PASS (`ee2063d`) |
| Timezone | ✅ PASS (`Europe/Istanbul`) |
| Keyboard config | ✅ PASS (repo Hyprland `tr,us` · Alt+Shift) |
| Display investigation | ✅ Closed (VM-specific · no repo change) |
| Evidence | ✅ Updated locally · **not yet committed** |
| GUI acceptance | ⏳ **Operator pending** |
| Certification | ⏳ After GUI PASS → DevOps Lab review |

**Do not:** open new sprints, redesign architecture, or add marginal docs until GUI closes Sprint 2.

**Evidence pack:** [`shared/evidence/ws-2/sprint-2/`](../evidence/ws-2/sprint-2/)  
**GUI checklist:** [`shared/evidence/ws-2/sprint-2/gui-validation.md`](../evidence/ws-2/sprint-2/gui-validation.md)

---

## Operator GUI acceptance test (remaining work)

Run in **Arch Hyprland** session after VM start:

| Key / action | Purpose |
|--------------|---------|
| `Win + E` | wofi app launcher → Cursor |
| `Win + Enter` | kitty terminal |

| # | Test |
|---|------|
| 1 | Cursor launches |
| 2 | Opens `~/Projects/asir0z-smoothoperator` |
| 3 | Terminal: `Ctrl+Shift+C` / `Ctrl+Shift+V` |
| 4 | Cursor ↔ Terminal clipboard |
| 5 | Turkish: `ğüşiöç` |
| 6 | `Alt+Shift` → US: `[]{}@#` |
| 7 | Audio (test sound or video) |
| 8–12 | **Reboot Arch** → Hyprland, keyboard, timezone, Cursor, repo |

Post-reboot timezone check:

```bash
timedatectl | grep "Time zone"
# Expected: Europe/Istanbul
```

When all PASS → update [`gui-validation.md`](../evidence/ws-2/sprint-2/gui-validation.md) → commit → certification request.

---

## After GUI PASS — close Sprint 2

### 1. Update evidence

In `shared/evidence/ws-2/sprint-2/gui-validation.md`:

- Mark acceptance table items **PASS**
- Replace **Overall status** with:

```text
PASS

WS-2 Sprint 2 is ready for certification review.

Outstanding issues:
None.

Interactive GUI validation completed.
Evidence complete.
```

### 2. Commit (from Arch or Windows)

```text
docs(ws-2): finalize sprint-2 validation evidence
```

Includes uncommitted sprint-2 evidence files (timezone, keyboard, display, gui-validation, final-report updates).

### 3. Request DevOps Lab certification review

```text
WS-2 Sprint 2
Timezone PASS
GUI PASS
Windows Sync PASS
Evidence Complete
Ready for Certification Review.
```

Expected outcome: **APPROVED · CLOSED** → shift focus to Product Intelligence.

---

## Arch workstation quick reference

```bash
# Start VM: VirtualBox → Arch-Engineering-Workstation
ssh arch-ws   # port 2223 from Windows ~/.ssh/config

# Apply dotfiles
cd ~/Projects/asir0z-smoothoperator
bash linux/arch-workstation/apply-config.sh

# Cursor
cursor ~/Projects/asir0z-smoothoperator
# or Win+E → Cursor

# Timezone (already set — re-verify after reboot)
timedatectl
```

**Config source:** `linux/arch-workstation/dotfiles/`  
**Scripts:** `linux/arch-workstation/scripts/install-cursor.sh`, `set-operator-timezone.sh`

---

## Windows notes

- Repo synced to `ee2063d`; local evidence edits pending commit (safe on disk).
- Academetrica archive **not in Git** — backup at `C:\Projects\asir0z-smoothoperator-sync-backup-20260723\` (conscious decision; separate ADR if ever ingested).
- Display scaling on Arch VM = **VM-only observation** — not a certification FAIL criterion.

---

## Agent rules for this repo

1. **Evidence before conclusions** — no guessing on infra issues.
2. **Smallest correct fix** — no speculative redesign.
3. **No secrets in repo** — SSH keys, tokens, `.env` never committed.
4. **Sprint boundaries:** Windows friction → WIN-1 Core · Arch/bare-metal → WS-2 · Production → DevOps Lab.
5. **Do not self-certify** — DevOps Lab is certification authority for sprint closeout.

---

## Key files

| File | Purpose |
|------|---------|
| [`PLATFORM-STATE.md`](../certification/PLATFORM-STATE.md) | Living platform state |
| [`gui-validation.md`](../evidence/ws-2/sprint-2/gui-validation.md) | GUI acceptance (open) |
| [`final-report.md`](../evidence/ws-2/sprint-2/final-report.md) | Sprint 2 report |
| [`linux/arch-workstation/README.md`](../../linux/arch-workstation/README.md) | Arch operator config |

---

*SmoothOperator™ · WS-2 Sprint 2 · awaiting operator GUI acceptance*
