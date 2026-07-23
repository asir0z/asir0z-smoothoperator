# SmoothOperator™ — Platform State

> **Canonical living state document** — update when certification changes platform status  
> **Date:** 2026-07-23  
> **Phase:** Operational maturity — **bootstrap formally closed**  
> **Authority:** Certification Authority

**Bootstrap dönemi resmen kapandı.** `%95 Migration`, `P0 Pending` ve benzeri ifadeler **tarihsel kayıt** — bu belgeye geri dönülmez.

---
**Omurga tamam** — Foundation · Governance · Lifecycle **FROZEN**; **Execution** aktif. Bundan sonraki değer yeni klasörlerde değil, gerçek kullanımdan gelen sürtünmelerin evidence ile kapatılmasında.

**Certification Authority** modeli [`README.md`](README.md) içinde yönetiliyor:

```text
Specification
  ↓
Evidence
  ↓
Review
  ↓
Decision
```

Kararlar:

| Result | Meaning |
|--------|---------|
| **APPROVED** | Proceed or FROZEN |
| **REJECTED** | Stop |
| **CHANGES REQUIRED** | Revise and re-submit |

---

## Platform maturity

```text
Foundation        FROZEN ✅
Governance        FROZEN ✅
Lifecycle         FROZEN ✅
Migration         100% · CERTIFIED · FROZEN ✅
Execution         ACTIVE ✅
```

---

## Migration

```text
STATUS          100% COMPLETE
CERTIFICATION   APPROVED ✅
LIFECYCLE       FROZEN
```

Migration tamamlandı; bu konu kapandı.

Evidence: [`shared/evidence/migration/p0-closeout-20260723.txt`](../evidence/migration/p0-closeout-20260723.txt)  
Certification: [`MIGRATION.md`](MIGRATION.md)

---

## WIN-1

```text
Infrastructure   100% · CERTIFIED · FROZEN BASELINE ✅
Core             OPEN — Observed Friction driven
```

```text
Migration              ██████████ 100% ✅
WIN-1 Infrastructure   ██████████ 100% ✅
WIN-1 Core             ░░░░░░░░░░
Mission 20             ░░░░░░░░░░
```

Operator priority *(2026-07-23)*:

```text
1. Infrastructure  ✅ certified — daily use begins
2. Core            ← next (friction-driven)
3. Mission 20      ← when WIN-1 does not block work
```

Infrastructure baseline evidence: [`shared/evidence/win-1/infrastructure/infrastructure-baseline-20260723.md`](../evidence/win-1/infrastructure/infrastructure-baseline-20260723.md)

Remote: `8b57fe8` on `origin/master` — **SYNCHRONIZED ✅**

Certification: [`WIN-1.md`](WIN-1.md)

---

## WS-2 — Arch validation → bare metal

```text
Sprint 1   APPROVED WITH CONDITIONS ✅
Sprint 2   APPROVED ✅
Arch VM    DEVELOPMENT WORKSTATION (validation)
Bare-metal install   NOT AUTHORIZED
```

Sprint 1 evidence: [`shared/evidence/ws-2/readiness-audit/`](../evidence/ws-2/readiness-audit/) · commit `0875b25`  
Sprint 2 evidence: [`shared/evidence/ws-2/sprint-2/`](../evidence/ws-2/sprint-2/)

**Sprint 2 closed:** Cursor · repositories · dotfiles · dev round-trip · secret scan · timezone · audio (guest) · GUI Acceptance

**Backlog (not blocking):**

1. `asir0z-cortex` repo unavailable on GitHub — defer until restored  
2. Optional host: enable VirtualBox Audio Output for audible speakers (guest stack already PASS)  
3. bootstrap automount · other VM-specific friction  

**SSH key policy:** private keys never in repo, bootstrap, or evidence — operator-controlled transfer only.

---

## MAC-1 — Mac Operator Console

```text
STATUS:     CERTIFIED ✅ · PASS (2026-07-24)
SCOPE:      Full operator console (shell · CLI · SSH · wrappers · Git · Cursor)
AMENDMENT:  Terminal/shell/scripts — Approved
MISSION:    shared/missions/MAC-1-OPERATOR-CONSOLE-BOOTSTRAP.md
PACKAGE:    mac/mac-1-operator-console/
BOOTSTRAP:  scripts/bootstrap/mac-bootstrap.sh
EVIDENCE:   shared/evidence/mac-1/mac-1-evidence-20260724.md
COLLECTOR:  shared/evidence/mac-1/verification-20260724-023724.txt
CERT:       MAC-1.md
MAC-2:      DEFERRED · DESIGN FROZEN · scope + software baseline APPROVED
            → after OFFLINE-1 · Arch install · Arch bootstrap
            → implementation only (Brewfile → bootstrap → verify → dotfiles → helpers → evidence)
            → shared/missions/MAC-2-DEVELOPMENT-EXPERIENCE.md
            → expansion: MAC-2-SCOPE-EXPANSION-ENGINEERING-WORKSTATION.md
            → baseline:  MAC-2-SOFTWARE-BASELINE.md
```

