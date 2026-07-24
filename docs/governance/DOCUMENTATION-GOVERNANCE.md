# Mac Engineering Station — Documentation Governance

```text
Status:   ACCEPTED
Version:  1.0
Date:     2026-07-24
Layer:    Governance
Type:     Process (not implementation)
```

Foundation: [`../foundation/MAC-ENGINEERING-STATION-FOUNDATION-v1.0.md`](../foundation/MAC-ENGINEERING-STATION-FOUNDATION-v1.0.md)

Governance defines **process**. It does not define packages, Brewfiles, or tool choices.

**Active hold:** [`IMPLEMENTATION-HOLD-DIRECTIVE.md`](IMPLEMENTATION-HOLD-DIRECTIVE.md) — freeze docs architecture; critical path OFFLINE-1 → Arch → MAC-2; no speculative CAP/IFACE.

---

## Document hierarchy

```text
Foundation → Governance → Standards → Capabilities → Interfaces
→ Decisions (ADR) → Missions → Evidence → Certification
```

Rules:

1. Determine which layer owns a change.
2. Update **only** that layer.
3. Do not introduce cross-layer duplication.
4. Do not collapse layers into a single master draft.
5. Master Design Drafts are extract-only source material after canonical docs exist.

---

## Evidence lifecycle

```text
Collect → Store under shared/evidence/… → Reference from mission/cert
→ Certify → Freeze referenced evidence (Write Once)
```

Per [`../standards/EVIDENCE-STANDARD.md`](../standards/EVIDENCE-STANDARD.md):

* Write once
* Never edit certified evidence
* Supersede instead (new dated artifact)

---

## Approval gates

| Gate | Required before |
|------|-----------------|
| Architecture / Foundation change | ADR Accepted + reviewer |
| New capability | Capability spec using template |
| New interface | Interface spec using template |
| Mission execution | Mission AUTHORIZED (or ACTIVE) |
| Destructive remote action | Explicit human approval |
| Certification | Evidence present + Certification Standard fields complete |
| Implementation of deferred Mac work (e.g. MAC-2) | Prior mission PASS + PLATFORM-STATE priority allows |

Living priority authority: [`../../shared/certification/PLATFORM-STATE.md`](../../shared/certification/PLATFORM-STATE.md).

---

## Automation maturity

| Level | Meaning |
|-------|---------|
| L0 Manual | Operator runs commands |
| L1 Scripted | Checked-in scripts / wrappers |
| L2 Verified | Scripts + verify collectors produce evidence |
| L3 Recoverable | Clean machine restored from Git + bootstrap |
| L4 Guarded automation | Automation with human gate for destructive steps |

Raise maturity only with evidence. Do not claim L3/L4 without verification artifacts.

---

## Certification workflow

```text
Mission complete
    ↓
Evidence collected (immutable)
    ↓
Certification record (Certification Standard)
    ↓
PLATFORM-STATE update (if platform status changes)
    ↓
Next mission activation
```

Details: [`../standards/CERTIFICATION-STANDARD.md`](../standards/CERTIFICATION-STANDARD.md).

---

## Drift management

Drift = reality differs from documented certified state.

| Detection | Response |
|-----------|----------|
| Verify script WARN/FAIL | Investigate · evidence · fix or ADR |
| Undocumented local install | Either remove or ADR + baseline update |
| Duplicate production logic on Mac | Delete local copy · restore wrapper-to-Ubuntu pattern |
| Docs contradict PLATFORM-STATE | PLATFORM-STATE wins for living status; fix the stale doc |

---

## Document evolution

| Change type | Action |
|-------------|--------|
| Typo / clarity | Patch in place (non-certified docs) |
| Principle change | New Foundation version + ADR |
| Process change | Governance revision + note in PLATFORM-STATE if needed |
| Tool selection | ADR + capability/mission update — not Foundation |
| Certified evidence error | Superseding evidence + cert amendment — never silent rewrite |

---

## Ownership

| Role | Responsibility |
|------|----------------|
| Architecture authority | Existing SmoothOperator architecture docs (not this engineer role) |
| Documentation implementer | Keep layers correct · templates applied |
| Operator | Execute missions · collect evidence |
| Certification Authority | PASS / CHANGES REQUIRED / REJECTED |

---

*SmoothOperator™ · Mac Engineering Station · Documentation Governance v1.0*
