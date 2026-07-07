import IndisputableMonolith

/-!
# Paper Index: FoP paper verification appendix (machine-checked surface)

This module is the machine-checked index for
\emph{The Unique Reciprocal Cost and the Machine-Checked Boundary of Its Physical Extrapolation}
(\texttt{papers/RS\_v1\_rewrite/rs\_v1\_fop.tex}). It does two things:

1. **Existence**: every public Lean declaration cited in the verification appendix is
   referenced by full name below (`#check`), so `lake build Paper` fails if any cited
   name is absent from this repository.

2. **Exact statements**: for headline declarations whose formal statements are reproduced
   in the verification appendix, the printed statement is restated here as an `example`
   discharged by the library declaration. Drift from the paper breaks the build.

No new mathematics is introduced here; every proof term is a citation.
Additional `#check` lines below the appendix table are supporting audit
surface (constants, ILG scaffold, recognition quotient), not load-bearing
paper claims.
-/

namespace PaperIndex

open IndisputableMonolith

/-! ## Layer: T-2 through T8 spine -/

#check @IndisputableMonolith.Foundation.NothingToDistinction.nothingToDistinctionCert
#check @IndisputableMonolith.Foundation.TMinus1ToT8Bridge.complete_forcing_chain_tminus2_to_t8
#check @IndisputableMonolith.Foundation.TMinus1ToT8Bridge.complete_forcing_chain_t8_nonempty
#check @IndisputableMonolith.Foundation.CircleWindingChain.circleH1ZNonzero_unconditional
#check @IndisputableMonolith.Foundation.CircleWindingChain.circleH1ZIsoInt_holds

/-! ## Layer: Boolean floor -/

#check @IndisputableMonolith.Foundation.TMinus1ToT8Bridge.bool_normalized_two_point_floor
#check @IndisputableMonolith.Foundation.TMinus1ToT8Bridge.normalized_two_point_cost_eq_indicator
#check @IndisputableMonolith.Foundation.TMinus1ToT8Bridge.bool_normalized_two_point_floor_unique

/-! ## Layer: Recognition quotient / gauge -/

#check @IndisputableMonolith.RecognitionCore.forced_quotient_iff
#check @IndisputableMonolith.RecognitionCore.gauge_from_indistinguishability
#check @IndisputableMonolith.RecognitionCore.signature_complete_iff_separating
#check @IndisputableMonolith.RecognitionCore.one_bit_not_complete_boundary
#check @IndisputableMonolith.RecognitionCore.recognizer_refinement

/-! ## Layer: Reciprocal cost -/

#check @IndisputableMonolith.Cost.FunctionalEquation.law_of_logic_forces_jcost
#check @IndisputableMonolith.Cost.FunctionalEquation.law_of_logic_forces_jcost_with_regularization
#check @IndisputableMonolith.CostUniqueness.unique_cost_on_pos_from_rcl
#check @IndisputableMonolith.CostUniqueness.Jcost_satisfies_composition_law
#check @IndisputableMonolith.CostUniqueness.Jcost_continuous_pos

/-- **Headline restatement (verification appendix).** The uniqueness theorem exactly as
printed in the paper: any reciprocal-symmetric, normalized, composition-law,
calibrated, continuous-on-(0,∞) cost is `Jcost` on the positive reals. -/
example (F : ℝ → ℝ)
    [Cost.FunctionalEquation.AczelSmoothnessPackage]
    (hRecip : Cost.FunctionalEquation.IsReciprocalCost F)
    (hNorm : Cost.FunctionalEquation.IsNormalized F)
    (hComp : Cost.FunctionalEquation.SatisfiesCompositionLaw F)
    (hCalib : Cost.FunctionalEquation.IsCalibrated F)
    (hCont : ContinuousOn F (Set.Ioi 0)) :
    ∀ x : ℝ, 0 < x → F x = Cost.Jcost x :=
  Cost.FunctionalEquation.law_of_logic_forces_jcost F hRecip hNorm hComp hCalib hCont

/-! ## Layer: Golden ratio -/

#check @IndisputableMonolith.Foundation.TMinus1ToT8Bridge.T5_To_T6_SelfSimilarity_Bridge
#check @IndisputableMonolith.Foundation.TMinus1ToT8Bridge.t6_holds
#check @IndisputableMonolith.Foundation.PhiForcing.phi_equation
#check @IndisputableMonolith.Foundation.PhiForcing.phi_unique_self_similar

/-! ## Layer: Dimension and eight ticks -/

#check @IndisputableMonolith.Foundation.AlexanderDuality.alexander_duality_circle_linking
#check @IndisputableMonolith.Foundation.DimensionForcing.linking_requires_D3
#check @IndisputableMonolith.Foundation.DimensionForcing.dimension_forced
#check @IndisputableMonolith.Foundation.TMinus1ToT8Bridge.t7_from_t8
#check @IndisputableMonolith.Patterns.grayCycle3

/-- **Headline restatement (verification appendix).** `SphereAdmitsCircleLinking D ↔ D = 3`. -/
example (D : ℕ) :
    Foundation.AlexanderDuality.SphereAdmitsCircleLinking D ↔ D = 3 :=
  Foundation.AlexanderDuality.alexander_duality_circle_linking D

