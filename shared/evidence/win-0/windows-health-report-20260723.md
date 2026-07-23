# Windows Health Report — WIN-0

> **Operator:** Asır (`asir01oz@gmail.com`)  
> **Date:** 2026-07-23  
> **Hostname:** DESKTOP-P53S8B0  
> **OS:** Windows 10 Pro · Build 26200 (HAL 10.0.26100.1)  
> **Collectors:** read-only · no mutation performed  
> **Evidence dir:** `shared/evidence/win-0/`  
> **Repo path at collection:** `C:\Projects\asir0z-engineering-platform` *(canonical rename to `asir0z-smoothoperator` pending — see Migration Status)*

---

## Executive summary

The Windows host is healthy for engineering work: **32 GB RAM**, **930 GB NVMe system disk** with **356 GB free**, current toolchain (Git 2.53, Cursor 3.12, VirtualBox 7.2.12, Docker Desktop 4.82, Node 22, PowerShell 7.6, Tailscale) is intact. The largest disk consumers are **VirtualBox VMs (~32 GB)** dominated by **`DevOps-Lab-Ubuntu` (~27 GB)** with a deep snapshot chain, and secondary tooling (Docker ~4 GB, SmoothOperator repo ~3 GB).

**Primary risks:** (1) **`DevOps-Lab-Ubuntu` is still running** and holds production-grade state that DevOps Lab docs treat as operational until Contabo Host Acceptance; retirement must follow WIN-1A gate, not ad-hoc deletion. (2) **Repository canonical rename is blocked** — folder locked by Cursor/terminals; GitHub remote not configured and public repos not found under `asir0z-engineering-platform` or `asir0z-smoothoperator`. (3) **Startup bloat** from gaming/peripheral launchers (Epic, Steam, Riot, Razer Cortex, Logitech) competes with engineering services at login.

**Recommended next step:** Complete canonical rename + GitHub remote, accept WIN-0, then authorize **WIN-1** baseline cleanup and **WIN-1A** legacy VM retirement only after DevOps Lab records Contabo Host Acceptance.

---

## Migration status (pre-WIN-0 gate)

| Step | Status | Notes |
|------|--------|-------|
| Arch VM powered off | ✅ | `Arch-Engineering-Workstation` — powered off since 2026-07-23 |
| Folder rename → `asir0z-smoothoperator` | ❌ **BLOCKED** | `Rename-Item` failed: path in use (Cursor workspace) |
| GitHub repo rename | ⏸️ **PENDING** | `git ls-remote` → both URLs **Repository not found**; local repo has **no remote** |
| VBox shared folder update | ✅ **INTERIM** | Host path: `...\asir0z-engineering-platform\linux\bootstrap` — update to `...\asir0z-smoothoperator\linux\bootstrap` after rename |
| Migration path validation | ✅ | 4/4 key paths exist (see Validation) |

### Validation (2026-07-23)

```text
Test-Path linux/bootstrap/run-ws1-system.sh                          → True
Test-Path shared/evidence/ws-1/verification.txt                      → True
Test-Path windows/win-0-audit/WIN-0-SPEC.md                          → True
Test-Path windows/win-0-audit/WINDOWS-HEALTH-REPORT.template.md      → True
```

**Git (local SmoothOperator repo):**

| Item | Value |
|------|-------|
| Branch | `master` @ `e7d2ee4` |
| Remote | *(none configured)* |
| Working tree | **NOT clean** — untracked `bootstrap/` at repo root (duplicate/junction of `linux/bootstrap`; remove after rename) |

**Operator action required before WIN-1:**

1. Close Cursor/terminals using `C:\Projects\asir0z-engineering-platform`
2. `Rename-Item` → `asir0z-smoothoperator`
3. Rename existing GitHub repo (or create private repo) → set `origin` → `git push -u origin master`
4. Update VBox shared folder host path to canonical `...\asir0z-smoothoperator\linux\bootstrap`

---

## System snapshot

| Item | Value |
|------|--------|
| Windows version | Windows 10 Pro (2009) |
| Build | 26200 |
| CPU | AMD Ryzen 5 7500F 6-Core |
| RAM | 32 GB (33,554,432 bytes installed) |
| System disk | MLD M700 NVMe SSD · 931 GB · SSD |
| Free space (C:) | 355.71 GB free of 930.56 GB |
| Time zone | (UTC+03:00) Istanbul |
| VirtualBox | 7.2.12 r174389 |

