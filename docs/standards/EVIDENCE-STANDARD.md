# Evidence Standard

```text
Status:   ACCEPTED
Version:  1.0
Date:     2026-07-24
Layer:    Standards
```

## Core rule

```text
Write Once
Never Edit
Supersede Instead
```

After an evidence artifact is referenced by a certification decision, treat it as **immutable**.

---

## Storage

| Track | Path |
|-------|------|
| Mac missions | `shared/evidence/mac-*/` |
| Bare-metal | `shared/evidence/bare-metal/` |
| Future MES layout | `evidence/macos/` (alias/migrate only when authorized) |

Do not store secrets in evidence.

---

## Naming

```text
<topic>-YYYYMMDD[-HHMMSS].<ext>
```

Examples:

* `verification-20260724-023724.txt`
* `mac-1-evidence-20260724.md`

---

## Lifecycle

```text
1. Collect (operator / verify script)
2. Commit to Git (or attach path in certification)
3. Reference from certification record
4. Freeze — no content edits
5. If wrong/incomplete → new superseding file + cert amendment
```

Allowed post-cert edits: **none** to certified bytes. Metadata typos in non-certified indexes may be fixed with explicit note.

---

## Certification references

Every certification must point to:

* Mission ID / path
* Evidence path(s)
* Git commit (of cert or evidence commit)
* Reviewer
* Timestamp

See [`CERTIFICATION-STANDARD.md`](CERTIFICATION-STANDARD.md).

---

## Supersession

When superseding:

1. Create new dated evidence file
2. Leave old file untouched
3. New certification (or amendment) references the new file and notes supersession
4. Update PLATFORM-STATE only if living status changes

---

*SmoothOperator™ · Standards · Evidence Standard v1.0*
