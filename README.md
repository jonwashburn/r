# r — machine-checked theorem surface for the FoP intro paper

This repository contains **exactly the Lean 4 files needed to support**
[`papers/RS_v1_rewrite/rs_v1_fop.tex`](https://github.com/jonwashburn/reality/blob/main/papers/RS_v1_rewrite/rs_v1_fop.tex)
(*The Unique Reciprocal Cost and the Machine-Checked Boundary of Its Physical Extrapolation*):
the transitive import closure of every declaration cited in the paper's
verification appendix, plus one machine-checked index module,
[`Paper.lean`](Paper.lean).

One command verifies the whole paper surface:

```bash
elan default leanprover/lean4:v4.27.0-rc1
lake exe cache get
lake build Paper
```

`Paper.lean` certifies:

1. **Existence** — every cited declaration is referenced by full name (`#check`).
2. **Exact statements** — headline declarations restated as `example`s discharged by
   the library; drift from the printed appendix breaks the build.

## Audit

```bash
python3 scripts/audit.py
```

confirms zero `sorry`, zero `admit`, and zero top-level `axiom` in the slice.

```bash
lake env lean AxiomAudit.lean
```

prints the axiom footprint of the headline theorems (kernel certificates depend
only on `[propext, Classical.choice, Quot.sound]`).

## Provenance

Files are extracted from
[shape-of-logic](https://github.com/jonwashburn/shape-of-logic) at commit

`9ba58e9551c1fb0322cfa5ff0b145411f652a5fc`

(toolchain `leanprover/lean4:v4.27.0-rc1`, mathlib4 pinned in `lake-manifest.json`),
restricted to the import closure of the verification appendix. Rebuild the slice
after upstream changes:

```bash
python3 scripts/rebuild_slice.py   # requires local shape-of-logic checkout at 9ba58e9
```

## Paper → Lean map

| Paper layer | Modules |
|---|---|
| Reciprocal cost (Part I) | `Cost/FunctionalEquation.lean`, `CostUniqueness.lean` |
| Boundary certificates (§6) | `Verification/DimensionalRigidity.lean`, `Foundation/PrimitiveDistinction.lean`, `Verification/T5/LedgerCost.lean` |
| Boolean floor | `Foundation/TMinus1ToT8Bridge.lean` |
| Golden ratio (quarantined) | `Foundation/PhiForcing.lean` |
| Dimension / eight ticks (quarantined) | `Foundation/DimensionForcing.lean`, `Patterns/GrayCycle.lean` |
| Cube counts (exhibits) | `Foundation/GapDerivation.lean`, `Masses/TorsionForcing.lean` |
| Retraction records (exhibits) | `Cosmology/EtaBPrefactorDerivation.lean`, `Masses/Verification.lean` |

## Trust base note

Arithmetic facts proved by `native_decide` in the upstream library (cube counts,
gap 45) extend the trust base to the compiler evaluator. `Paper.lean` also
re-proves those small integers by kernel `decide` in dedicated `example`s.

## License

MIT, matching shape-of-logic.
