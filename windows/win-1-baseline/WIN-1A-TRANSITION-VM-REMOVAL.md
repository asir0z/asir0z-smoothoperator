# WIN-1A — Transition Infrastructure Retirement (DevOps-Lab-Ubuntu)

> **Version:** 1.1 · 2026-07-23  
> **Status:** SPECIFICATION — **BLOCKED**  
> **Platform:** SmoothOperator™ · Windows · VirtualBox  
> **Target VM:** `DevOps-Lab-Ubuntu` — **transition infrastructure** (canonical production today)  
> **Preserve:** `Arch-Engineering-Workstation` — **no changes**

---

## 1. Context

This is **not a Windows cleanup task**. It is the **final step** after DevOps Lab completes production runtime migration to Contabo.

```text
WIN-1   Engineering Baseline (Windows)     ← parallel · independent
  ↓
        Mission 20 · Parity → Cutover → Observation
  ↓
WIN-1A  Transition VM retirement (Windows)
```

**Entry evidence (APPROVED ✅):** `shared/evidence/win-1a/TRANSITION-INFRASTRUCTURE-REPORT.md`

```text
Canonical Host           Ubuntu VM
Target Canonical Host    Contabo
Migration Phase          Transition
Retirement Readiness     NO
```

---

## 2. DevOps Lab authority gate (mandatory)

Per [HOST-ACCEPTANCE-GATE](https://github.com/asir0z/asir0z-devopslab/blob/main/docs/ops/contabo/HOST-ACCEPTANCE-GATE.md) and [MISSION-20](https://github.com/asir0z/asir0z-devopslab/blob/main/missions/phase-2/MISSION-20-PRODUCTION-RUNTIME-MIGRATION.md):

**WIN-1A execution is BLOCKED until ALL complete:**

- [ ] Contabo runtime bootstrap — production stack deployed
- [ ] **Parity verification** — Contabo operationally identical to Ubuntu VM
- [ ] Host Acceptance **APPROVED**
- [ ] **Production cutover** complete
- [ ] **Observation window (24–72h) PASS** — n8n, tunnel, proxy, Telegram, PI, logs
- [ ] Canonical production documented as Contabo in DevOps Lab PROJECT_STATE
- [ ] Operator explicit WIN-1A authorization

SmoothOperator does not override DevOps Lab production authority.

---

## 3. Pre-removal inventory (read-only)

Refresh collectors before execution even if entry report is approved.

| Step | Check |
|------|--------|
| VM identity | `VBoxManage list vms` → `DevOps-Lab-Ubuntu` |
| State | running / powered off |
| Snapshots | `VBoxManage snapshot "DevOps-Lab-Ubuntu" list` |
| Disks | `.vdi` path(s), size (~27 GB host) |
| Contabo parity | Production healthy on Contabo · observation log PASS |
| Unique data | None remaining only on VM |

Output: `shared/evidence/win-1a/inventory-YYYYMMDD.txt`

**Entry document:** `shared/evidence/win-1a/TRANSITION-INFRASTRUCTURE-REPORT.md`

---

## 4. Removal checklist (operator confirms ALL)

- [ ] Mission 20 observation window PASS
- [ ] Contabo SSH + health gate operational
- [ ] Public URLs verified on Contabo (not VM)
- [ ] No unique data only on Ubuntu VM
- [ ] Snapshots reviewed — export not required (or completed)
- [ ] Operator explicit approval: **retire transition VM**

---

## 5. Execution sequence (authorized only)

```text
Power Off VM
    ↓
(Optional) Export OVA
    ↓
Unregister VM (--delete)
    ↓
Verify VirtualBox — only Arch-Engineering-Workstation remains
    ↓
Disk space evidence
    ↓
Certification
```

---

## 6. Evidence gate

Capture to `shared/evidence/win-1a/`:

| File | Content |
|------|---------|
| `inventory-YYYYMMDD.txt` | Pre-removal refresh |
| `removal-YYYYMMDD.txt` | Commands · timestamps |
| `post-vms.txt` | Arch VM only |
| `disk-space.txt` | Before/after |

Certification: `shared/certification/WIN-1A.md`

ChatGPT result: **`WIN-1A ACCEPTED`** or **`WIN-1A REJECTED`** → **`WIN-1A FROZEN`**

---

## 7. Boundaries

| Allowed | Forbidden |
|---------|-----------|
| Remove `DevOps-Lab-Ubuntu` after full gate | Touch Arch workstation VM |
| Delete VDI after confirm | Delete before observation PASS |
| Document ~27 GB recovery | Modify Contabo production |
| Update evidence | WIN-1 startup/app scope |

---

## 8. Cursor task (when authorized)

> Retire `DevOps-Lab-Ubuntu` after Mission 20 observation PASS. Verify Arch VM untouched. Produce evidence. **Do not remove before Contabo is canonical production.**

Stop if any gate item fails.

---

*SmoothOperator™ · asir0z-smoothoperator*
