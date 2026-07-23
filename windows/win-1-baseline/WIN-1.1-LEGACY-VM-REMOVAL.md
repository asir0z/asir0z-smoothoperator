# WIN-1.1 — Legacy Infrastructure Cleanup (DevOps-Lab-Ubuntu)

> **Version:** 1.0 · 2026-07-23  
> **Status:** SPECIFICATION — **not authorized for execution** until gate passes  
> **Platform:** SmoothOperator™ · Windows · VirtualBox  
> **Target VM:** `DevOps-Lab-Ubuntu` (legacy local production lab)  
> **Preserve:** `Arch-Engineering-Workstation` — **no changes**

---

## 1. Context

Architecture shift:

```text
Before                          After
──────                          ─────
Windows                         Windows
├── DevOps-Lab-Ubuntu (local)   ├── Arch-Engineering-Workstation
├── Arch VM                     └── VirtualBox (interim)
└── Cursor
                                        ↓
                                Contabo VPS
                                        ↓
                                Ubuntu Server (production)
```

Local Ubuntu Server VM completed its transition role. Removal is **certified infrastructure retirement**, not casual deletion.

---

## 2. DevOps Lab authority gate (mandatory)

Per [DevOps Lab PROJECT_STATE](https://github.com/asir0z/asir0z-devopslab/blob/main/docs/newchat/PROJECT_STATE.md):

> Contabo is **pending candidate** — not canonical until **Host Acceptance gate**.

**WIN-1.1 execution is BLOCKED until DevOps Lab explicitly records:**

- [ ] Contabo Host Acceptance **APPROVED**
- [ ] Runtime bootstrap / production cutover **authorized** (or completed)
- [ ] Canonical production runtime documented as Contabo (not `DevOps-Lab-Ubuntu`)

SmoothOperator does not override DevOps Lab production authority.

---

## 3. Pre-removal inventory (read-only)

| Step | Check |
|------|--------|
| VM identity | `VBoxManage list vms` → `DevOps-Lab-Ubuntu` |
| State | running / powered off |
| Snapshots | `VBoxManage snapshot "DevOps-Lab-Ubuntu" list` |
| Disks | `.vdi` path(s), size |
| NAT rules | `:2222` forward (document only) |
| Unique data | Any file on guest **not** on Contabo / not in repo |
| Export need | OVA/OVF export required? (default: no if Contabo + backups canonical) |
| DevOps Lab docs | References updated to Contabo where applicable |

Output: `shared/evidence/win-1.1/inventory-YYYYMMDD.txt`

---

## 4. Removal checklist (operator confirms ALL)

- [ ] Contabo SSH works (`ssh contabo` or documented alias)
- [ ] Docker healthy on Contabo (if production uses it)
- [ ] DevOps Lab accepts Contabo as canonical production host
- [ ] No unique data remains only on Ubuntu VM
- [ ] Snapshots reviewed — none needed for retention
- [ ] Export not required (or export completed and verified)
- [ ] Operator explicit approval: **remove legacy VM**

---

## 5. Execution sequence (authorized only)

```text
Power Off VM
    ↓
(Optional) Export OVA — if checklist required it
    ↓
Unregister VM (VBoxManage unregistervm)
    ↓
Delete disk files (after path confirmation)
    ↓
VirtualBox inventory verify — only Arch-Engineering-Workstation remains
    ↓
Disk space verification (WIN-1.2)
    ↓
Evidence capture
```

**Example commands (do not run until authorized):**

```powershell
$VBox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
& $VBox controlvm "DevOps-Lab-Ubuntu" acpipowerbutton
# wait poweroff
& $VBox unregistervm "DevOps-Lab-Ubuntu" --delete
# verify: & $VBox list vms
# verify disk: Get-ChildItem "$env:USERPROFILE\VirtualBox VMs"
```

---

## 6. Evidence gate

Capture to `shared/evidence/win-1.1/`:

| File | Content |
|------|---------|
| `inventory-YYYYMMDD.txt` | Pre-removal inventory |
| `removal-YYYYMMDD.txt` | Commands run, timestamps, paths deleted |
| `post-vms.txt` | `VBoxManage list vms` (Arch only) |
| `disk-space.txt` | Free space before/after |
| `certification.md` | Reviewer decision |

**Certification criteria:**

- [ ] Gate §2 DevOps Lab authority satisfied
- [ ] Checklist §4 complete
- [ ] `DevOps-Lab-Ubuntu` absent from VirtualBox
- [ ] `Arch-Engineering-Workstation` untouched
- [ ] Disk space recovered (WIN-1.2)

ChatGPT result: **`WIN-1.1 ACCEPTED`** or **`WIN-1.1 REJECTED`**

Lifecycle after acceptance: **`WIN-1.1 FROZEN`**

---

## 7. Boundaries

| Allowed | Forbidden |
|---------|-----------|
| Remove `DevOps-Lab-Ubuntu` after gate | Touch Arch workstation VM |
| Delete associated VDI after confirm | Modify Contabo production |
| Update SmoothOperator evidence | Change DevOps Lab missions without authorization |
| Document freed disk space | Registry / startup cleanup (WIN-1.0 scope) |

---

## 8. Cursor task (when authorized)

> Evaluate `DevOps-Lab-Ubuntu` as legacy infrastructure. Verify snapshots, disks, export need, and DevOps Lab dependencies. After Contabo canonical status is confirmed in DevOps Lab docs, remove the Ubuntu VM safely, reclaim disk, update VirtualBox inventory, produce evidence. **Do not modify Arch Workstation VM.**

Stop and return evidence if any gate item fails.
