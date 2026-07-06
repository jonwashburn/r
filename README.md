# r — the machine-checked theorem surface of "Recognition Science" (RS_v1)

This repository contains **exactly the Lean 4 files needed to support the
paper**: the transitive import closure of every public declaration cited in
the paper's Appendix G ("Repository theorem index"), plus a single
machine-checked index module, [`Paper.lean`](Paper.lean).

One command verifies the whole paper surface:

```bash
elan default leanprover/lean4:v4.27.0-rc1
lake exe cache get
lake build Paper
```

`Paper.lean` does two things, and a successful build certifies both:

1. **Existence** — every declaration named in Appendix G is referenced by
   full name, so the build fails if any cited name is absent.
2. **Exact statements** — the headline declarations whose formal statements
   are reproduced verbatim in Appendix G (`law_of_logic_forces_jcost`, the
   dimension-three theorems, the Gap-45 certificate, the torsion cube
   counts) are restated as `example`s discharged by the library
   declarations. If the library statement ever drifts from the printed
   statement, the build breaks.

## Audit

```bash
python3 scripts/audit.py
```

confirms zero `sorry`, zero `admit`, and zero top-level `axiom`
declarations across the entire slice (100 files). In addition,

```bash
lake env lean AxiomAudit.lean
```

prints the axiom footprint of every headline theorem: each depends only on
the Lean/Mathlib base (`propext`, `Classical.choice`, `Quot.sound`), except
the `native_decide` arithmetic certificates, which additionally use the
compiler-trust axioms — and `Paper.lean` re-proves each of those small
arithmetic facts by kernel `decide` with no compiler trust. The same limits
stated in
the paper's "Audit status" apply: this certifies internal formal soundness,
not the physical adequacy of the definitions; read the definitions.

## Provenance

The files are taken from the public
[shape-of-logic](https://github.com/jonwashburn/shape-of-logic) repository
at the commit pinned by the paper,
`85495068635750397456aeb8fe5c653b1f42d925`
(toolchain `leanprover/lean4:v4.27.0-rc1`, mathlib4 at
`d7ea5678e6d426e87e9b4a65a48143c4874dc501`), restricted to the import
closure of the Appendix G modules. Two files are taken from a later commit
of the same repository (`924aa66`), with no change to any cited statement:

- `IndisputableMonolith/Spectral/DFT8.lean` replaces the pinned
  `LightLanguage/Basis/DFT8.lean` (identical DFT-8 mathematics; the later
  commit relocates the module and removes an unused, unrelated section).
- `IndisputableMonolith/Foundation/CliffordBridge.lean` differs from the
  pinned version only in the two lines that import/open the relocated
  DFT-8 module.

No declaration cited in Appendix G lives in either file; they are
dependencies of `DimensionForcing.lean`.

## Paper → Lean map (Appendix G layers)

| Paper layer | Modules |
|---|---|
| T-2 → T8 spine | `Foundation/NothingToDistinction.lean`, `Foundation/TMinus1ToT8Bridge.lean`, `Foundation/CircleWindingChain.lean` |
| Boolean floor | `Foundation/TMinus1ToT8Bridge.lean` |
| Recognition quotient / gauge | `RecognitionCore.lean`, `Foundation/PrimitiveRecognitionCalculus/QuotientSelection.lean` |
| Reciprocal cost (headline) | `Cost/FunctionalEquation.lean`, `CostUniqueness.lean` |
| Golden ratio | `Foundation/PhiForcing.lean`, `Foundation/TMinus1ToT8Bridge.lean` |
| Dimension and eight ticks | `Foundation/AlexanderDuality.lean`, `Foundation/DimensionForcing.lean`, `Patterns/GrayCycle.lean` |
| Gap-45 certificate | `Foundation/GapDerivation.lean` |
| Torsion cube counts (11, 6) | `Masses/TorsionForcing.lean`, `Constants/AlphaDerivation.lean` |
| Native constants (ℏ, G) | `Constants.lean` |
| ILG / gravity scaffold | `Gravity/ILG.lean`, `Gravity/ParameterizationBridge.lean`, `Gravity/GravityParameters.lean`, `Gravity/DerivedFactors.lean`, `Gravity/Rotation.lean` |

## Errata against the current paper draft

- Appendix G's table prints `lsb_suppression_limit`; the declaration's
  actual name (at the pinned commit and here) is
  `lsb_unsuppressed_limit`. The statement is as described.

## A note on the fine-structure constant

The paper cites `Constants/AlphaDerivation.lean` only for the cube-count
integers 11 and 6 (`cube_edges`, `cube_faces`, `passive_field_edges`),
which seed the α and η_B expressions, and makes no headline α claim. The
status of α in the wider Recognition Science framework, as of the current
shape-of-logic head: the structural ingredients of the α construction are
theorems (the `4π·11` channel budget from cube combinatorics, the forced
`φ`-pattern, the forced exponential dressing, and the proved construction
band `(137.030, 137.039)`), while the **exact** value of α⁻¹ is proved to
be an irreducible boundary datum within RS — a no-go, not an open
calibration (see the `AlphaGenesis` irreducibility modules in
shape-of-logic). α is primitive in exactly that sense: its structure is
forced and proven, and its exact value is a primitive input, with the
irreducibility itself a theorem. This repository deliberately contains
only what the paper cites.

## License

MIT, matching shape-of-logic.
