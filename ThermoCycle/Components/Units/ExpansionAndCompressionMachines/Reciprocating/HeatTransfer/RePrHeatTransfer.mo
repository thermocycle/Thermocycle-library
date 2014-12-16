within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
partial model RePrHeatTransfer
  "Recip heat transfer based on Reynolds and Prandl number"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;

  parameter Real a = 0.500 "Factor";
  parameter Real b = 0.800 "Reynolds exponent";
  parameter Real c = 0.600 "Prandl exponent";

  Modelica.SIunits.Length[n] Gamma(min=0) "Characteristic length";
  Modelica.SIunits.Velocity[n] Lambda(min=0) "Characteristic velocity";

  Modelica.SIunits.ReynoldsNumber[n] Re(min=0);
  Modelica.SIunits.PrandtlNumber[n] Pr(min=0);
  Modelica.SIunits.NusseltNumber[n] Nu(min=0);

  Modelica.SIunits.ThermalConductivity[n] lambda;
  Modelica.SIunits.DynamicViscosity[n] eta;

equation
  for i in 1:n loop
    // Get transport properties from Medium model
    Pr[i] = Medium.prandtlNumber(states[i]);
    assert(Pr[i] > 0, "Invalid Prandtl number, make sure transport properties are calculated.");
    eta[i] = Medium.dynamicViscosity(states[i]);
    assert(eta[i] > 0, "Invalid viscosity, make sure transport properties are calculated.");
    lambda[i] = Medium.thermalConductivity(states[i]);
    assert(lambda[i] > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
    // Use transport properties to determine dimensionless numbers
    Re[i] = (Medium.density(states[i]) * Lambda[i] * Gamma[i]) / eta[i];
    Nu[i] =  a * Modelica.Fluid.Utilities.regPow(Re[i],b) * Modelica.Fluid.Utilities.regPow(Pr[i],c);
    h[i]  = Nu[i] * lambda[i] / Gamma[i];
  end for;
  annotation(Documentation(info="<html>
<p>Base class from Python code. </p>
</html>"));
end RePrHeatTransfer;
