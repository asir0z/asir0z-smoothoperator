# MISSION — MAC-1 OPERATOR CONSOLE BOOTSTRAP

```text
Status: Planned
Scope: Operator Environment
Priority: High
Type: Operator Console Bootstrap (not infrastructure)
```

**Architecture reference:** [`shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](../architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md)

---

## Purpose

This mission prepares the Mac to become the **primary operator console** for the entire engineering ecosystem.

This is **not** an infrastructure mission.

- No production servers are modified.
- No DevOps services are deployed.

The objective is to establish a clean, reproducible, and portable operator workstation.

---

## Success Criteria

At completion, the Mac can:

- Access every Git repository.
- Access every server through SSH.
- Operate Cursor as the primary development environment.
- Operate ChatGPT as the primary engineering assistant.
- Build and review code.
- Manage infrastructure remotely.
- Work independently from the Arch workstation.

---

## Mission Scope

### Included

- macOS updates
- Homebrew
- Git
- SSH
- Cursor
- Terminal configuration
- Repository cloning
- Development tools
- GitHub authentication

### Excluded

- Ubuntu infrastructure changes
- Docker server deployment
- n8n deployment
- Arch installation
- Kubernetes
- Infrastructure migration

---

## Phase 1 — Operating System

Complete all available macOS updates.

Enable:

- FileVault
- Firewall
- Automatic security updates

Verify:

- Time synchronization
- Correct hostname
- Correct timezone (`Europe/Istanbul`)

---

## Phase 2 — Package Manager

Install Homebrew.

Verify:

```bash
brew doctor
brew update
brew upgrade
```

**PASS** when no blocking issues remain.

---

## Phase 3 — Development Tools

Install:

- Git
- gh (GitHub CLI)
- wget
- curl
- jq
- tree
- htop
- ripgrep
- fd
- tmux
- neovim (optional)

Verify every executable.

---

## Phase 4 — SSH

Create:

```text
~/.ssh/
```

Configure:

- SSH keys
- GitHub authentication

Prepare config entries:

```text
Host lab
Host arch
Host github.com
```

(No infrastructure changes yet — aliases only; endpoints filled when reachable.)

---

## Phase 5 — Git

Configure:

- `user.name`
- `user.email`
- default branch
- signing (optional)

Authenticate GitHub.

Verify:

```bash
git clone
git fetch
git push
```

---

## Phase 6 — Cursor

Install Cursor.

Enable:

- Git integration
- Terminal
- Extensions (as needed)

Clone repositories.

Verify repository operations from Cursor.

---

## Phase 7 — Workspace

Recommended structure:

```text
~/Projects/
    asir0z-smoothoperator/
    asir0z-devopslab/
    asir0z-product-intelligence/
    asir0z-web/
    asir0z-cortex/          # when repo restored
    asir0z-project-pulse/   # when applicable
```

Git remains the synchronization authority.

---

## Phase 8 — Remote Operations

Verify remote workflows.

```text
Mac
 ↓ SSH
Ubuntu Server (lab)
 ↓
Infrastructure
```

No local infrastructure required on the Mac for this mission.

Test (when endpoints available):

```bash
ssh lab
ssh arch
```

---

## Phase 9 — Evidence

Capture to `shared/evidence/mac-1/`:

| Artifact | Command / check |
|----------|-----------------|
| Homebrew | `brew doctor` |
| Git | `git --version` |
| GitHub CLI | `gh auth status` |
| GitHub SSH | `ssh -T git@github.com` |
| Cursor | Launch + open repo |
| Clone | `git clone` of active repos |
| Push | Test push to non-production branch |

---

## Completion Criteria

**PASS** when:

- Mac fully replaces Windows as operator console for daily engineering work.
- Git works.
- SSH works.
- Cursor works.
- Repository management works.
- Remote infrastructure management works (via SSH to lab/contabo).

---

## Architecture Alignment

| Layer | Role |
|-------|------|
| Infrastructure | Ubuntu Server |
| Compute | Arch Linux |
| Operator | Mac |
| Sync | Git (single source of truth) |

Production services remain independent from both Mac and Arch.

---

## Next Missions

| Mission | When |
|---------|------|
| **MAC-2** Development Experience | Immediately after MAC-1 PASS — [`MAC-2-DEVELOPMENT-EXPERIENCE.md`](MAC-2-DEVELOPMENT-EXPERIENCE.md) |
| Arch bare-metal install | When shrink + prep gates PASS — `shared/evidence/bare-metal/arch-install-spec.md` |

After MAC-1 completes, use the Mac as the primary operator console throughout remaining bare-metal setup.

---

## Parallel Tracks (unchanged)

MAC-1 does **not** block or replace:

```text
Fast Startup OFF → disk shrink → arch-install-spec.md
```

Windows remains valid for disk shrink until that phase completes.

---

*SmoothOperator™ · MAC-1 · Operator Console Bootstrap*
