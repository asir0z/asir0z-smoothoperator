# Mac Engineering Station — Documentation Index

```text
Status:     ACTIVE
Repo:       asir0z-smoothoperator
Layer:      Documentation root for Mac Engineering Station
```

## Documentation Status

| Layer | Status |
|-------|--------|
| Foundation | ✅ Canonical |
| Governance | ✅ Canonical |
| Standards (catalog) | ⏳ Seed |
| Capability Templates | ✅ Ready |
| Interface Templates | ✅ Ready |
| ADR Template | ✅ Ready |
| Evidence Standard | ✅ Ready |
| Certification Standard | ✅ Ready |
| First certification (MAC-01) | ✅ Recorded |
| First capability / interface specs | ⏸️ Deferred until MAC-2 implementation need |
| Active mission | **OFFLINE-1** (Phase B) |
| MAC-2 | Deferred · Design Frozen |

**Rule:** New capability and interface documents are written only from **working implementations**, not speculative contracts.

```text
OFFLINE-1 Phase B → Arch Install → Arch Bootstrap → MAC-2 → then first CAP/IFACE
```

## Hierarchy (accepted · do not collapse)

```text
Foundation
    ↓
Governance
    ↓
Standards
    ↓
Capabilities
    ↓
Interface Specifications
    ↓
Decision Records
    ↓
Mission Specifications
    ↓
Implementation Evidence
    ↓
Certification
```

## Canonical documents (v1 derivation)

| # | Document | Path |
|---|----------|------|
| 1 | Foundation v1.0 | [`foundation/MAC-ENGINEERING-STATION-FOUNDATION-v1.0.md`](foundation/MAC-ENGINEERING-STATION-FOUNDATION-v1.0.md) |
| 2 | Documentation Governance | [`governance/DOCUMENTATION-GOVERNANCE.md`](governance/DOCUMENTATION-GOVERNANCE.md) |
| 3 | Capability Spec Template | [`standards/CAPABILITY-SPECIFICATION-TEMPLATE.md`](standards/CAPABILITY-SPECIFICATION-TEMPLATE.md) |
| 4 | Interface Spec Template | [`standards/INTERFACE-SPECIFICATION-TEMPLATE.md`](standards/INTERFACE-SPECIFICATION-TEMPLATE.md) |
| 5 | ADR Template | [`standards/ADR-TEMPLATE.md`](standards/ADR-TEMPLATE.md) |
| 6 | Evidence Standard | [`standards/EVIDENCE-STANDARD.md`](standards/EVIDENCE-STANDARD.md) |
| 7 | Certification Standard | [`standards/CERTIFICATION-STANDARD.md`](standards/CERTIFICATION-STANDARD.md) |
| 8 | MAC-01 Baseline Verification | [`certifications/MAC-01-BASELINE-VERIFICATION.md`](certifications/MAC-01-BASELINE-VERIFICATION.md) |

## Relationship to existing SmoothOperator layers

This `docs/` tree is the **Mac Engineering Station documentation system**. It does **not** replace living platform state.

| Concern | Authority (do not duplicate content) |
|---------|--------------------------------------|
| Platform living state | `shared/certification/PLATFORM-STATE.md` |
| Platform architecture ADR | `shared/architecture/MAC-PRIMARY-OPERATOR-CONSOLE.md` |
| Active missions | `shared/missions/` |
| Evidence artifacts | `shared/evidence/` |
| Certification gates (legacy IDs) | `shared/certification/` |
| Operator bootstrap scripts | `scripts/bootstrap/`, `shared/operator/` |

**Rule:** Update only the layer that owns a change. Do not copy package lists or mission text into Foundation.

## Master Design Draft

```text
Status:   MASTER DESIGN DRAFT (source material)
Authority: Non-canonical after these derived documents exist
```

If the draft lives outside this repository, treat it as extract-only input. Do not expand it here.

## Target implementation layout (future · not created by this derivation)

```text
macos/   Brewfile · bootstrap · config · verify
shared/  shell · git · editor · scripts   (existing shared/operator + scripts/)
evidence/macos/                           (maps to shared/evidence/mac-*)
```

Do not invent a parallel `asir0z-workstation` repository unless SmoothOperator governance authorizes a split.

---

*SmoothOperator™ · Mac Engineering Station · Documentation Index*
