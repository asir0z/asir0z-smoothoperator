# MAC-1 Evidence

> **Mission:** Mac Operator Console Bootstrap  
> **Spec:** [`mac/mac-1-operator-console/MAC-1-SPEC.md`](../../../mac/mac-1-operator-console/MAC-1-SPEC.md)  
> **Status:** Awaiting operator capture on macOS

## Contents

| File | Purpose |
|------|---------|
| `MAC-1-EVIDENCE.template.md` | Operator fills → dated report |
| `verification-YYYYMMDD.txt` | Output of `verify/verify-mac1.sh` |

## Capture (on the Mac)

```bash
cd ~/Projects/asir0z-smoothoperator
mkdir -p shared/evidence/mac-1
bash mac/mac-1-operator-console/verify/verify-mac1.sh \
  | tee shared/evidence/mac-1/verification-$(date +%Y%m%d).txt
cp shared/evidence/mac-1/MAC-1-EVIDENCE.template.md \
   shared/evidence/mac-1/mac-1-evidence-$(date +%Y%m%d).md
# edit the dated evidence file, then commit
```

**Policy:** no private keys, tokens, or `.ssh` private material in evidence.

---

*SmoothOperator™ · MAC-1*
