import Mathlib
import IndisputableMonolith.Foundation.HierarchyRealizationObstruction
import IndisputableMonolith.Foundation.AlexanderDuality
import IndisputableMonolith.Foundation.DimensionForcing
import IndisputableMonolith.Foundation.T7CycleRealization
import IndisputableMonolith.Foundation.MathlibCohomologyBridge
import IndisputableMonolith.Foundation.CircleWindingChain
import IndisputableMonolith.Verification.DimensionLinking
import IndisputableMonolith.Foundation.TMinus1ToT8Bridge

/-!
# T6–T8 spine honesty audit (July 2026 internal report)

Machine-checked summary of the internal audit *T6 through T8 — what I read,
what I asked, and whether each tier is forced* (2026-07-06).

**Tier tags (honest):**
- **THEOREM**: proved content with no hidden premise in the statement.
- **FORCED-CONDITIONAL**: correct consequence once named hypotheses are supplied.
- **MODEL / ENCODING**: definitional packaging of a classical fact or modeling choice.
- **OPEN**: missing bridge the program still owes.

This module does not upgrade any tier; it records what the repository already proves
about its own gaps.
-/

namespace IndisputableMonolith
namespace Verification
namespace T6T8SpineAudit

open Foundation
open Foundation.HierarchyRealizationObstruction
open Foundation.AlexanderDuality
open Foundation.DimensionForcing
open Foundation.T7CycleRealization
open Foundation.MathlibCohomologyBridge
open DimensionLinking
open Foundation.TMinus1ToT8Bridge

/-! ## T6: closure is supplied, not derived from T5 alone -/

/-- **AUDIT (THEOREM).** `ClosedObservableFramework` alone does not force the
hierarchy fields consumed by the internal T5→T6 bridge. -/
theorem t6_obstruction_closed_framework :
    ∃ (F : ClosedFramework.ClosedObservableFramework) (base : F.S),
      (¬ (∀ k,
        F.r (F.T^[k + 2] base) / F.r (F.T^[k + 1] base) =
          F.r (F.T^[k + 1] base) / F.r (F.T^[k] base))) ∧
      (¬ (F.r (F.T^[2] base) = F.r (F.T^[1] base) + F.r base)) :=
  closedFramework_does_not_force_realizedHierarchy_fields

/-- **AUDIT (THEOREM).** Quadratic uniqueness `r² = r + 1 ∧ r > 0 ⇒ r = φ` is
available without importing T5 (standalone `t6_holds`). -/
theorem t6_quadratic_algebra_standalone : T6_Phi_Forced :=
  t6_holds

/-! ## T7: combinatorics real; realization layer predicate-level -/

/-- **AUDIT (MODEL).** The T7.5 edge-distinctness predicate is presently the
placeholder `True`, not a graph-theoretic edge lemma. -/
theorem t7_edge_distinct_is_placeholder (D : ℕ) (hD : 2 ≤ D)
    (W : ClosedWalkOnCube D) (hHam : Hamiltonian W) :
    EdgeDistinct W :=
  edge_distinct_of_dim_ge_two D hD W hHam

/-- **AUDIT (MODEL).** `RealizedDefect` is defined to return `Circle` regardless
of the walk (predicate-level packaging). -/
theorem t7_realized_defect_by_definition (D : ℕ) (hD : 2 ≤ D)
    (cell : SubstrateAxioms.CellularCompletion D) (W : ClosedWalkOnCube D)
    (hHam : Hamiltonian W) :
    RealizedDefect cell W = T7CycleRealization.Circle :=
  t7_cycle_realizes_circle D hD cell W hHam

/-! ## T8: linking predicate is an encoding; H₁(S¹) is proved separately -/

/-- **AUDIT (ENCODING).** After unfolding, circle linking is the arithmetic
condition `D - 2 = 1`, not a Mathlib Alexander-duality computation. -/
theorem t8_linking_predicate_unfolds_to_arithmetic (D : ℕ) :
    SphereAdmitsCircleLinking D ↔ (D : ℤ) - 2 = 1 := by
  unfold SphereAdmitsCircleLinking
  rw [circle_reduced_cohomology_iff]

