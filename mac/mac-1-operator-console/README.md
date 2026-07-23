# MAC-1 — Mac Operator Console

> **Status:** AUTHORIZED ✅ · OPERATOR EXECUTION  
> **Host:** macOS (primary operator console target)  
> **Spec:** [`MAC-1-SPEC.md`](MAC-1-SPEC.md)

Bootstrap package for the Mac operator workstation. Run everything on the Mac — this directory is the source of truth, not a cloud-agent execution target.

---

## Quick start (on the Mac)

```bash
# 1) Clone this repo (HTTPS first-time is fine)
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/asir0z/asir0z-smoothoperator.git
cd asir0z-smoothoperator

# 2) Follow the operator runbook
open mac/mac-1-operator-console/SETUP-GUIDE.md   # or read in Cursor

# 3) Automated phases (2–5, 7) after Homebrew exists
bash mac/mac-1-operator-console/scripts/bootstrap-mac1.sh

# 4) Verify + capture evidence
bash mac/mac-1-operator-console/verify/verify-mac1.sh | tee shared/evidence/mac-1/verification-$(date +%Y%m%d).txt
```

Phases 1 (macOS UI settings), 6 (Cursor.app install), and interactive `gh auth login` remain operator-driven.

---

## Layout

```text
mac/mac-1-operator-console/
├── MAC-1-SPEC.md
├── SETUP-GUIDE.md
├── README.md
├── config/
│   ├── git/gitconfig.fragment
│   └── ssh/config.template
├── scripts/
│   ├── bootstrap-mac1.sh
│   ├── configure-git.sh
│   ├── configure-ssh.sh
│   └── clone-repos.sh
└── verify/
    └── verify-mac1.sh
```

Evidence → `shared/evidence/mac-1/`  
Certification → `shared/certification/MAC-1.md`

---

## Architecture

```text
Operator Console (Mac)
        │
        ├─ GitHub
        ├─ ssh lab     → Ubuntu Server
        └─ ssh arch    → Arch (on-demand)
```

See [`shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md`](../../shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md).

---

*SmoothOperator™ · MAC-1*
