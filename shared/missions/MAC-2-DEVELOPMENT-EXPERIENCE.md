# MAC-2 — Complete Operator Engineering Workstation

```text
Status:     DEFERRED · SCOPE EXPANSION APPROVED
Depends on: MAC-1 PASS ✅ · OFFLINE-1 PASS · Arch install · Arch bootstrap
Scope:      Daily engineering workstation (not UX-only)
Platform:   SmoothOperator™ · Mac
Type:       Workstation enhancement — not infrastructure
Date:       2026-07-23
Expanded:   2026-07-24
Deferred:   until OFFLINE-1 → Arch install → Arch bootstrap
Prior:      MAC-1-SCOPE-AMENDMENT-TERMINAL-SHELL-SCRIPTS.md (Approved)
Expansion:  MAC-2-SCOPE-EXPANSION-ENGINEERING-WORKSTATION.md (Approved)
```

> **Scheduling (2026-07-24):** Scope is approved; **implementation stays deferred**. Critical path remains OFFLINE-1 → Arch install → Arch bootstrap → **then** MAC-2.

---

## Purpose

Transform the Mac from a certified **operator console** (MAC-1) into a complete, reproducible **daily engineering workstation** capable of operating every project in the ecosystem — still without hosting production infrastructure.

MAC-2 is not merely UX polish. The Mac must become the daily engineering environment.

---

## Operator philosophy

| Role | Mac |
|------|-----|
| Operator Console | ✅ (MAC-1 baseline) |
| Engineering Workstation | ✅ (MAC-2) |
| Repository Manager | ✅ |
| Remote Infrastructure Controller | ✅ |

The Mac is **not** production infrastructure.

```text
Mac     → Operator
Ubuntu  → Infrastructure
Arch    → Compute
Git     → Source of Truth
```

No responsibility overlap.

---

## Completion criteria

MAC-2 is complete when the Mac can:

* Build every repository in the ecosystem
* Manage GitHub (auth · multi-repo · health)
* Manage Ubuntu remotely (wrappers only)
* Manage Arch remotely (when on)
* Execute operator wrappers
* Restore itself from bootstrap / Git-tracked config
* Provide a reproducible engineering environment

**without depending on any other workstation.**

---

## Terminal

Install **one** primary enhanced terminal:

* **Ghostty** (preferred)
* iTerm2

Constraints:

* Terminal.app remains the recovery terminal
* Never depend exclusively on a third-party terminal
* Config Git-tracked under `shared/operator/` (secret-free)

---

## Shell

Standardize on **zsh**.

Enhancements (reproducible · documented · pinned):

* Starship
* zoxide
* fzf (beyond MAC-1 baseline)
* autosuggestions
* syntax highlighting

Avoid unmanaged plugin sprawl. Prefer Homebrew or a documented installer.

---

## Package management

* **Homebrew** is the primary package manager
* Document every installed package (bootstrap / packages script)
* Prefer Homebrew formula/cask over manual app installs when maintained

---

## Development languages

Reproducible runtimes — document strategy **before** implementation.

| Ecosystem | Preferred | Notes |
|-----------|-----------|-------|
| Python | `uv` | venvs · deps · tools |
| Node.js | `mise` **or** `fnm` (pick one) | document choice |
| Node packages | Corepack + `pnpm` | |
| Go / Rust / Java / Bun | Optional | install only when required |

Avoid overlapping managers without justification.

---

## CLI ecosystem

**Required** (many already PASS under MAC-1 — re-verify in MAC-2 evidence):

```text
git gh curl wget jq yq tree fd ripgrep fzf tmux rsync make shellcheck shfmt
```

**Recommended:**

```text
bat eza btop ncdu watch
```

---

## AI development

Optional **clients only**:

* OpenAI CLI · Gemini CLI · Claude CLI · Ollama client

Large AI workloads belong on **Arch**. Do not turn the Mac into a compute node.

---

## Editors

| Tool | Role |
|------|------|
| Cursor | Primary engineering IDE |
| VS Code | Optional |
| Neovim | Optional (already present under MAC-1) |

---

## Git / multi-repo

Support:

* Multi-repository workflow under `~/Projects`
* GitHub CLI + SSH authentication
* Repository health verification

Helpers (no automatic commits · no force-push):

```bash
repos-status
repos-fetch
repos-pull
repos-push
```

---

## SSH

Aliases / hosts:

```bash
lab
arch
github
```

Future (when hosts exist):

```bash
nas
backup
```

SSH config remains **secret-free** (templates in `shared/operator/`). Private keys never in repo.

---

## Infrastructure access

The Mac manages Ubuntu, Arch, and future NAS **through SSH**.

No production logic duplicated locally. Canonical scripts stay on Ubuntu (`~/scripts/ops/…`).

---

## Tailscale

Install and verify. Prefer private networking for operator SSH.

Targets: Ubuntu Server · Arch · future NAS · private dashboards.

Do **not** introduce public SSH exposure merely to simplify Mac access.

---

## Docker

Install Docker Desktop **only if** local development requires it.

Production containers remain on Ubuntu.

---

## Productivity

**Recommended:** Raycast · Rectangle · Stats  

**Optional:** Karabiner · BetterDisplay

---

## Security

* FileVault (MAC-1: On)
* Firewall (MAC-1 backlog — close in MAC-2 if still Off)
* Touch ID for sudo (optional)
* Secrets: Keychain · SSH Agent · 1Password SSH Agent (optional)

Never commit secrets.

---

## Dotfiles / bootstrap

Maintain `shared/operator/`:

* zsh · gitconfig · tmux · ssh examples

Bootstrap must recreate the environment automatically after a clean macOS install (`scripts/bootstrap/` + operator installers).

---

## Operator command polish

Stabilize MAC-1 wrappers and add deploy helpers when remote canonical scripts exist:

```bash
lab-health · lab-status · lab-ssh · arch-ssh
repos-status · repos-fetch · repos-pull · repos-push
deploy-web · deploy-pi
```

Wrappers only — production deploy logic stays on Ubuntu / `asir0z-devopslab`.

---

## Verification / evidence

MAC-2 must verify: runtimes · shell · SSH · Git · GitHub · Homebrew · operator scripts · wrappers · remote access.

Evidence path: `shared/evidence/mac-2/`

---

## Explicit non-goals

* Moving Docker / n8n / reverse proxy onto the Mac as production
* Replacing Ubuntu as production authority
* Replacing Arch as compute
* Mandatory Arch power-on for daily operator work
* Premature new “dotfiles-only” repository (defer until evidence justifies)
* Starting MAC-2 implementation before Arch foundation is complete

---

## Future extensions (evidence-gated)

Add only when operational evidence justifies:

* Local CI helpers · remote deploy wrappers · multi-repo dashboard
* AI-assisted operator commands · backup verification · infra dashboards

---

## Active priority (unchanged)

```text
OFFLINE-1
    ↓
Arch Installation
    ↓
Arch Bootstrap
    ↓
MAC-2 Implementation   ← this mission
```

---

*SmoothOperator™ · MAC-2 · Complete Operator Engineering Workstation*
