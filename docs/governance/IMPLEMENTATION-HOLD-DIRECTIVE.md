# Mac Engineering Station — Implementation Hold Directive

```text
Status:   ACTIVE
Date:     2026-07-24
Layer:    Governance
Audience: Mac Cursor (Implementation Engineer)
```

Related: [`DOCUMENTATION-GOVERNANCE.md`](DOCUMENTATION-GOVERNANCE.md) · [`../README.md`](../README.md)

---

## Current situation

The first canonical documentation set exists and is **frozen** as architecture:

* Foundation v1.0
* Documentation Governance
* Capability / Interface / ADR templates
* Evidence Standard · Certification Standard
* MAC-01 Certification

Do **not** redesign them. Do **not** expand them unnecessarily.

---

## Critical path (unchanged)

```text
OFFLINE-1 Phase B
        ↓
Arch Installation
        ↓
Arch Bootstrap
        ↓
MAC-2 Activation
```

MAC-2 is **not active**. Do not begin workstation implementation before activation.

---

## Role

Implementation engineer responsibilities:

* preserve architecture
* maintain documentation
* prepare implementation (without executing MAC-2 early)
* review consistency
* avoid architectural drift

Not responsible for creating new architecture.

---

## Freeze policy

Modify documents only when:

* an approved architectural decision exists
* an implementation requirement demands it
* evidence contradicts documentation
* certification requires correction

Do not expand documents because additional ideas exist.

---

## Documentation rule

Every proposed change must answer:

> Which documentation layer owns this information?

```text
Foundation · Governance · Standards · Capability · Interface
· Decision Record · Mission · Evidence · Certification
```

If no layer clearly owns it: **do not** create a new document — escalate for architectural review.

---

## Implementation rule

Prefer:

```text
Implementation → Evidence → Certification → Documentation refinement
```

Avoid:

```text
Speculation → Large documentation → Future implementation
```

---

## Next MAC work (when MAC-2 activates)

1. Baseline verification  
2. Brewfile  
3. Bootstrap scripts  
4. Verification scripts  
5. Shell configuration  
6. Git configuration  
7. SSH configuration  
8. Local helper commands  
9. Dotfiles  
10. Evidence  
11. Certification  

Do not reorder without justification.

---

## Capability creation policy

Do **not** create new capabilities or interfaces until required by real implementation (e.g. `lab-health` polish under MAC-2 → then capability; Mac consuming Ubuntu ops → then interface).

---

## Repository discipline

Avoid: duplicate docs/standards/evidence/ownership · speculative repos/interfaces.

Prefer: one owner · one canonical document · one implementation path · one evidence chain.

---

## Success criteria (until MAC-2 activation)

* preserve consistency
* reduce drift
* avoid unnecessary documentation growth
* support OFFLINE-1 and Arch progression
* remain ready for implementation

The objective is no longer to design the system.

---

*SmoothOperator™ · Mac Engineering Station · Implementation Hold Directive*
