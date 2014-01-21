within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses;
partial model PartialRePrCorrelation
  "Base class for Reynolds and Prandtl number correlations"
  extends PartialSinglePhaseCorrelation;

  parameter Real a = 0.500 "Factor";
  parameter Real b = 0.800 "Reynolds exponent";
  parameter Real c = 0.600 "Prandl exponent";

  Modelica.SIunits.Length cLen(min=0) "Characteristic length";
  Modelica.SIunits.Velocity cVel(min=0) "Characteristic velocity";

  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Modelica.SIunits.PrandtlNumber Pr(min=0);
  Modelica.SIunits.NusseltNumber Nu(min=0);

  Medium.ThermalConductivity lambda;
  Medium.DynamicViscosity eta;
  Medium.Density rho;

equation
  // Get transport properties from Medium model
  Pr =Medium.prandtlNumber(state);
  assert(Pr > 0, "Invalid Prandtl number, make sure transport properties are calculated.");
  eta =Medium.dynamicViscosity(state);
  assert(eta > 0, "Invalid viscosity, make sure transport properties are calculated.");
  lambda =Medium.thermalConductivity(state);
  assert(lambda > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
  // Use transport properties to determine dimensionless numbers
  rho = Medium.density(state);
  Re = (rho * cVel * cLen) / eta;
  Nu =  a * Re^b * Pr^c;
  U  = Nu * lambda / cLen;

  annotation(Documentation(info="<html>
<p>Base class. </p>
</html>"));
end PartialRePrCorrelation;
