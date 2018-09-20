within ThermoCycle.Functions.Enumerations;
type Discretizations = enumeration(
    centr_diff "Central Difference Scheme - Basic",
    centr_diff_AllowFlowReversal
      "Central Difference Scheme - Allows Reverse Flow (but not yet zero flow)",
    upwind "Upwind Scheme - Basic",
    upwind_AllowFlowReversal
      "Upwind Scheme - Allows Flow Reversal (and zero flow too)",
    upwind_smooth "Upwind Scheme with Smoothing");
