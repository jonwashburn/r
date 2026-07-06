import Lake
open Lake DSL

package «r» where
  leanOptions := #[
    ⟨`autoImplicit, false⟩
  ]

require mathlib from git "https://github.com/leanprover-community/mathlib4.git"

/-- The paper-support slice of the Shape of Logic library: exactly the
transitive import closure of the modules cited in Appendix G of RS_v1. -/
lean_lib IndisputableMonolith where
  roots := #[`IndisputableMonolith]

/-- The machine-checked paper index: existence + exact-statement checks for
every declaration cited in Appendix G. `lake build Paper` verifies the
entire paper surface. -/
lean_lib Paper where
  roots := #[`Paper]
