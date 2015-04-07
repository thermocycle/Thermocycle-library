within ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations;
model Cooper_Evaporation "Cooper correlation for evaporation"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation;

  Real p_r "p/p_crit";
  Real M;
  parameter Real R_p = 1 "Roughness, disable with 1";
  parameter Real C = 1.5 "Enhancement term, 55*1.5 for plate HX";
equation
  M = Medium.getMolarMass() "kg/mol, needs transform to kg/kmol";
  p_r = Medium.pressure(filteredState)/Medium.getCriticalPressure();
  U = C*55*p_r^(0.12-0.2*log(R_p))*log(p_r)^(-0.55)*q_dot^(0.67)*(M*1e3)^(-0.5);

  annotation (Documentation(info="<html>
<p>The model <b>Cooper_Evaporation</b> extends the partial model <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialTwoPhaseCorrelation\">PartialTwoPhaseCorrelation</a> and calculates the heat transfer coefficient</p>
<p>The included factor of 1.5 is taken from Palm and Claesson 2006 - Plate heat exchangers: Calculation methods for singleand two-phase flow, Heat Transfer Engineering, 2006, 27, 88-98 </p>
<p><i><b>Article</b></i><a name=\"Cooper1984\"> </a>(Cooper1984)</p>
<p>Cooper, M. G.</p>
<p>Heat Flow Rates in Saturated Nucleate Pool Boiling---A Wide-Ranging Examination Using Reduced Properties</p>
<p><i>Advances in Heat Transfer, Elsevier, </i><b>1984</b><i>, 16</i>, 157-239 </p>
</html>"));
end Cooper_Evaporation;
