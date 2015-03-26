within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses;
partial model PartialTPRePrCorrelation
  "Base class for Reynolds and Prandtl number correlations"
  extends PartialSinglePhaseCorrelation(
  redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialTwoPhaseMedium
  constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium);

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

  Medium.ThermodynamicState filteredState "Thermodynamic state";

equation
  // Filter the input to provide saturation conditions only
  if     (Medium.vapourQuality(state) > 0.0 and Medium.vapourQuality(state) < 0.5) then
    filteredState = Medium.setBubbleState(Medium.setSat_p(Medium.pressure(state)));
  elseif (Medium.vapourQuality(state) > 0.5 and Medium.vapourQuality(state) < 1.0) then
    filteredState = Medium.setDewState(Medium.setSat_p(Medium.pressure(state)));
  else
    filteredState = state;
  end if;

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
