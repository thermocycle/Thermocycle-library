within ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations;
model DittusBoelter1930
  "The Dittus-Boelter correlation for turbulent single phase flow"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation;
  //extends
  //  ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPipeCorrelation;
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPlateHeatExchangerCorrelation;

  //parameter Modelica.SIunits.Length d_h(min=0)=0 "Hydraulic diameter";
  //parameter Modelica.SIunits.Area A_cro(min=0)=Modelica.Constants.pi * d_h^2 / 4
  //  "Cross-sectional area";

  parameter Real a = 0.023 "Factor: 0.023 pipe, 0.035 plate HX?";
  parameter Real b = 0.800 "Reynolds exponent";
  parameter Real c = 0.400 "Prandl exponent: 0.4 heating, 0.3 cooling";

  Modelica.SIunits.Length cLen(min=0) "Characteristic length";
  Modelica.SIunits.Velocity cVel "Characteristic velocity";

  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Modelica.SIunits.PrandtlNumber Pr(min=0);
  Modelica.SIunits.NusseltNumber Nu(min=0);

  Medium.ThermalConductivity lambda;
  Medium.DynamicViscosity eta;
  Medium.Density rho;

  Modelica.SIunits.VolumeFlowRate V_dot;

equation
  rho = Medium.density(state);
  cLen  = d_h;
  V_dot = m_dot / rho;
  cVel  = abs(V_dot) / A_cro;
  // Get transport properties from Medium model
  Pr = min(100, Medium.prandtlNumber(state));
  assert(Pr > 0, "Invalid Prandtl number, make sure transport properties are calculated.");
  eta = min(10, Medium.dynamicViscosity(state));
  assert(eta > 0, "Invalid viscosity, make sure transport properties are calculated.");
  lambda = min(10, Medium.thermalConductivity(state));
  assert(lambda > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
  // Use transport properties to determine dimensionless numbers
  Re = (rho * abs(cVel) * cLen) / eta;
  //assert(Re > 1000, "Invalid Reynolds number, Dittus-Boelter is only for fully turbulent flow.");
  Nu =  a * Re^b * Pr^c;
  U  = Nu * lambda / cLen;

annotation(Documentation(info="<html>

<p><big> The model <b>DittusBoelter</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation\">PartialSinglePhaseCorrelation\</a> and allows the user to define
 the value of the hydraulic diameter for the calculation of the heat transfer coefficient based on the DittusBoelter correlation.
 <p></p>
</html>"));
end DittusBoelter1930;