/-! ## Layer: Cube-count integers (Gap-45 certificate) -/

#check @IndisputableMonolith.Foundation.GapDerivation.gap_at_D3
#check @IndisputableMonolith.Foundation.GapDerivation.gap45_cert
#check @IndisputableMonolith.Foundation.GapDerivation.parityCount_matches_enumeration
#check @IndisputableMonolith.Foundation.GapDerivation.dual_routes
#check @IndisputableMonolith.Foundation.GapDerivation.Gap45Cert

/-- **Headline restatement (verification appendix).** `dimensionGap D = 45` at `D = 3`
(the upstream library proof uses `native_decide`; kernel `decide` re-proofs below
eliminate compiler trust for the cited arithmetic). -/
example : Foundation.GapDerivation.dimensionGap Foundation.GapDerivation.D = 45 :=
  Foundation.GapDerivation.gap_at_D3

/-- **Headline restatement (verification appendix).** `2^D − D = configDim D`. -/
example : 2 ^ Foundation.GapDerivation.D - Foundation.GapDerivation.D
    = Foundation.GapDerivation.configDim Foundation.GapDerivation.D :=
  Foundation.GapDerivation.dual_routes

/-! ### Kernel `decide` re-proofs of the cube-count arithmetic

The upstream library proves these by `native_decide` (compiler trust). The integers
are small, so `Paper.lean` re-proves each cited fact by kernel `decide` with no
extra axioms beyond the Lean base. -/

example : Foundation.GapDerivation.dimensionGap Foundation.GapDerivation.D = 45 := by decide
example : Foundation.GapDerivation.dimensionGap Foundation.GapDerivation.D = 9 * 5 := by decide
example : 2 ^ Foundation.GapDerivation.D - Foundation.GapDerivation.D
    = Foundation.GapDerivation.configDim Foundation.GapDerivation.D := by decide
example : Nat.Coprime (2 ^ Foundation.GapDerivation.D)
    (Foundation.GapDerivation.dimensionGap Foundation.GapDerivation.D) := by decide

/-! ## Layer: Torsion cube counts (11 and 6) -/

#check @IndisputableMonolith.Masses.TorsionForcing.passiveAtLevel_1
#check @IndisputableMonolith.Masses.TorsionForcing.passiveAtLevel_2
#check @IndisputableMonolith.Masses.TorsionForcing.cw_prerequisite_forces_three
#check @IndisputableMonolith.Masses.TorsionForcing.six_is_not_admissible
#check @IndisputableMonolith.Masses.TorsionForcing.rcl_forced_torsion_unique
#check @IndisputableMonolith.Masses.TorsionForcing.RCLForcedTorsion

/-- **Headline restatement (verification appendix).** `passiveAtLevel D 1 = 11`. -/
example : Masses.TorsionForcing.passiveAtLevel Constants.AlphaDerivation.D 1 = 11 :=
  Masses.TorsionForcing.passiveAtLevel_1

/-- **Headline restatement (verification appendix).** `passiveAtLevel D 2 = 6`. -/
example : Masses.TorsionForcing.passiveAtLevel Constants.AlphaDerivation.D 2 = 6 :=
  Masses.TorsionForcing.passiveAtLevel_2

/-- Kernel-checked re-proofs of the cube counts 11 and 6 (no compiler trust). -/
example : Masses.TorsionForcing.passiveAtLevel Constants.AlphaDerivation.D 1 = 11 := by decide
example : Masses.TorsionForcing.passiveAtLevel Constants.AlphaDerivation.D 2 = 6 := by decide

/-- **Headline restatement (verification appendix).** The CW prerequisite admits exactly
the three profiles `⟨false,false⟩`, `⟨true,false⟩`, `⟨true,true⟩`. -/
example (p : Masses.TorsionForcing.CouplingProfile)
    (h : Masses.TorsionForcing.CWPrerequisite p) :
    p = ⟨false, false⟩ ∨ p = ⟨true, false⟩ ∨ p = ⟨true, true⟩ :=
  Masses.TorsionForcing.cw_prerequisite_forces_three p h

/-- **Headline restatement (verification appendix).** The faces-without-edges profile has
torsion 6 and violates the CW prerequisite. -/
example : Masses.TorsionForcing.profileTorsion Constants.AlphaDerivation.D ⟨false, true⟩ = 6
    ∧ ¬ Masses.TorsionForcing.CWPrerequisite ⟨false, true⟩ :=
  Masses.TorsionForcing.six_is_not_admissible