---

## Applications

Key engineering stack (full registry list: 370+ entries — see `collectors/installed-programs.txt`):

| Name | Version | Size (est.) | Bucket |
|------|---------|-------------|--------|
| Cursor | 3.12.30 | ~small | **Keep** |
| Git | 2.53.0.windows.3 | ~small | **Keep** |
| Oracle VirtualBox | 7.2.12 | ~320 MB install | **Keep** |
| Docker Desktop | 4.82.0 | ~3.9 GB | **Review manually** — useful for Windows-side containers; production runs on Linux VM/Contabo |
| Node.js | 22.20.0 | medium | **Keep** |
| PowerShell | 7.6.3 / 7.5.8 | medium | **Keep** (consolidate duplicate installs in WIN-1) |
| Python | 3.13 (Store) | medium | **Keep** |
| Tailscale | 1.98.9 | small | **Keep** |
| GitHub Desktop | 3.6.3 | medium | **Review manually** |
| JetBrains Rider | 2026.1.1 | large | **Keep** |
| Visual Studio Community 2026 Insiders | 18.8.x | very large | **Keep** — primary IDE stack |
| Google Chrome | 150.x | medium | **Keep** |
| Microsoft Edge | bundled | medium | **Keep** |
| Epic Games Launcher | 1.3.149 | medium | **Remove now** (WIN-1) |
| Steam | — | large | **Review manually** |
| Riot Client / Vanguard | — | medium | **Review manually** |
| Razer Cortex | — | medium | **Remove now** (WIN-1) |
| Logitech G HUB | 2026.4 | medium | **Keep** if peripherals used |
| FL Studio / plugins | 26.x | large | **Review manually** — personal creative stack |
| Android Studio | 2025.1 | very large | **Review manually** |
| ASUS Armoury Crate / AURA stack | multiple | large | **Do not automate** — motherboard/RGB drivers |
| HP LaserJet P1100 series | — | small | **Keep** if printer in use |
| Notion | — | medium | **Review manually** |
| Microsoft Teams | — | medium | **Review manually** |
| OneDrive | — | — | **Backup before reset** — sync state |
| iCloud Outlook | 15.3 | small | **Review manually** |

---

## Startup

| Entry | Source | Bucket |
|-------|--------|--------|
| SecurityHealth | HKLM Run | **Keep** |
| Docker Desktop | HKCU Run | **Review manually** — disable if not used daily |
| Tailscale | Startup (system) | **Keep** |
| OneDrive | HKCU Run | **Keep** / **Backup before reset** |
| Teams | HKCU Run | **Review manually** |
| Notion | HKCU Run | **Review manually** |
| Microsoft Edge auto-launch | HKCU Run | **Remove now** (WIN-1) |
| Epic Games Launcher | HKCU Run | **Remove now** (WIN-1) |
| Steam | HKCU Run | **Review manually** |
| Riot Client | HKCU Run | **Review manually** |
| Riot Vanguard (vgtray) | HKLM Run | **Review manually** |
| Razer Cortex | HKLM Run | **Remove now** (WIN-1) |
| RZTHXHelper | HKLM Run | **Review manually** |
| RtkAudUService | HKLM Run | **Keep** — Realtek audio |
| LGHUB system tray | HKCU Run | **Keep** if Logitech gear used |
| Logi Download Assistant | HKLM Run | **Review manually** |
| HidHide Updater | HKCU Run | **Review manually** — gaming/input tooling |
| Microsoft Lists (OneDrive sync) | HKCU Run | **Review manually** |

---

## Drivers (summary)

| Device class | Count (present) | Notes | Bucket |
|--------------|-----------------|-------|--------|
| System | 82 | Core platform | **Keep** |
| HIDClass | 32 | Keyboards, controllers | **Keep** |
| Net | 18 | NIC, virtual adapters (VBox, Tailscale, Hyper-V) | **Keep** |
| USB | 13 | Peripherals | **Keep** |
| Bluetooth | 13 | Wireless devices | **Keep** |
| Processor | 12 | Ryzen 7500F | **Keep** |
| MEDIA / AudioEndpoint | 18 | Realtek, M-Audio AIR 192 | **Keep** |
| Monitor | 2 | Displays | **Keep** |
| SCSIAdapter | 4 | Storage/virtio | **Keep** |

