within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer;
partial model RePrHeatTransfer
  "Recip heat transfer based on Reynolds and Prandl number"
  extends
    ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;

  parameter Real a = 0.500 "Factor";
  parameter Real b = 0.800 "Reynolds exponent";
  parameter Real c = 0.600 "Prandl exponent";

  Modelica.SIunits.Length[n] Gamma "Characteristic length";
  Modelica.SIunits.Velocity[n] Lambda "Characteristic velocity";

  Modelica.SIunits.ReynoldsNumber[n] Re;
  Modelica.SIunits.PrandtlNumber[n] Pr;
  Modelica.SIunits.NusseltNumber[n] Nu;
  Modelica.SIunits.CoefficientOfHeatTransfer[n] h;
  Modelica.SIunits.ThermalConductivity[n] lambda;
  Modelica.SIunits.DynamicViscosity[n] eta;
  Modelica.SIunits.HeatFlux[n] q_w "Heat flux from wall";
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
    Nu[i] =  a * Re[i]^b * Pr[i]^c;
    h[i]  = Nu[i] * lambda[i] / Gamma[i];
    // There is a small mistake in equation 19 of the paper, DeltaT goes in the numerator.
    -q_w[i] = h[i] * (Ts[i] - heatPorts[i].T);
    Q_flows[i] = surfaceAreas[i]*q_w[i];
  end for;
  annotation(Documentation(info="<html>
<p>Base class from Python code. </p>
</html>"));
end RePrHeatTransfer;
