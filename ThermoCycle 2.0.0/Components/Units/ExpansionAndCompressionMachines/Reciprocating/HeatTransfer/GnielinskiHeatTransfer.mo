within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
partial model GnielinskiHeatTransfer
  "Recip heat transfer based on Gnielinski pipe equation"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;

  import Modelica.Constants.pi;
  Modelica.SIunits.Length[n] Gamma(min=0) "Characteristic length";
  Modelica.SIunits.Velocity[n] Lambda(min=0) "Characteristic velocity";

  // Other things to define
  Real[n] xtra "Reynolds correction factor";
  Real[n] zeta "Friction factor";
  Real[n] K "Correction term";

  Modelica.SIunits.Length[n] D(min=0) "Pipe diameter";
  Modelica.SIunits.Length[n] L(min=0) "Pipe length";

  Modelica.SIunits.ReynoldsNumber[n] Re(min=0);
  Modelica.SIunits.PrandtlNumber[n] Pr(min=0);
  Modelica.SIunits.NusseltNumber[n] Nu(min=0);

  Modelica.SIunits.ThermalConductivity[n] lambda;
  Modelica.SIunits.DynamicViscosity[n] eta;
  Modelica.SIunits.SpecificHeatCapacityAtConstantPressure[n] cp;

  Real[n] numerator;
  Real[n] denominator;

equation
  for i in 1:n loop
    // Get transport properties from Medium model
    eta[i] = Medium.dynamicViscosity(states[i]);
    assert(eta[i] > 0, "Invalid viscosity, make sure transport properties are calculated.");
    lambda[i] = Medium.thermalConductivity(states[i]);
    assert(lambda[i] > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
    cp[i] = Medium.specificHeatCapacityCp(states[i]);
    assert(cp[i] > 0, "Invalid heat capacity, make sure that your are not in the two-phase region.");
    // Use transport properties to determine dimensionless numbers
    Pr[i]          = cp[i] * eta[i] / lambda[i];
    Re[i]          = (Medium.density(states[i]) * Lambda[i] * Gamma[i]) / eta[i];
    numerator[i]   = (zeta[i]/8.) * (Re[i]-xtra[i]) * Pr[i];
    denominator[i] = 1 + 12.7 * sqrt(zeta[i]/8.) *( Pr[i]^(2./3.) - 1.);
    surfaceAreas[i] = pistonCrossArea + 2 * sqrt(pistonCrossArea*pi)*L[i]
      "Defines clearance length";
    D[i]           = Gamma[i];
    Nu[i]          = numerator[i] / denominator[i] *( 1 + (D[i]/L[i])^(2./3.))*
      K[i];
    h[i]           = Nu[i] * lambda[i] / Gamma[i];

  end for;
  annotation(Documentation(info="<html>
<p>Base class from Python code. </p>
</html>"));
end GnielinskiHeatTransfer;
