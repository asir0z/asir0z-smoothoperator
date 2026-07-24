# Capability Specification Template

```text
Status:   ACCEPTED TEMPLATE
Version:  1.0
Date:     2026-07-24
Layer:    Standards
```

Use this template for every Mac Engineering Station capability.

**Capabilities describe what must exist**, not which software is currently selected. Tool choices belong in ADRs and mission implementations.

Copy to `docs/capabilities/<CAPABILITY-ID>.md`.

---

```markdown
# Capability — <NAME>

```text
Status:       Proposed | Active | Deprecated | Retired
Capability ID: CAP-XXX
Version:      1.0
Date:
Owner:
```

## Purpose

## Canonical Owner

## Consumers

## Scope

## Non-Goals

## Required Interfaces

(List interface IDs — do not embed full interface specs.)

## Current Implementation

(Pointers only — scripts, paths, missions. Prefer links.)

## Alternative Implementations

## Security Requirements

## Observability Requirements

## Failure Modes

## Recovery Behavior

## Acceptance Criteria

## Review Triggers

## Future Evolution
```

---

## Rules

* One capability per file
* No Brewfile dumps inside capability specs
* If implementation changes but capability contract does not, update Current Implementation only
* If contract changes, bump capability version and list review triggers

---

*SmoothOperator™ · Standards · Capability Specification Template*