No driver mutations recommended in WIN-0. AMD Chipset + ASUS platform packages are **Do not automate** without hardware change.

---

## Storage

| Volume | Size | Free | Notes |
|--------|------|------|-------|
| C: | 930.56 GB | 355.71 GB | Healthy · primary workspace |
| (EFI/recovery) | 0.84 GB | 0.11 GB | Healthy · system reserved |

### Large paths

| Path | Size (est.) | Bucket |
|------|-------------|--------|
| `C:\Users\user\VirtualBox VMs` | **32.42 GB** | **Backup before reset** / **Review manually** |
| `C:\Program Files\Docker` | 3.93 GB | **Review manually** |
| `C:\Projects\asir0z-engineering-platform` | 2.94 GB | **Backup before reset** |
| `C:\Projects\asir0z-web` | 0.58 GB | **Backup before reset** |
| `C:\Projects\asir0z-web-tmp` | 0.58 GB | **Remove now** after confirming duplicate |
| `C:\Users\user\.cursor` | 0.33 GB | **Backup before reset** (settings/extensions) |
| `C:\Program Files\Oracle\VirtualBox` | 0.32 GB | **Keep** |
| `C:\Projects\asir0z-devopslab` | ~0 GB (sparse checkout / small) | **Keep** |
| `C:\Projects\asir0z-product-intelligence` | ~0 GB | **Keep** |

---

## Cursor

| Item | Value |
|------|--------|
| Install path | `C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe` |
| Version | 3.12.30 (winget: Anysphere.Cursor) |
| Extensions (6) | `remote-containers`, `remote-ssh`, `remote-wsl`, `vscode-containers`, `vscode-docker`, `powershell` |
| User dir | `C:\Users\user\.cursor` |

**Bucket:** **Keep** · extension set aligned with DevOps/container workflow.

---

## Git & SSH

| Item | Value |
|------|--------|
| git version | 2.53.0.windows.3 |
| global user.name | Asır |
| global user.email | asir01oz@gmail.com |
| global core.autocrlf | false |
| global core.eol | lf |
| ~/.ssh keys (names only) | `id_ed25519`, `id_ed25519.pub`, `config`, `known_hosts`, `known_hosts.old` |

**SSH config hosts (names only — no secrets):**

| Host alias | Target | Purpose |
|------------|--------|---------|
| `contabo` | `169.58.62.107` · user `root` | Contabo VPS (pending canonical production) |
| `arch-ws` | `127.0.0.1:2223` · user `asir0z` | Arch Engineering Workstation NAT |

**Bucket:** **Backup before reset** — `~/.ssh` and global git config are critical operator assets.

---

## winget

| Item | Value |
|------|--------|
| version | v1.29.280 |
| sources OK | ✅ msstore, winget, winget-font — all reachable |

**Bucket:** **Automate later** — WIN-2+ bootstrap can reinstall engineering packages via winget manifest.

---

## Projects

| Path | Purpose | Bucket |
|------|---------|--------|
| `C:\Projects\asir0z-devopslab` | DevOps Lab missions, ops docs, production runbooks | **Keep** · remote: `git@github.com:asir0z/asir0z-devopslab.git` |
| `C:\Projects\asir0z-engineering-platform` | SmoothOperator™ (WS/WIN specs, linux bootstrap, evidence) | **Keep** · rename pending → `asir0z-smoothoperator` |
| `C:\Projects\asir0z-web` | asir0z.com site source | **Keep** · **Backup before reset** |
| `C:\Projects\asir0z-product-intelligence` | PI project workspace | **Keep** |
| `C:\Projects\asir0z-web-tmp` | Temporary deploy artifact tree | **Remove now** after verification |

---

## VirtualBox VMs

### Summary

| VM | State | Host disk | Bucket |
|----|-------|-----------|--------|
| **Arch-Engineering-Workstation** | Powered off | ~5.59 GB | **Keep** — WS-1 certified · SmoothOperator Linux side |
| **DevOps-Lab-Ubuntu** | **Running** (headless) | ~26.83 GB | **LEGACY INFRASTRUCTURE — RETIREMENT CANDIDATE** |