/-- **AUDIT (THEOREM).** `dimension_unique` discharges from the `linking` field
alone; `eight_tick`, `gap_sync`, and substrate fields are not used in the proof. -/
theorem t8_dimension_unique_uses_linking_only (D : Dimension)
    (hlink : SupportsNontrivialLinking D) : D = 3 :=
  linking_requires_D3 D hlink

/-- **AUDIT (THEOREM).** Same-sector linking arithmetic permits every odd
`D ≥ 3`; the loop-loop specialization `p = 1` is an additional choice. -/
theorem t8_same_sector_allows_odd_dimensions (D : ℕ) :
    (D ≥ 3 ∧ ¬ 2 ∣ D) ↔
      ∃ p : ℕ, p ≥ 1 ∧ D = 2 * p + 1 :=
  (allowed_set_A_characterization D).symm

/-- **AUDIT (THEOREM).** `H₁(S¹; ℤ) ≅ ℤ` is proved against Mathlib singular
homology (`CircleWindingChain.circleH1ZIsoInt_holds`). This certificate is
not yet a premise of `linking_requires_D3`. -/
theorem t8_circle_h1_iso_proved : circleH1ZIsoInt :=
  CircleWindingChain.circleH1ZIsoInt_holds

/-- **AUDIT (ENCODING).** The Mathlib backend builder still sets
`supportsLinking := fun D => D = 3` when given only circle-H1 nonvanishing. -/
theorem t8_backend_still_encodes_D3 (hH1 : circleH1ZNonzero) (D : ℕ) :
    (mathlibCircleLinkingBackend_from_circleH1ZNonzero hH1).supportsLinking D ↔ D = 3 := by
  dsimp [mathlibCircleLinkingBackend_from_circleH1ZNonzero]
  constructor <;> intro h <;> simpa using h

structure T6T8SpineAuditCert : Prop where
  t6_obstruction : ∃ (F : ClosedFramework.ClosedObservableFramework) (base : F.S),
    (¬ (∀ k,
      F.r (F.T^[k + 2] base) / F.r (F.T^[k + 1] base) =
        F.r (F.T^[k + 1] base) / F.r (F.T^[k] base))) ∧
    (¬ (F.r (F.T^[2] base) = F.r (F.T^[1] base) + F.r base))
  t6_algebra_standalone : T6_Phi_Forced
  t7_placeholder_realization : ∀ (D : ℕ) (hD : 2 ≤ D)
    (cell : SubstrateAxioms.CellularCompletion D) (W : ClosedWalkOnCube D)
    (hHam : Hamiltonian W), RealizedDefect cell W = T7CycleRealization.Circle
  t8_linking_encoding : ∀ D : ℕ, SphereAdmitsCircleLinking D ↔ (D : ℤ) - 2 = 1
  t8_odd_dimensions_allowed : ∀ D : ℕ,
    (D ≥ 3 ∧ ¬ 2 ∣ D) ↔ ∃ p : ℕ, p ≥ 1 ∧ D = 2 * p + 1
  t8_h1_proved : circleH1ZIsoInt
  t8_h1_not_linking_premise :
    ∀ D : Dimension, SupportsNontrivialLinking D → D = 3

/-- Checked audit certificate bundling the July 2026 T6–T8 honesty report. -/
theorem t6t8_spine_audit_cert : T6T8SpineAuditCert where
  t6_obstruction := t6_obstruction_closed_framework
  t6_algebra_standalone := t6_quadratic_algebra_standalone
  t7_placeholder_realization := fun D hD cell W hHam =>
    t7_realized_defect_by_definition D hD cell W hHam
  t8_linking_encoding := t8_linking_predicate_unfolds_to_arithmetic
  t8_odd_dimensions_allowed := t8_same_sector_allows_odd_dimensions
  t8_h1_proved := t8_circle_h1_iso_proved
  t8_h1_not_linking_premise := linking_requires_D3

end T6T8SpineAudit
end Verification
end IndisputableMonolith
