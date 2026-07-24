# Interface Specification Template

```text
Status:   ACCEPTED TEMPLATE
Version:  1.0
Date:     2026-07-24
Layer:    Standards
```

Interfaces are **contracts between systems** (e.g. Mac operator → Ubuntu ops scripts).

Copy to `docs/interfaces/<INTERFACE-ID>.md`.

---

```markdown
# Interface — <NAME>

```text
Status:        Proposed | Active | Deprecated | Retired
Interface ID:  IFACE-XXX
Version:       1.0
Date:
```

## Purpose

## Provider

## Consumer

## Ownership Boundary

## Exports

## Consumes

## Transport

## Authentication

## Authorization

## Data Classification

## Request / Event Schema

## Failure Semantics

## Retry Strategy

## Idempotency

## Observability

## Approval Gates

## Versioning

## Compatibility

## Deprecation

## Acceptance Criteria
```

---

## Rules

* Provider owns the canonical implementation
* Consumer owns only wrappers/adapters
* Breaking changes require version bump + deprecation note + ADR when architectural
* Example pattern: Ubuntu owns `~/scripts/ops/production-health-check.sh`; Mac owns `lab-health` wrapper only

---

*SmoothOperator™ · Standards · Interface Specification Template*
