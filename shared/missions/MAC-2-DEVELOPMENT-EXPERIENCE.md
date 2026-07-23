# MAC-2 — Development Experience

```text
Status:     DEFERRED
Depends on: MAC-1 PASS ✅ · Arch install · Arch bootstrap
Scope:      Operator UX · private network · runtimes
Platform:   SmoothOperator™ · Mac
Type:       Workstation enhancement — not infrastructure
Date:       2026-07-23
Deferred:   2026-07-24 — after OFFLINE-1 → Arch install → Arch bootstrap
Amendment:  MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md (Approved)
```

> **Scheduling note (2026-07-24):** MAC-1 is certified. MAC-2 is comfort/DX (Ghostty, Raycast, Starship, …). Disk partitioning (OFFLINE-1) is the critical path — do **not** start MAC-2 until Arch bare-metal + bootstrap are done.

---

## Purpose

Elevate the Mac from a certified operator baseline (MAC-1) to a polished, reproducible **daily development experience** — still without hosting production infrastructure.

---

## Completion criteria

MAC-2 is not complete until:

* Enhanced terminal and shell UX are **reproducible** from Git-tracked config
* **Tailscale** access is verified to Ubuntu Server, Arch (when on), future NAS, private dashboards
* Runtime managers are **documented and working**
* Optional AI CLI tools are installed only when justified
* Local development dependencies remain **separate** from production infrastructure

---

## Enhanced terminal (optional)

Install **at most one** primary enhanced terminal after evaluation:

* Ghostty
* iTerm2

Constraints:

* Terminal.app remains the recovery terminal
* Operator environment must never depend exclusively on a third-party terminal
* Config stored under `shared/operator/` (or documented path) — secret-free

---

## Shell UX (MAC-2)

May introduce (all must be reproducible and documented):

* Starship
* zoxide
* fzf polish (beyond MAC-1 baseline)
* syntax highlighting
* autosuggestions

Avoid unmanaged plugin sprawl. Prefer a small, pinned set installed via Homebrew or a documented installer.

---

## Tailscale

Belongs in MAC-2 unless MAC-1 urgently requires private reachability.

Targets:

```text
Ubuntu Server
Arch workstation
future NAS
private dashboards
```

Do **not** introduce public SSH exposure merely to simplify Mac access.

Evidence: Tailscale status, peer connectivity, `ssh lab` / `ssh arch` over Tailscale names.

---

## Runtime managers

Prefer reproducible managers over unmanaged global installs.

| Ecosystem | Preferred |
|-----------|-----------|
| Python | `uv` |
| Node.js | `mise` or `fnm` (pick one; document) |
| Node packages | `pnpm` via Corepack |

Avoid overlapping managers without justification.

**Gate:** document the selected strategy in this file (or a linked decision note) **before** implementation.

---

## Operator command polish

Stabilize MAC-1 aliases/functions and add deploy helpers when remote canonical scripts exist:

```bash
deploy-web
deploy-pi
```

Wrappers only — production deploy logic stays on Ubuntu / in `asir0z-devopslab`.

---

## Secrets (MAC-2 options)

* macOS Keychain (continue)
* `gh auth` / SSH agent (continue)
* **1Password SSH Agent** (optional upgrade)

Still never commit secrets or put them in `.zshrc` / scripts / aliases.

---

## Explicit non-goals

* Moving Docker / n8n / reverse proxy onto the Mac
* Replacing Ubuntu as production authority
* Mandatory Arch power-on for daily work
* Premature new “dotfiles-only” repository (defer until evidence justifies)

---

## Evidence (preview)

* Terminal choice + config path
* Shell UX package list + versions
* Tailscale peer checks
* Runtime manager versions (`uv`, `mise`/`fnm`, `pnpm`)
* Wrapper smoke tests (`lab-health`, `repos-status`)

Path (future): `shared/evidence/mac-2/`

---

## Relationship to bare-metal

Unchanged and independent:

```text
Windows disk shrink → gate → arch-install-spec → Arch installation
```

---

*SmoothOperator™ · MAC-2 · Development Experience*
