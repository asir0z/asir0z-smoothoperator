# WIN-1A evidence

## Entry document — APPROVED ✅

**`TRANSITION-INFRASTRUCTURE-REPORT.md`**

Certification: `shared/certification/TRANSITION-INFRASTRUCTURE-REVIEW.md`

```text
Canonical Host           Ubuntu VM
Target Canonical Host    Contabo
Migration Phase          Transition
Retirement Readiness     NO
```

## Collectors (2026-07-23)

| File | Source |
|------|--------|
| `collectors/guest-inventory.txt` | SSH · NAT `:2222` |
| `collectors/contabo-comparison.txt` | SSH · `contabo` |
| `collectors/vbox-showvminfo.txt` | VBoxManage |
| `collectors/vbox-snapshots.txt` | VBoxManage |

## Execution evidence (future)

- `removal-YYYYMMDD.txt` · `post-vms.txt` · `disk-space.txt`

Spec: `windows/win-1-baseline/WIN-1A-TRANSITION-VM-REMOVAL.md`  
DevOps Lab: [MISSION-20](https://github.com/asir0z/asir0z-devopslab/blob/main/missions/phase-2/MISSION-20-PRODUCTION-RUNTIME-MIGRATION.md)