Mac design track is **frozen** — no further MAC planning docs until MAC-2 implementation activates. Critical path: **OFFLINE-1**.

**Split:** Mac = wrappers/aliases · Ubuntu = canonical production scripts · Arch = on-demand compute.

Architecture: [`MAC-PRIMARY-OPERATOR-CONSOLE.md`](../architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md) · Missions: [`../missions/README.md`](../missions/README.md)

Mac is the **primary operator console**. Windows is **fallback**. Arch bare-metal is gated by OFFLINE-1.

Operator priority *(updated 2026-07-24)*:

```text
1. MAC-1 full console bootstrap  ← CERTIFIED ✅
2. OFFLINE-1 offline NTFS shrink ← ACTIVE (critical path)
3. Arch install (arch-install-spec.md)
4. Arch bootstrap
5. Mission 20 observation        ← DevOps Lab (parallel)
6. MAC-2 engineering workstation  ← DEFERRED (scope approved; after Arch bootstrap)
7. WIN-1 Core                    ← friction-driven on Windows fallback
```

### OFFLINE-1 — Active bare-metal mission

```text
STATUS:     ACTIVE ✅ · AUTHORIZED
MISSION:    shared/missions/OFFLINE-1-NTFS-SHRINK.md
EDR:        shared/evidence/bare-metal/decisions/WINDOWS-ONLINE-SHRINK-EXHAUSTED.md
EVIDENCE:   shared/evidence/bare-metal/offline-shrink-evidence.txt
NEXT:       arch-install-spec.md on OFFLINE-1 PASS
```

Do **not** reopen Windows online shrink without new evidence.
---

## Mission 20 (DevOps Lab)

Production cutover to Contabo executed 2026-07-23. **Observation window** active.

**Başarı kriteri:**

> **Production users cannot tell that infrastructure changed.**

Observation PASS tamamlanmadan Ubuntu VM emekliye ayrılmayacak (WIN-1A).

Spec: [MISSION-20](https://github.com/asir0z/asir0z-devopslab/blob/main/missions/phase-2/MISSION-20-PRODUCTION-RUNTIME-MIGRATION.md)

---

## Engineering culture

Platform artık fikir odaklı değil, evidence odaklı çalışıyor.

Eski akış (yerleşik prensip):

```text
Opinion → Evidence → Decision
```

Operasyonel döngü (platform state güncellenir):

```text
Platform State
        │
        ▼
Observed Friction
        │
        ▼
Specification
        │
        ▼
Implementation
        │
        ▼
Evidence
        │
        ▼
Review
        │
        ▼
Certification
        │
        ▼
Platform State   ← this document
```

**Review tetikleyicisi:** Observed Friction **veya** platform durumunu değiştiren yeni evidence.

**Varsayılan çalışma modu:**

```text
No new evidence.
Continue execution.
```

Karar ağacı:

```text
Platform State
      │
      ▼
New friction or new evidence?
      │
 ┌────┴────┐
 │         │
No        Yes
 │         │
 ▼         ▼
Execute   Review
           │
           ▼
     Certification
           │
           ▼
   Update PLATFORM-STATE.md
```

Certification Authority: geçmiş konuşmalardaki `%95 Migration`, `P0 Pending` vb. **referans alınmaz** — yalnızca bu belge ve bağlı certification kayıtları.

**Artık platformun nasıl çalışacağını tartışmıyoruz; platformu çalıştırıyoruz.**

---
---

## Default assumptions (Certification Authority)

Unless new evidence changes state:

| Item | Assumption |
|------|------------|
| Migration | **100% · CERTIFIED · FROZEN** |
| WIN-1 Infrastructure | **100% · CERTIFIED · FROZEN BASELINE** |
| WIN-1 Core | **OPEN** — Observed Friction driven |
| WS-2 Sprint 1 | **APPROVED WITH CONDITIONS** |
| WS-2 Sprint 2 | **APPROVED** |
| Mission 20 | **Observation** (Contabo cutover 2026-07-23) |
| WIN-1A | BLOCKED until Mission 20 observation PASS |
| MAC-1 | **CERTIFIED ✅ · PASS** (2026-07-24) |
| OFFLINE-1 | **ACTIVE ✅ · AUTHORIZED** — current critical path |
| Foundation / Governance / Lifecycle | **FROZEN** |
| Review trigger | **Observed Friction** or new evidence only |

Historical only (do not revert): `95% Migration` · `P0 Pending` · `WIN-1 blocked until Migration FROZEN`

---

| Track | Focus |
|-------|-------|
| **SmoothOperator** | WIN-1 Infra **FROZEN ✅** · Core **OPEN** · WS-2 Sprint 2 **APPROVED ✅** · **MAC-1 CERTIFIED ✅** · **OFFLINE-1 ACTIVE** · MAC-2 **DEFERRED** |
| **DevOps Lab** | Mission 20 **Observation** |
| **Products** | Standby until Contabo production |

---

*SmoothOperator™ · asir0z-smoothoperator*