/-- **Headline restatement (verification appendix).** Uniqueness relative to the
`RCLForcedTorsion` predicate (which fixes the generation-to-profile
assignment inside its definition, per the paper's gloss). -/
example (τ : RecogSpec.Generation → ℤ)
    (h : Masses.TorsionForcing.RCLForcedTorsion Constants.AlphaDerivation.D τ) :
    τ = RecogSpec.generationTorsion :=
  Masses.TorsionForcing.rcl_forced_torsion_unique τ h

/-! ## Layer: Native constants -/

#check @IndisputableMonolith.Constants.hbar_eq_phi_inv_fifth
#check @IndisputableMonolith.Constants.hbar_action_identity
#check @IndisputableMonolith.Constants.G
#check @IndisputableMonolith.Constants.kappa_einstein_eq

/-! ## Layer: ILG / gravity scaffold -/

#check @IndisputableMonolith.Gravity.ILG.w_t_ref
#check @IndisputableMonolith.Gravity.ILG.w_t_rescale
#check @IndisputableMonolith.Gravity.ILG.w_t_nonneg
#check @IndisputableMonolith.Gravity.ILG.w_t_ge_one
#check @IndisputableMonolith.Gravity.ParameterizationBridge.accel_mul_Tdyn_sq
#check @IndisputableMonolith.Gravity.ParameterizationBridge.time_ratio_sq_eq_accel_ratio_mul_r_ratio
#check @IndisputableMonolith.Gravity.GravityParameters.alpha_gravity_eq_two_alphaLock
#check @IndisputableMonolith.Gravity.GravityParameters.upsilon_star_eq_phi
#check @IndisputableMonolith.Gravity.DerivedFactors.hsb_suppression_limit
#check @IndisputableMonolith.Gravity.DerivedFactors.lsb_unsuppressed_limit
#check @IndisputableMonolith.Gravity.Rotation.vrot_sq
#check @IndisputableMonolith.Gravity.Rotation.vrot_flat_of_linear_Menc

/-! ## Cube-combinatorics helpers (Constants/AlphaDerivation.lean)

The verification appendix reproduces these definitions as the source of the integers 11
and 6 ("The integers 11 and 6 seed the α and ηB expressions"). -/

#check @IndisputableMonolith.Constants.AlphaDerivation.cube_edges
#check @IndisputableMonolith.Constants.AlphaDerivation.cube_faces
#check @IndisputableMonolith.Constants.AlphaDerivation.passive_field_edges

/-! ## Layer: Boundary certificates (Section 6) -/

#check @IndisputableMonolith.Verification.DimensionalRigidity.no_dimensionless_combination
#check @IndisputableMonolith.Verification.DimensionalRigidity.dimMatrix_det
#check @IndisputableMonolith.Verification.DimensionalRigidity.si_values_not_derivable_from_pure_numbers
#check @IndisputableMonolith.Foundation.PrimitiveDistinction.equality_cost_insufficient_for_recognition
#check @IndisputableMonolith.Verification.T5.LedgerCost.aczel_hypothesis_refuted
#check @IndisputableMonolith.Verification.T5.LedgerCost.quadraticWitness

/-- **Headline restatement (verification appendix).** No nontrivial dimensionless monomial in
`(c, hbar, G)` over `Q`. -/
example (a b g : ℚ)
    (h : ∀ i : Fin 3, a * Verification.DimensionalRigidity.dimC i +
        b * Verification.DimensionalRigidity.dimHbar i +
        g * Verification.DimensionalRigidity.dimG i = 0) :
    a = 0 ∧ b = 0 ∧ g = 0 :=
  Verification.DimensionalRigidity.no_dimensionless_combination a b g h

/-- **Headline restatement (verification appendix).** The primitive-distinction floor
does not force the composition law (Certificate 2). -/
example (weight : ℝ) (hw : weight ≠ 0) :
    ¬ Foundation.PrimitiveDistinction.CompositionConsistency
        (Foundation.PrimitiveDistinction.hammingCostOnReal weight) :=
  Foundation.PrimitiveDistinction.equality_cost_insufficient_for_recognition weight hw

/-- **Headline restatement (verification appendix).** Aczél's Theorem 3.1.3 hypothesis
is refuted by an explicit quadratic witness (Certificate 2 companion). -/
example : ¬ Verification.T5.LedgerCost.aczel_theorem_3_1_3_hypothesis :=
  Verification.T5.LedgerCost.aczel_hypothesis_refuted

/-! ## Layer: Exhibit retraction records -/

#check @IndisputableMonolith.Cosmology.EtaBPrefactorDerivation.c_RS
#check @IndisputableMonolith.Cosmology.EtaBPrefactorDerivation.eta_B_prefactor_cert
#check @IndisputableMonolith.Masses.Verification.MassVerificationCert
#check @IndisputableMonolith.Masses.Verification.mass_verification_cert_exists

/-! ## Layer: T6–T8 spine honesty audit (July 2026) -/

#check @IndisputableMonolith.Verification.T6T8SpineAudit.t6t8_spine_audit_cert
#check @IndisputableMonolith.Verification.T6T8SpineAudit.t6_obstruction_closed_framework
#check @IndisputableMonolith.Foundation.HierarchyRealizationObstruction.closedFramework_does_not_force_realizedHierarchy_fields
#check @IndisputableMonolith.Foundation.T7CycleRealization.t7_cycle_realizes_circle
#check @IndisputableMonolith.Verification.DimensionLinking.allowed_set_A_characterization

end PaperIndex
