# MAC-2 — Approved Software Baseline

```text
Status:       APPROVED SOFTWARE BASELINE
Implementation: DEFERRED
Activation:   After OFFLINE-1 · Arch Installation · Arch Bootstrap
Applies to:   MAC-2-DEVELOPMENT-EXPERIENCE.md
Date:         2026-07-24
```

**Does not start implementation.** Defines the software set used when MAC-2 begins.

Mission: [`MAC-2-DEVELOPMENT-EXPERIENCE.md`](MAC-2-DEVELOPMENT-EXPERIENCE.md)  
Scope expansion: [`MAC-2-SCOPE-EXPANSION-ENGINEERING-WORKSTATION.md`](MAC-2-SCOPE-EXPANSION-ENGINEERING-WORKSTATION.md)

---

## Objective

Minimal, reproducible, engineering-focused macOS software baseline.

* Every application has a clear operational purpose
* Avoid duplicate tools
* Prefer Homebrew (Formula · Cask · Brewfile)
* Manual installs only when technically necessary

---

## Engineering principles

* reproducible · scriptable · documented · reviewable · recoverable

---

## Approved applications

### Core engineering

| Item | Notes |
|------|--------|
| Homebrew | Primary package manager |
| Git | Already MAC-1 |
| GitHub CLI (`gh`) | Already MAC-1 |
| OpenSSH | Already MAC-1 |
| Cursor | Primary IDE |
| Visual Studio Code | Optional |
| Docker Desktop | Local development only — production stays on Ubuntu |

### Terminal

| Role | App |
|------|-----|
| Recovery | Terminal.app (always) |
| Primary | **Ghostty** |

### Shell

* zsh
* Starship
* fzf
* zoxide
* zsh-autosuggestions
* zsh-syntax-highlighting
* tmux

No large shell frameworks unless justified.

### Development toolchain

| Stack | Choice |
|-------|--------|
| Python | `uv` |
| Node.js | `mise` (preferred) or `fnm` — pick one at implementation |
| Node packages | Corepack + `pnpm` |
| Go / Rust / Java / Bun | Only when required |

### Productivity

**Approved:** Raycast · Rectangle · Stats  

**Keep-awake (operator sessions):**

| App | Install path | Notes |
|-----|--------------|--------|
| **Amphetamine** | Mac App Store via **`mas`** (id `937984704`) | Official app — **no Homebrew cask exists** (`brew install --cask amphetamine` fails) |
| KeepingYouAwake | `brew install --cask keepingyouawake` | Homebrew-native alternative if MAS/`mas` unwanted |

Brewfile shape for Amphetamine (when MAC-2 implements):

```ruby
brew "mas"
mas "Amphetamine", id: 937984704
```

**Optional** (document operational value before install): BetterDisplay · Karabiner

### Networking

* Tailscale
* SSH config: `~/.ssh/config` (secret-free templates in Git)
* Aliases: `lab` · `arch` · `github` · future `nas` · `backup`
* Private keys never in Git

### Mail

| Client | Role |
|--------|------|
| **Spark** | Approved — cross-device consistency · unified accounts · operator workflow |
| Apple Mail | Native fallback |

### AI tooling (optional · clients only)

* OpenAI CLI · Gemini CLI · Claude CLI  

Heavy AI workloads remain on Arch.

---

## Operator helpers (wrappers only)

```bash
repos-status · repos-fetch · repos-pull · repos-push
lab-health · lab-logs · lab-ssh · arch-ssh
```

* No automatic commits or pushes without explicit operator approval
* Wrappers invoke remote commands only — production logic stays on Ubuntu

---

## Security

**Maintain:** FileVault · Firewall · Keychain · SSH Agent  

**Optional:** 1Password SSH Agent  

Secrets never in Git.

---

## Dotfiles (Git-tracked)

Recoverable config for: zsh · gitconfig · tmux · starship · ssh examples (`shared/operator/`).

---

## MAC-2 deliverables (when active)

* Brewfile
* `bootstrap-macos.sh` (or extend existing `scripts/bootstrap/mac-*.sh`)
* `verify-macos.sh` (or extend `mac-verify.sh`)
* Software inventory
* Installation evidence · verification report · documentation

Goal: a brand-new Mac becomes an identical engineering workstation using only Git + bootstrap scripts.

---

## Current status

```text
Status:         APPROVED SOFTWARE BASELINE · DESIGN FROZEN
Implementation: DEFERRED
Active work:    OFFLINE-1 (unchanged)

When MAC-2 activates, implement in order: Brewfile → bootstrap → verify → dotfiles → helpers → evidence.
No further design documents required before that.
```

---

*SmoothOperator™ · MAC-2 · Approved Software Baseline*
