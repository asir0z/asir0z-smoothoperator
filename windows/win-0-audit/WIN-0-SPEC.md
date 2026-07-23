# WIN-0 — Current State Audit

> **Version:** 1.0 · 2026-07-23  
> **Status:** SPECIFICATION — **not authorized for mutation**  
> **Platform:** SmoothOperator™ · Windows  
> **Lifecycle target:** Evidence → Certification → FROZEN (same discipline as WS-1)

---

## 1. Purpose

Read-only audit of the operator Windows host. WIN-0 produces a **Windows Health Report** that feeds three downstream tracks:

```text
Current Windows cleanup plan     (WIN-1 input)
        +
Clean-install inventory        (future SSD reset)
        +
Future Windows bootstrap design  (WIN-2+)
```

**WIN-0 does not mutate the system.**

Forbidden during WIN-0:

- Uninstall applications
- Registry edits
- Service or startup changes
- Cleanup scripts
- Disk deletion

---

## 2. Scope (collect only)

| Area | Examples |
|------|----------|
| Applications | Installed programs, winget list, large footprints |
| Startup | Task Manager startup, scheduled tasks (read) |
| Drivers | Device Manager summary, driver dates |
| Storage | Volumes, free space, large folders |
| Cursor | Install path, extensions count, settings location |
| Git | Version, global config keys (no secrets), SSH keys list |
| SSH | `~/.ssh` inventory (names only, no private key content) |
| winget | Version, source health |
| Projects | `C:\Projects` tree summary |
| VMs | VirtualBox VM list, disk sizes |
| Large files | Top consumers under user profile / Projects |
| Performance | RAM, CPU model, disk type if available |

---

## 3. Report classification (required)

Every finding must land in one bucket:

| Bucket | Meaning |
|--------|---------|
| **Keep** | Retain through reset; reinstall or preserve explicitly |
| **Remove now** | Safe to remove before or during WIN-1 (listed only — WIN-0 does not remove) |
| **Review manually** | Operator decision required |
| **Backup before reset** | Projects, keys, configs, VMs, personal data |
| **Automate later** | Recreate via winget, PowerShell, or repo bootstrap |
| **Do not automate** | Hardware-specific, sensitive, or interactive-only |

---

## 4. Execution roles

| Role | Responsibility |
|------|----------------|
| **Operator** | Run read-only collectors; paste report |
| **Cursor** | Maintain spec, template, collector scripts (read-only) |
| **ChatGPT** | Review report; certify WIN-0; authorize WIN-1 |

---

## 5. Evidence gate

Output file: `shared/evidence/win-0/windows-health-report-YYYYMMDD.md`

Acceptance:

- [ ] All scope areas addressed or marked N/A with reason
- [ ] Every item classified into a bucket
- [ ] No mutation performed during collection
- [ ] Backup list explicit before any future reset

ChatGPT result: **`WIN-0 ACCEPTED`** or **`WIN-0 REJECTED`**

---

## 6. Next sprint (not authorized here)

**WIN-1 — Engineering Baseline:** controlled cleanup from WIN-0 `Remove now` + `Review manually` decisions.
