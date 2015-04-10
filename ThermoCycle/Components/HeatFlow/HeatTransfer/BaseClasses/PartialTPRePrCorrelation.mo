within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses;
partial model PartialTPRePrCorrelation
  "Base class for Reynolds and Prandtl number correlations"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation;

  parameter Real a = 0.500 "Factor";
  parameter Real b = 0.800 "Reynolds exponent";
  parameter Real c = 0.600 "Prandl exponent";

  Modelica.SIunits.Length cLen(min=0) "Characteristic length";
  Modelica.SIunits.Velocity cVel "Characteristic velocity";

  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Modelica.SIunits.PrandtlNumber Pr(min=0);
  Modelica.SIunits.NusseltNumber Nu(min=0);

  Medium.ThermalConductivity lambda;
  Medium.DynamicViscosity eta;
  Medium.Density rho;

equation
  // Get transport properties from Medium model
  Pr = min(100, Medium.prandtlNumber(filteredState));
  assert(Pr > 0, "Invalid Prandtl number, make sure transport properties are calculated.");
  eta = min(10, Medium.dynamicViscosity(filteredState));
  assert(eta > 0, "Invalid viscosity, make sure transport properties are calculated.");
  lambda = min(10, Medium.thermalConductivity(filteredState));
  assert(lambda > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
  // Use transport properties to determine dimensionless numbers
  rho = Medium.density(filteredState);
  Re = (rho * abs(cVel) * cLen) / eta;
  Nu =  a * Re^b * Pr^c;
  U  = Nu * lambda / cLen;

annotation(Documentation(info="<html>

<p><big> The model <b>PartialTPRePrCorrelation </b> is the basic model
 for the calculation of heat transfer coefficient using Reynolds and Prandtl number.</p> 


 <p></p>
</html>"));
end PartialTPRePrCorrelation;
