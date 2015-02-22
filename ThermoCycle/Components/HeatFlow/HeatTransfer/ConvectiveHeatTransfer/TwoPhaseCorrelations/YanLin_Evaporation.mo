within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations;
model YanLin_Evaporation "Yan & Lin correlation for evaporation"
  extends BaseClasses.PartialTwoPhaseCorrelation;

  parameter Modelica.SIunits.Length d_hyd(min=0)
    "Hydraulic diameter (2*V/A_lateral)";
  parameter Modelica.SIunits.Area A_cro(min=0) = Modelica.Constants.pi * d_hyd^2 / 4
    "Cross-sectional area";

  Real G(unit="kg/(s.m.m)") "Mass flux";
  Real G_eq(unit="kg/(s.m.m)") "Equivalent mass flux";
  Real Bo_eq(unit="1") "Equivalent boiling number";
  Modelica.SIunits.PrandtlNumber Pr_l(min=0);
  Modelica.SIunits.NusseltNumber Nu(min=0);
  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Modelica.SIunits.ReynoldsNumber Re_eq(min=0);

  Medium.Density rho_l;
  Medium.Density rho_v;
  Medium.SpecificEnthalpy h_l;
  Medium.SpecificEnthalpy h_v;
  Medium.SpecificEnthalpy i_fg;

  Modelica.SIunits.QualityFactor X_m "Average vapour quality";

  Medium.DynamicViscosity mu_l;
  Medium.ThermalConductivity k_l;

equation
  rho_l = Medium.density(bubbleState);
  rho_v = Medium.density(dewState);
  h_l   = Medium.specificEnthalpy(bubbleState);
  h_v   = Medium.specificEnthalpy(dewState);
  i_fg  = (h_v-h_l);

  mu_l=Medium.dynamicViscosity(bubbleState);
  assert(mu_l > 0, "Invalid viscosity number, make sure transport properties are calculated.");
  k_l=Medium.thermalConductivity(bubbleState);
  Pr_l=Medium.prandtlNumber(bubbleState);
  assert(Pr_l > 0, "Invalid Prandtl number, make sure transport properties are calculated.");

  X_m = x;

  // Determine dimensionless numbers
  G     = m_dot / A_cro "mass flux";
  G_eq  = G * ((1-X_m) + X_m * (rho_l/rho_v)^0.5) "Eq. 35";
  Bo_eq = q_dot / (G_eq*i_fg) "Eq. 34";
  Re_eq = G_eq * d_hyd/mu_l "Eq. 34";
  Re = G * d_hyd/mu_l;

  //assert(Re_eq > 2000, "Reynolds number too low, make sure you are in the correct flow regime.");
  //assert(Re_eq < 10000, "Reynolds number too high, make sure you are in the correct flow regime.");

  Nu = 1.926*Pr_l^(1/3)*Bo_eq^(0.3)*Re_eq^(0.5)*((1 - X_m) + X_m*(rho_l/rho_v)^0.5) "Eq. 36";
  U  = Nu * k_l / d_hyd;

  annotation (Documentation(info="<html>
<p>The model <b>Shah_Evaporation</b> extends the partial model <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialTwoPhaseCorrelation\">PartialTwoPhaseCorrelation</a> and calculates the heat transfer coefficient based on the Shah correlation for evaporation </p>
<dl><dt>article<a name=\"Shah1982\">(</a>Shah1982)</dt>
<dd>Shah, M.M.</dd>
<dd><i>Chart Correlation For Saturated Boiling Heat Transfer: Equations And Further Study</i></dd>
<dd>ASHRAE Transactions, <b>1982</b>, Vol. 88, pp. 185-196 </dd>
<dt><i><b>Article</i><a name=\"Yan1999a\"> </a>(Yan1999a)</b></dt><dt>Yan, Y. &AMP; Lin, T.</dt><dt>Evaporation heat transfer and pressure drop of refrigerant R-134a in a plate heat exchanger</dt><dt><i>Journal of Heat Transfer, ASME-AMER SOC MECHANICAL ENG, </i><b>1999</b><i>, 121</i>, 118-127 </dt>
</dl></html>"));
end YanLin_Evaporation;
