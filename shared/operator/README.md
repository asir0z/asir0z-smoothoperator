# Shared Operator Configuration

> Secret-free, Git-tracked operator defaults for the Mac console (and reusable patterns for Linux).  
> Mission: [`../missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md`](../missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md)

---

## Layout

```text
shared/operator/
├── README.md
├── dotfiles/
│   ├── zshrc
│   ├── gitconfig
│   ├── tmux.conf
│   └── ssh-config.example
└── scripts/
    └── install-dotfiles.sh
```

---

## Install (Mac)

```bash
cd ~/Projects/asir0z-smoothoperator
bash shared/operator/scripts/install-dotfiles.sh
exec zsh -l
```

The installer:

* Backs up existing files to `~/.smoothoperator-dotfiles-backup-<timestamp>/`
* Symlinks or copies tracked files into `$HOME`
* Installs SSH config **only if** `~/.ssh/config` is missing (from `ssh-config.example`)
* Never writes private keys or tokens

---

## Never commit

```text
private SSH keys
tokens / passwords
machine-specific secrets
shell history
Git credential files
.env files containing secrets
```

HostName values for `lab` / `arch` are filled locally during MAC-1 execution.

---

## Operator commands (zsh)

After install, functions/aliases include:

| Command | Meaning |
|---------|---------|
| `lab-ssh` | `ssh lab` |
| `arch-ssh` | `ssh arch` |
| `lab-health` | remote production health wrapper |
| `lab-status` | remote uptime / docker summary |
| `repos-status` | multi-repo status under `~/Projects` |
| `repos-pull` | `git pull --ff-only` when clean |
| `proj` | `cd ~/Projects` |
| `so` | `cd` SmoothOperator repo |

Wrappers call `scripts/ops/*` in this repo or SSH into Ubuntu — they do **not** reimplement production logic.

---

## MAC-2

Starship, zoxide, syntax highlighting, autosuggestions, Tailscale, and enhanced terminals are out of scope here.

---

*SmoothOperator™ · shared/operator*
