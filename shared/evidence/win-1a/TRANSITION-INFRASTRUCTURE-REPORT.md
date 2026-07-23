# TRANSITION INFRASTRUCTURE REPORT — DevOps-Lab-Ubuntu

> **Sprint:** WIN-1A entry document (inventory only — **no removal**)  
> **Platform:** SmoothOperator™ · Windows host · DevOps Lab production guest  
> **Date:** 2026-07-23  
> **Review:** APPROVED ✅ — canonical evidence accepted  
> **Certification:** `shared/certification/TRANSITION-INFRASTRUCTURE-REVIEW.md`  
> **Collectors:** read-only · VBoxManage + SSH (NAT `:2222`)  
> **Evidence:** `shared/evidence/win-1a/collectors/`

---

## Disposition (single glance)

```text
Canonical Host           Ubuntu VM (DevOps-Lab-Ubuntu)
Target Canonical Host    Contabo
Migration Phase          Transition
Retirement Readiness     NO
WIN-1A Status            BLOCKED
```

**Terminology:** **Transition Infrastructure** — active production with **scheduled retirement**. Not unused legacy.

```text
Production  →  Scheduled Retirement

Ubuntu VM   →  Production (today)
Contabo     →  Candidate (not ready)
```

---

## Executive decision

```text
Can this VM be deleted today?

NO
```

---

## If NO — blocking analysis

### Exactly what blocks removal?

