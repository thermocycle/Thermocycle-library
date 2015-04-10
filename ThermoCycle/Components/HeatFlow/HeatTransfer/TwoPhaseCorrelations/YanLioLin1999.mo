within ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations;
model YanLioLin1999 "Yan, Lio & Lin correlation for condensation"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation;
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPlateHeatExchangerCorrelation(
     d_h=2*Lambda);

  Real G(unit="kg/(s.m.m)") "Mass flux";
  Real G_eq(unit="kg/(s.m.m)") "Equivalent mass flux";
  Modelica.SIunits.PrandtlNumber Pr_l(min=0);
  Modelica.SIunits.NusseltNumber Nu(min=0);
  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Modelica.SIunits.ReynoldsNumber Re_eq(min=0);

  Medium.Density rho_l;
  Medium.Density rho_v;

  Modelica.SIunits.QualityFactor X_m "Average vapour quality";

  Medium.DynamicViscosity mu_l;
  Medium.ThermalConductivity k_l;

equation
  rho_l = Medium.density(bubbleState);
  rho_v = Medium.density(dewState);

  mu_l=Medium.dynamicViscosity(bubbleState);
  assert(mu_l > 0, "Invalid viscosity number, make sure transport properties are calculated.");
  k_l=Medium.thermalConductivity(bubbleState);
  Pr_l=Medium.prandtlNumber(bubbleState);
  assert(Pr_l > 0, "Invalid Prandtl number, make sure transport properties are calculated.");

  X_m = x;

  // Determine dimensionless numbers
  G     = m_dot / A_cro "mass flux";
  G_eq  = G * ((1-X_m) + X_m * (rho_l/rho_v)^0.5);
  Re    = G * d_h/mu_l;
  Re_eq = G_eq * d_h/mu_l;

  //assert(Re_eq > 2000, "Reynolds number too low, make sure you are in the correct flow regime.");
  //assert(Re_eq < 10000, "Reynolds number too high, make sure you are in the correct flow regime.");
  Nu = 4.118 * k_l/ d_h * Re_eq^(0.4) * Pr_l^(1/3);
  U  = Nu * k_l / d_h;

  annotation (Documentation(info="<html>
<p>The model <b>YanLioLin1999</b> extends the partial model <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation\">PartialTwoPhaseCorrelation</a> and calculates the heat transfer coefficient</p>
<p><i><b>Article</b></i><a name=\"YanLio1999\"> </a>(YanLio1999)</p>
<p>Yan, Y.; Lio, H. &AMP; Lin, T.</p>
<p>Condensation heat transfer and pressure drop of refrigerant R-134a in a plate heat exchanger </p>
<p>International Journal of Heat and Mass Transfer, <i>Elsevier</i>, <b>1999</b>, <i>42</i>, 993-1006 </p>
</html>"));
end YanLioLin1999;
