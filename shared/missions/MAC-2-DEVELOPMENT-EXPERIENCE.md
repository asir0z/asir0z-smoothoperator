# MISSION — MAC-2 DEVELOPMENT EXPERIENCE

```text
Status: Planned
Scope: Operator Environment
Priority: High (after MAC-1)
Type: Operator Console Enhancement (not infrastructure)
Prerequisite: MAC-1 PASS
```

**Architecture reference:** [`shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](../architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md)  
**Prerequisite:** [`MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md`](MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md)

---

## Purpose

Transform the Mac from a **working machine** into a **professional engineering workstation**.

This mission improves daily operator ergonomics, tooling, and local development velocity. It does **not** deploy production infrastructure.

---

## Success Criteria

At completion, the Mac provides:

- Fast launcher and window management
- Polished terminal experience
- Secure SSH key workflow (optional 1Password agent)
- Tailscale mesh access to lab/arch/server
- Local language runtimes (Node, Python) when needed
- Modern shell (Zsh + Starship + fzf)
- Optional AI CLI assistants for terminal workflows

---

## Mission Scope

### Included

| Category | Tools |
|----------|--------|
| Launcher | Raycast |
| Terminal | iTerm2 **or** Ghostty |
| Security / SSH | 1Password SSH Agent (optional) |
| Network | Tailscale |
| Local containers | Docker Desktop (**only if** local dev requires it) |
| Window management | Rectangle |
| Monitoring | Stats |
| Input (optional) | Karabiner-Elements |
| AI CLI (optional) | Claude Code, Gemini CLI, OpenAI CLI |
| Runtimes | Node, Python, pnpm, uv |
| Shell | Zsh + Starship + fzf |

### Excluded

- Ubuntu Server / Contabo changes
- Production Docker stack deployment
- n8n / reverse proxy / monitoring server setup
- Arch bare-metal installation
- Kubernetes

---

## Phase 1 — Productivity Shell

Install and configure:

- Raycast
- Rectangle
- Stats

Verify: window snap, system stats visible, Raycast opens apps and repos.

---

## Phase 2 — Terminal Stack

Choose **one** primary terminal:

- iTerm2, **or**
- Ghostty

Install:

- Zsh (default on macOS — tune if needed)
- Starship prompt
- fzf
- tmux (if not from MAC-1)

Verify: prompt, history search, split panes.

---

## Phase 3 — Network & Access

Install Tailscale.

Verify:

```bash
tailscale status
```

Reach lab/server endpoints when authorized (no production config changes from this mission).

Optional: 1Password SSH Agent for key management.

---

## Phase 4 — Local Development Runtimes

Install as needed (evidence-based — not everything required day one):

```bash
# Examples via Homebrew / official installers
node
pnpm
python
uv
```

Verify: `node -v`, `python3 --version`, project-local tooling.

---

## Phase 5 — Docker Desktop (conditional)

Install **only if** local container workflows are required.

Do **not** use Docker Desktop as a substitute for Ubuntu Server production stack.

Verify: `docker run hello-world` (optional).

---

## Phase 6 — AI CLI (optional)

Install selectively based on operator preference:

- Claude Code
- Gemini CLI
- OpenAI CLI

Verify each tool authenticates and runs without storing secrets in repos.

---

## Phase 7 — Karabiner (optional)

Install Karabiner-Elements only if keyboard remapping is needed.

Keep config in dotfiles or local backup — not secrets in repo.

---

## Phase 8 — Evidence

Capture to `shared/evidence/mac-2/`:

| Check | Evidence |
|-------|----------|
| Raycast | Screenshot or version |
| Terminal | `echo $SHELL`, Starship prompt |
| Tailscale | `tailscale status` |
| Node/Python | Version output |
| Docker | `docker version` (if installed) |
| gh + git | Still PASS from MAC-1 |

---

## Completion Criteria

**PASS** when:

- Operator daily workflow is faster than Windows baseline.
- Terminal + launcher + SSH + Git + Cursor remain stable from MAC-1.
- Tailscale connects to required hosts.
- No production infrastructure was modified during MAC-2.

---

## Architecture Alignment

MAC-2 strengthens the **operator console** layer only:

```text
Mac (operator + dev UX)  →  SSH  →  Ubuntu Server (infra)
                              ↘  →  Arch (compute, on-demand)
```

Git remains sync authority. Infra and compute roles unchanged.

---

## Next After MAC-2

- Continue bare-metal Arch track from Mac as primary console.
- Incremental dotfiles / SSH profile polish as evidence justifies.

---

*SmoothOperator™ · MAC-2 · Development Experience · Planned after MAC-1*
