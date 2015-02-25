within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations;
partial model Cooper_Evaporation "Cooper correlation for evaporation"
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

  Real p_star;

  annotation (Documentation(info="<html>
<p>The model <b>Cooper_Evaporation</b> extends the partial model <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialTwoPhaseCorrelation\">PartialTwoPhaseCorrelation</a> and calculates the heat transfer coefficient</p>
<p>The included factor is taken from Palm and Claesson 2006 - Plate heat exchangers: Calculation methods for singleand two-phase flow, Heat Transfer Engineering, 2006, 27, 88-98 </p>
<p><i><b>Article</b></i><a name=\"Cooper1984\"> </a>(Cooper1984)</p>
<p>Cooper, M. G.</p>
<p>Heat Flow Rates in Saturated Nucleate Pool Boiling---A Wide-Ranging Examination Using Reduced Properties</p>
<p><i>Advances in Heat Transfer, Elsevier, </i><b>1984</b><i>, 16</i>, 157-239 </p>
</html>"));
end Cooper_Evaporation;