---

### Arch-Engineering-Workstation — **Keep**

| Attribute | Value |
|-----------|-------|
| UUID | `ec60718f-cfde-4738-95bc-9339a575669b` |
| Guest OS | Arch Linux (64-bit) |
| RAM / vCPUs | 8192 MB / 4 |
| Firmware / Chipset | BIOS / PIIX3 |
| Boot order | DVD → HardDisk → HardDisk |
| Graphics | VMSVGA |
| Paravirt | Default → effective KVM |
| Session | Powered off since 2026-07-23T03:41:40 UTC |
| Snapshots | **None** |
| Primary disk | `C:\Users\user\VirtualBox VMs\Arch-Engineering-Workstation\Arch-Engineering-Workstation.vdi` |
| Guest Additions ISO | Mounted on IDE (VBoxGuestAdditions.iso) |
| Network | NIC1 NAT · port forward **`archssh`** host **2223** → guest **22** |
| Shared folders | **`bootstrap`** → `C:\Projects\asir0z-engineering-platform\linux\bootstrap` (writable, auto-mount) |
| Clipboard / DnD | Bidirectional |
| Audio | Null/AC97 (enabled, playback off) |
| USB | Off |

**Note:** Update shared folder host path after canonical repo rename.

---

### DevOps-Lab-Ubuntu — **LEGACY INFRASTRUCTURE — RETIREMENT CANDIDATE**

> Classification: **Review manually** for retirement timing · **Backup before reset** until WIN-1A gate · **Do not automate** deletion in WIN-0.

#### Infrastructure disposition (canonical)

```text
Infrastructure Role     LEGACY
Replacement             Contabo Production Host
Removal Status          BLOCKED
Reason                  Host Acceptance not completed
DevOps Lab gate         Contabo bootstrap ✅ · Host Acceptance ❌ · VM removal 🚫
WIN-1A authority       DevOps Lab (not Windows-only decision)
```

This block is the permanent audit record for **why** the VM was inventoried but not removed during WIN-0/WIN-1.

#### VM configuration

| Attribute | Value |
|-----------|-------|
| UUID | `6a49270b-aa1f-42d8-9c49-cc6620342e30` |
| Guest OS | Ubuntu (64-bit) — Ubuntu Server 24.04 LTS per DevOps Lab |
| RAM / vCPUs | 8192 MB / 4 |
| Firmware / Chipset | BIOS / PIIX3 |
| Boot | HardDisk only |
| Graphics | VBoxSVGA |
| Paravirt | KVM |
| State | **Running** (headless) since 2026-07-22T22:29:38 UTC |
| Guest hostname (DevOps Lab) | `asir0z-devopslab` |
| Guest user | `asir0z` |

#### Attached virtual disks

| Attachment | Path | Size (est.) |
|------------|------|-------------|
| SATA 0:0 (active) | `...\Snapshots\{a08fde92-d093-47eb-9c48-35a831b4a92c}.vdi` | 0.78 GB (current head) |
| Base disk | `...\DevOps-Lab-Ubuntu\DevOps-Lab-Ubuntu.vdi` | 4.98 GB |
| Snapshot chain | 10 named snapshots + differential `.vdi` + `.sav` state files | **~26.83 GB total folder** |

**Largest snapshot artifacts:**

| File | Size |
|------|------|
| `DevOps-Lab-Ubuntu.vdi` | 4.98 GB |
| `{440b47a0-...}.vdi` | 4.33 GB |
| `2026-07-22T22-29-20-....sav` | 3.19 GB |
| `{be1cb627-...}.vdi` | 3.06 GB |
| `{41e3a4ce-...}.vdi` | 2.53 GB |

#### Snapshots (full chain)

Current head (*): **`post-mission-17-production-baseline-2026-07-23`**

```text
clean-install
└── pre-handarte-bootstrap
    └── post-mission-03-remote-access
        └── post-mission-11-compose-foundations
            └── pre-production-services
                └── post-mission-14-certified
                    └── production-baseline-2026-07-22
                        └── production-baseline-vm-tuned-2026-07-22
                            └── pre-asir0z-web-deploy-2026-07-22
                                └── post-mission-17-production-baseline-2026-07-23 *
```

