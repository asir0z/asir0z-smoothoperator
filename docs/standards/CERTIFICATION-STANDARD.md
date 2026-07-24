# Certification Standard

```text
Status:   ACCEPTED
Version:  1.0
Date:     2026-07-24
Layer:    Standards
```

Certification is the **verification chain**, not a bare PASS/FAIL sticker.

---

## Required fields

Every certification record must include:

```text
Certification ID
Mission
Evidence References
Capability Version        (if applicable; else N/A)
Interface Version         (if applicable; else N/A)
Decision Records          (ADRs / amendments)
Git Commit
Decision
Reviewer
Timestamp
```

Recommended additional fields:

```text
Blocking Issues
Known Backlog (non-blocking)
Lifecycle (CERTIFIED | CHANGES REQUIRED | REJECTED | SUPERSEDED)
```

---

## Decision vocabulary

| Decision | Meaning |
|----------|---------|
| APPROVED / PASS / CERTIFIED | Mission acceptance criteria met |
| CHANGES REQUIRED | Evidence insufficient or criteria unmet — fix and resubmit |
| REJECTED | Mission outcome unacceptable |
| SUPERSEDED | Replaced by a later certification |

---

## Record location

| Style | Path |
|-------|------|
| Mac Engineering Station (new IDs) | `docs/certifications/` |
| SmoothOperator living gates | `shared/certification/` |

New MES certifications should live under `docs/certifications/` and **link** to evidence under `shared/evidence/`. Do not fork evidence.

PLATFORM-STATE remains the living summary: [`../../shared/certification/PLATFORM-STATE.md`](../../shared/certification/PLATFORM-STATE.md).

---

## Template

```markdown
# Certification — <CERT-ID>

```text
Certification ID:  CERT-MAC-XX
Mission:
Evidence References:
Capability Version:  N/A | …
Interface Version:   N/A | …
Decision Records:
Git Commit:
Decision:            APPROVED | CHANGES REQUIRED | REJECTED
Reviewer:
Timestamp:
Lifecycle:           CERTIFIED | …
Blocking Issues:     None | …
```

## Summary

## Evidence chain

## Acceptance mapping

## Known backlog (non-blocking)

## Next mission
```

---

*SmoothOperator™ · Standards · Certification Standard v1.0*
