# MAC-1 — Mac Operator Console (package)

> **Status:** AUTHORIZED ✅ · OPERATOR EXECUTION  
> **Canonical mission:** [`shared/missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md`](../../shared/missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md)  
> **Amendment:** terminal · shell · operator scripts (Approved)

Full operator console — zsh, Terminal.app, CLI toolchain, SSH, Git, Cursor, Git-tracked dotfiles, and **Mac wrappers** that call Ubuntu canonical ops over SSH.

---

## Quick start (on the Mac)

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/asir0z/asir0z-smoothoperator.git
cd asir0z-smoothoperator

# Prefer canonical bootstrap:
bash scripts/bootstrap/mac-bootstrap.sh

# Evidence:
bash scripts/bootstrap/mac-verify.sh | tee shared/evidence/mac-1/verification-$(date +%Y%m%d).txt
```

Runbook: [`SETUP-GUIDE.md`](SETUP-GUIDE.md)

---

## Layout

```text
mac/mac-1-operator-console/     # this package (runbook + legacy helpers)
scripts/bootstrap/              # canonical Mac bootstrap / verify
scripts/ops/                    # Mac wrappers (remote authority on Ubuntu)
scripts/lib/                    # shared shell helpers
shared/operator/                # secret-free dotfiles
shared/missions/                # MAC-1 / MAC-2 mission text
```

---

## Responsibility split

| Side | Role |
|------|------|
| Mac | Wrappers, aliases, local verify, Git, Cursor |
| Ubuntu | Canonical production scripts |
| Arch | On-demand compute — not required daily |

```bash
lab-health   # → ssh lab '~/scripts/ops/production-health-check.sh'
```

---

*SmoothOperator™ · MAC-1*