| Blocker | Detail |
|---------|--------|
| **DevOps Lab authority gate** | Contabo **Host Acceptance not completed** — lab VM remains **canonical production runtime** per [HOST-ACCEPTANCE-GATE.md](https://github.com/asir0z/asir0z-devopslab/blob/main/docs/ops/contabo/HOST-ACCEPTANCE-GATE.md) |
| **Live production services** | Four Docker containers healthy + `cloudflared` active on guest |
| **Contabo not ready** | Contabo VPS (`vmi3459972`) has **no running production stack** — no `~/services`, no `production-health-check.sh`, no Docker workloads |
| **Public ingress dependency** | Cloudflare Tunnel credentials and tunnel process live **on this VM only** today |
| **Operator authorization** | WIN-1A explicitly **BLOCKED** until gate + explicit approval |

### What evidence proves this?

| Source | Finding |
|--------|---------|
| DevOps Lab `PROJECT_STATE.md` (2026-07-23) | Production URLs operational · Contabo = **pending candidate** |
| Guest SSH inventory (`guest-inventory.txt`) | `docker ps`: n8n, asir0z-web, gotenberg, lab-proxy **Up (healthy)** · `cloudflared.service` **active** |
| Guest health check | `PASS=14 WARN=1 FAIL=0` · `RESULT=WARN` (disk 82% — monitor, not fail) |
| Contabo SSH (`contabo-comparison.txt`) | `docker ps -a` empty · no services tree · `health-check: absent` |
| WIN-0 report | VM inventoried as **transition asset** · removal **BLOCKED** |

### What production capability would be lost?

| Capability | Impact if VM deleted now |
|------------|--------------------------|
| `https://n8n.asir0z.com/` | **Down** — n8n + PI workflow chain |
| `https://asir0z.com/` / `www` | **Down** — asir0z-web |
| Cloudflare Tunnel ingress | **Down** — tunnel creds on guest (`~/.cloudflared/`) |
| n8n workflows + credentials | **Lost** — Docker volume `n8n_data` |
| Product Intelligence pipeline | **Down** — n8n + Gotenberg + Apify integration |
| Certified rollback chain | **Lost** — 10 VirtualBox snapshots (~27 GB host) |
| Tailscale production SSH | **Disrupted** — guest IP `100.66.213.5` |

### What must happen before retirement?

```text
Ubuntu VM (canonical production today)
        ↓
Contabo Runtime Bootstrap          (partial ✅ · stack not deployed)
        ↓
Parity Verification                (❌)
        ↓
Host Acceptance                    (❌)
        ↓
Production Cutover                 (❌)
        ↓
Observation Window (24–72h)        (❌)
        n8n · tunnel · proxy · Telegram · PI · logs
        ↓
Verify no unique data only on VM   (❌)
        ↓
Operator explicit WIN-1A auth      (❌)
        ↓
WIN-1A execution (SmoothOperator)
        ↓
Archive
```

### Estimated disk recovery?

| Scope | Recovery |
|-------|----------|
| **Windows host (VBox folder)** | **~26.8 GB** |
| **Windows host RAM pressure** | **8 GB** allocated while running |
| **Guest disk (`/`)** | 19 GB LVM — separate from host recovery; guest data destroyed with VM |

### Estimated recovery difficulty if deleted accidentally?

```text
SEVERITY: CRITICAL · RECOVERY DIFFICULTY: VERY HIGH
```

| Asset | Recovery path | Difficulty |
|-------|---------------|------------|
| n8n workflows/credentials (`n8n_data`) | Restore from `~/backups/n8n/` (latest `20260722-012136`) — may be stale vs live volume | **High** — partial backup only (~2.8 MB tree) |
| Cloudflare tunnel identity | Re-provision tunnel in Cloudflare dashboard + redeploy creds | **High** — manual + DNS downtime |
| `.env` secrets (n8n, PI, web) | From backup vault / manual re-entry | **High** |
| Production compose state | Redeploy from `asir0z-devopslab` runbooks to Contabo | **Medium–High** — hours to days |
| VBox snapshot rollback | **Impossible** if `--delete` used without export | **Critical** |
| Public HTTPS services | Until Contabo cutover complete | **Outage** |

**Bottom line:** Accidental deletion is a **production incident**, not a cleanup mistake.

---

## Full inventory

### VM Name

`DevOps-Lab-Ubuntu`

### Current Role

```text
Infrastructure Class      Transition Infrastructure
Operational Role Today    CANONICAL PRODUCTION HOST
Target Canonical Host     Contabo
Migration Phase           Transition
Retirement Readiness      NO
Removal Status            BLOCKED
Reason                    Parity · cutover · observation not complete
```

Today this VM is **not idle technical debt**. It is the **live production host** until DevOps Lab transfers authority to Contabo.

### Current State

| Layer | State |
|-------|-------|
| VirtualBox | **Running** (headless) since 2026-07-22T22:29:38 UTC |
| Guest OS | Ubuntu 24.04.4 LTS · hostname `asir0z-devopslab` |
| Guest uptime (at inventory) | 6h 21m |
| Guest disk `/` | **82% used** (15G / 19G) — WARN threshold per CERT-18 |
| Guest RAM | 7.8 GiB total · 1.1 GiB used |
| Health gate | `PASS=14 WARN=1 FAIL=0` · `RESULT=WARN` |

### Snapshots

**10 named snapshots** — current head: `post-mission-17-production-baseline-2026-07-23`

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

Rollback anchor (DevOps Lab CERT-18): **`post-mission-17-production-baseline-2026-07-23`**

### Disk Size

| Location | Size |
|----------|------|
| Windows host folder `VirtualBox VMs\DevOps-Lab-Ubuntu\` | **26.83 GB** |
| Guest virtual disk (LVM) | 19 GB (82% utilized) |
| Docker images + cache (guest) | ~7.9 GB (`docker system df`) |
| n8n backups (guest) | ~2.8 MB |

### Shared Folders

**None** on this VM.

*(Arch VM uses separate `bootstrap` share — untouched.)*

### Network Mode

| Setting | Value |
|---------|-------|
| NIC1 | NAT · MAC `080027D404AF` |
| Port forward | **`guestssh`** — host `2222` → guest `22` |
| Tailscale | Active · `100.66.213.5` (primary SSH per DevOps Lab) |
| Public ingress | Cloudflare Tunnel (`cloudflared.service`) |

### SSH Access

| Method | Command |
|--------|---------|
| Tailscale (primary) | `ssh asir0z@100.66.213.5` |
| NAT (secondary) | `ssh -p 2222 asir0z@127.0.0.1` |
| Windows alias | Uses `~/.ssh/id_ed25519` |

### Running Services

**systemd (production-related):**

- `cloudflared.service` — active
- `docker.service` / `containerd.service` — active
- `tailscaled.service` — active
- `ssh.service` — active

**Docker containers:**

| Container | Image | Status | Notes |
|-----------|-------|--------|-------|
| `n8n` | `n8nio/n8n:1.123.66` | healthy | `127.0.0.1:5678` · volume `n8n_data` |
| `asir0z-web` | `asir0z-web:packaged` | healthy | port 3000 internal |
| `gotenberg` | `gotenberg/gotenberg:8-chromium` | healthy | PDF generation for PI |
| `lab-proxy` | `nginx:1.27.4-alpine` | up | `0.0.0.0:18080→80` |

**Compose stacks (`~/services/`):**

- `n8n/` · `product-intelligence/` · `proxy/` · `asir0z-web/` · `cloudflared/`

**Scripts (`~/scripts/`):**

- `ops/production-health-check.sh` (Mission 18 gate — **present and passing with WARN**)
- `deploy/asir0z-web-deploy.sh` · `n8n/` · `cloudflared/` · `product-intelligence/` · `observability/`

### Remaining Dependencies

| Dependency | Relationship |
|------------|--------------|
| **DevOps Lab missions & certs** | MISSION-14…19 certified on this runtime |
| **Public DNS / Cloudflare** | Tunnel terminates on this guest |
| **n8n workflows** | Live state in `n8n_data` volume |
| **Operator runbooks** | Deploy + health scripts reference this host |
| **Windows NAT :2222** | Secondary access path from host |
| **SmoothOperator WIN-1A** | Blocked until DevOps Lab gate |
| **Contabo** | Replacement target — **not production-ready** |

### Data That Exists Only Here (unverified on Contabo)

| Data | Location | Risk if lost |
|------|----------|--------------|
| Live n8n state | Docker volume `n8n_data` | **Critical** |
| Cloudflare tunnel credentials | `~/.cloudflared/*.json`, `cert.pem` | **Critical** |
| Service secrets | `~/services/*/.env` (3 files) | **High** |
| n8n backup archives | `~/backups/n8n/*` (5 timestamps) | **Medium** — may lag live volume |
| Docker build cache | ~3.93 GB reclaimable on guest | **Low** |
| VBox snapshot chain | Windows host | **High** — rollback history |

**Contabo comparison (2026-07-23):** no `~/services`, no running containers, no health script — **production parity not established**.

### Retirement Prerequisites

- [ ] Contabo runtime bootstrap — production stack on Contabo
- [ ] **Parity verification** — Contabo operationally identical to Ubuntu VM
- [ ] Host Acceptance **APPROVED** (DevOps Lab)
- [ ] **Production cutover** — traffic on Contabo
- [ ] **Observation window (24–72h)** — n8n, tunnel, proxy, Telegram, PI, logs normal
- [ ] `production-health-check.sh` exit 0 on Contabo
- [ ] n8n_data + secrets verified on Contabo
- [ ] Operator explicit WIN-1A authorization
- [ ] Evidence per `WIN-1A-TRANSITION-VM-REMOVAL.md`

### Estimated Space Recovery

| When WIN-1A executes | Recovery |
|----------------------|----------|
| Host disk (Windows) | **~27 GB** |
| Host RAM | **8 GB** (while VM was running) |
| Snapshot chain overhead | Included in host folder |

---

## Infrastructure disposition (canonical record)

```text
Canonical Host           Ubuntu VM (DevOps-Lab-Ubuntu)
Target Canonical Host    Contabo
Migration Phase          Transition
Retirement Readiness     NO
Removal Status           BLOCKED
```

---

## WIN-1A readiness

| Question | Answer |
|----------|--------|
| Inventory complete? | **YES** — this document |
| Review approved? | **YES** — `shared/certification/TRANSITION-INFRASTRUCTURE-REVIEW.md` |
| Safe to delete today? | **NO** |
| Entry doc for WIN-1A? | **YES** |
| Next gate | DevOps Lab **Parity → Host Acceptance → Cutover → Observation** |

DevOps Lab mission: [MISSION-20 Production Runtime Migration](https://github.com/asir0z/asir0z-devopslab/blob/main/missions/phase-2/MISSION-20-PRODUCTION-RUNTIME-MIGRATION.md)

When observation window passes, refresh `collectors/` and re-verify Contabo parity before WIN-1A execution.

---

*Read-only inventory · APPROVED ✅ · SmoothOperator™ · 2026-07-23*