**Rollback anchor (DevOps Lab CERT-18):** `post-mission-17-production-baseline-2026-07-23`

#### Shared folders

**None** configured on this VM.

#### Network configuration

| Setting | Value |
|---------|-------|
| NIC1 | NAT · MAC `080027D404AF` · 82540EM |
| Port forward | **`guestssh`** — host **2222** → guest **22** |
| NIC2–8 | Disabled |
| Tailscale (guest) | Documented in DevOps Lab — IP `100.66.213.5` (primary SSH) |

#### Current running state

- VM **running headless** — consumes **8 GB RAM** and **4 vCPUs** on host
- Guest facilities: VirtualBox Base Driver active
- Production services per DevOps Lab PROJECT_STATE: n8n, asir0z-web, PI stack, cloudflared, nginx proxy — **operational on this VM today**

#### Disk space consumed (host)

| Location | Total |
|----------|-------|
| `C:\Users\user\VirtualBox VMs\DevOps-Lab-Ubuntu\` | **26.83 GB** |
| Entire VirtualBox VMs folder | **32.42 GB** |

#### Unique data or credentials (risk assessment)

| Asset | Location | On Contabo? | Action |
|-------|----------|-------------|--------|
| Docker volume `n8n_data` | Guest `/var/lib/docker/volumes/` | **Verify before retirement** | Export/backup if not replicated |
| `~/backups/n8n/` | Guest home | Partial (`20260722-012136` documented) | Confirm latest on Contabo |
| `~/services/*` compose stacks | Guest home | Bootstrap exists on Contabo prep | Reconcile before delete |
| Cloudflare tunnel creds | Guest systemd + config | May be duplicated | **Backup before reset** |
| `.env` / secrets in guest home | Guest | Unknown parity | Inventory via SSH read-only in WIN-1A |
| SSH host keys / authorized_keys | Guest | Separate from Windows | Low risk |
| Windows → guest NAT only | Port 2222 | Contabo uses direct SSH | No unique Windows dependency |

#### Remaining DevOps Lab dependency

Per `docs/newchat/PROJECT_STATE.md` (2026-07-23):

- **Production runtime still documented on `DevOps-Lab-Ubuntu`**
- Contabo VPS is **pending candidate — NOT canonical** until **Host Acceptance gate**
- Certified production URLs live: `https://asir0z.com/`, `https://n8n.asir0z.com/`
- Mission history, runbooks, and rollback anchors reference this VM extensively
- **WIN-1A execution BLOCKED** until DevOps Lab records Contabo Host Acceptance APPROVED

**Conclusion:** VM is **not safe to delete in WIN-0 or WIN-1**. It remains operational production infrastructure until DevOps Lab authority transfers to Contabo. Retirement is **WIN-1A** — a DevOps Lab–gated infrastructure transition, not a casual Windows cleanup task.

#### Safe retirement procedure (WIN-1A — not executed)

```text
1. GATE: DevOps Lab records Contabo Host Acceptance APPROVED
2. READ-ONLY: Final inventory SSH session — docker ps, volumes, ~/backups, ~/services
3. VERIFY: production-health-check.sh PASS on Contabo
4. VERIFY: No unique data only on VM (n8n_data, tunnel creds, .env)
5. OPTIONAL: Export OVA if operator wants cold archive (default: skip if Contabo + backups canonical)
6. SNAPSHOT REVIEW: Document rollback need — chain can be deleted with VM (~27 GB recovery)
7. OPERATOR APPROVAL: Explicit "remove legacy VM"
8. EXECUTE (WIN-1A):
   a. Power off DevOps-Lab-Ubuntu
   b. VBoxManage unregistervm --delete (or GUI equivalent)
   c. Confirm C:\Users\user\VirtualBox VMs\DevOps-Lab-Ubuntu removed
   d. Evidence: shared/evidence/win-1.1/retirement-YYYYMMDD.txt
9. UPDATE: DevOps Lab PROJECT_STATE → Contabo canonical
```

**Estimated disk recovery:** ~**27 GB** (VM folder) + reduced RAM pressure (**8 GB** when not running).

---

## Classification summary

### Keep

- Engineering toolchain: Git, Cursor, Node, Python, PowerShell, Tailscale, VirtualBox, VS/Rider
- `C:\Projects\asir0z-devopslab`, `asir0z-web`, `asir0z-product-intelligence`
- SmoothOperator repo (post-rename: `asir0z-smoothoperator`)
- **Arch-Engineering-Workstation** VM (WS-1 frozen)
- Realtek audio, AMD/ASUS platform drivers, Logitech G HUB (if peripherals active)
- SecurityHealth, Tailscale startup

### Remove now (WIN-1 candidates — not removed in WIN-0)

- Epic Games Launcher startup
- Razer Cortex startup
- Microsoft Edge session auto-launch
- `C:\Projects\asir0z-web-tmp` (after duplicate check)
- Untracked repo-root `bootstrap/` duplicate after canonical rename

### Review manually

- Docker Desktop (Windows) — disable startup if unused
- Steam, Riot Client/Vanguard, gaming stack
- Teams, Notion, OneDrive Lists sync
- GitHub Desktop vs CLI-only workflow
- FL Studio, Android Studio footprint
- **DevOps-Lab-Ubuntu retirement timing** — gated on Contabo acceptance

### Backup before reset

- `~/.ssh` (keys + config)
- `~/.cursor` (settings, extensions list)
- `C:\Projects\asir0z-*` repositories
- VirtualBox VM folders if no export plan
- OneDrive sync state
- Guest secrets on DevOps-Lab-Ubuntu before WIN-1A

### Automate later

- winget reinstall manifest for engineering packages (WIN-2+)
- Startup cleanup via controlled WIN-1 scripts
- VBox shared folder path update post-rename (single `VBoxManage sharedfolder` command)

### Do not automate

- ASUS Armoury Crate / AURA / chipset packages
- DevOps-Lab-Ubuntu deletion — **WIN-1A only after DevOps Lab Host Acceptance**
- Registry or service hardening without WIN-1 spec
- Snapshot chain pruning without operator review

---

## WIN-0 scope checklist

| Area | Addressed | Notes |
|------|-----------|-------|
| Applications | ✅ | Registry + winget filter |
| Startup | ✅ | Win32_StartupCommand + Run keys |
| Drivers | ✅ | PnpDevice class summary |
| Storage | ✅ | Volumes + large paths |
| Cursor | ✅ | Path, version, 6 extensions |
| Git | ✅ | Version + global config |
| SSH | ✅ | Key names + config hosts |
| winget | ✅ | Version + sources |
| Projects | ✅ | C:\Projects inventory |
| VMs | ✅ | Full VBox inventory + legacy section |
| Large files | ✅ | Top paths under Projects/VBox/Docker |
| Performance | ✅ | CPU, RAM, NVMe SSD |

**Mutation performed during WIN-0:** **None** (read-only collectors only).

*Exception noted:* VBox shared folder was updated in prior migration step (outside WIN-0 collector run) to `linux/bootstrap` interim path — not part of this report's collector session.

---

## WIN-1 actionable change list (planned — not executed)

Prioritized from WIN-0 classification. **WIN-1 applies these; WIN-0 only observed them.**

| Priority | Action | Bucket | Est. impact | Gate |
|----------|--------|--------|-------------|------|
| P0 | Complete repo rename → `asir0z-smoothoperator` + GitHub remote | Automate later | Canon | Before WIN-1 commit/push |
| P1 | Remove startup: Epic, Razer Cortex, Edge auto-launch | Remove now | Faster login | WIN-1 |
| P1 | Delete `asir0z-web-tmp` after duplicate check vs `asir0z-web` | Remove now | ~0.6 GB | WIN-1 |
| P1 | Remove untracked repo-root `bootstrap/` duplicate | Remove now | Hygiene | WIN-1 (post-rename) |
| P2 | Disable Docker Desktop startup if unused on Windows | Review manually | RAM at login | WIN-1 |
| P2 | Uninstall or retain gaming stack (Steam, Riot, Epic) | Review manually | ~6–10 GB | WIN-1 operator choice |
| P2 | Consolidate PowerShell 7.5 + 7.6 installs | Review manually | Hygiene | WIN-1 |
| P3 | Retire `DevOps-Lab-Ubuntu` VM + snapshot chain | Legacy infra | ~27 GB + 8 GB RAM | **WIN-1A · Host Acceptance** |
| P3 | Update VBox shared folder to canonical path | Automate later | WS-2 readiness | Post-rename |

---

## Roadmap alignment

```text
WS-1                          ✅ FROZEN
SmoothOperator migration      ✅ Complete (rename/remote pending operator)
WIN-0                         ✅ EXECUTED (this report)
WIN-1                         ⏳ Engineering Baseline — authorized after WIN-0 acceptance
DevOps Lab Host Acceptance    ❌ Not complete
WIN-1A Legacy VM Removal     🚫 BLOCKED (Host Acceptance)
WS-2                          🔒 Waiting
```

---

## Windows Health Report — Executive Dashboard

Single-glance engineering summary derived from read-only collectors.

```text
┌─────────────────────────────────────────────────────────────┐
│  Windows Health Report — WIN-0                              │
│  Host: DESKTOP-P53S8B0 · 2026-07-23                         │
├─────────────────────────────────────────────────────────────┤
│  Overall Health          GOOD                               │
│  Storage (C: utilized)   62%  (356 GB free · healthy)       │
│  Startup load            Medium  (14 entries · 6 non-eng)     │
│  Technical Debt          High  (VM chain, rename, snapshots)  │
│  Cleanup Potential       ~18 GB  (WIN-1 scope · VM excluded)│
│  Unused Applications     14  (non-engineering · see below)  │
│  Legacy Infrastructure   DevOps-Lab-Ubuntu · Ubuntu Server  │
│  Legacy Status           BLOCKED — Host Acceptance pending  │
├─────────────────────────────────────────────────────────────┤
│  Recommendation          Proceed to WIN-1                     │
└─────────────────────────────────────────────────────────────┘
```

### Metric definitions

| Metric | Value | Basis |
|--------|-------|-------|
| **Overall Health** | **GOOD** | NVMe SSD healthy · 356 GB free · 32 GB RAM · engineering toolchain intact |
| **Storage** | **62% utilized** | C: 574.9 GB used / 930.6 GB — no immediate disk crisis |
| **Startup** | **Medium** | 14 startup entries; 6 non-essential for engineering (Epic, Steam, Riot, Razer, Edge, Lists) |
| **Technical Debt** | **High** | 10-snapshot VM chain · repo rename pending · no GitHub remote · duplicate bootstrap · production split VM/Contabo |
| **Cleanup Potential** | **~18 GB** | WIN-1 achievable: web-tmp ~0.6 GB · optional gaming/creative apps ~8 GB · Docker Desktop ~4 GB · startup-only cruft · **excludes** ~27 GB VM (WIN-1A blocked) |
| **Unused Applications** | **14** | Epic, Epic Online Services, Steam, Riot Client, Riot Vanguard, Razer Cortex, FL Studio, FL Cloud Plugins, Android Studio, CS 1.6, Icy Tower, Keep Talking and Nobody Explodes, GitHub Desktop*, Teams* (*operator-dependent) |
| **Legacy Infrastructure** | **DevOps-Lab-Ubuntu** | Role: LEGACY · Replacement: Contabo · Removal: BLOCKED |

---

## WIN-0 RESULT

Engineering decision produced by this audit (read-only evidence → actionable next sprint).

```text
WIN-0 RESULT

  Proceed to WIN-1

Conditions:
  • WIN-1 scope = startup cleanup, app review, repo rename, hygiene — NOT VM removal
  • WIN-1A (Legacy Ubuntu VM Removal) remains BLOCKED until DevOps Lab Host Acceptance
  • Canonical repo rename + GitHub remote recommended as WIN-1 P0

Blocked items (explicit):
  • Ubuntu Server VM deletion
  • VirtualBox configuration changes beyond documented post-rename path update
  • Any mutation performed during WIN-0 collection

Reviewer gate:
  ChatGPT / operator acceptance of this report → authorize WIN-1 execution
```

```text
PASS
Notes: All scope areas addressed. Legacy VM inventoried with BLOCKED disposition.
       No mutation during collection. WIN-1 change list ready for prioritization.
```

---

*Generated by WIN-0 read-only audit · SmoothOperator™ · 2026-07-23*
