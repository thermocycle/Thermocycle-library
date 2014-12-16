within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model Kornhauser1994 "Gas spring correlation of Kornhauser 1994"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;

  parameter Real a = 0.56 "Factor";
  parameter Real b = 0.69 "Peclet exponent";

  import Modelica.Constants.pi;

  Modelica.SIunits.Length[n] Gamma(min=0) "Characteristic length";
  Modelica.SIunits.Velocity[n] Lambda(min=0) "Characteristic velocity";

  Modelica.SIunits.PecletNumber[n] Pe(min=0);
  Modelica.SIunits.SpecificHeatCapacityAtConstantPressure[n] cp;
  Modelica.SIunits.Volume[n] volume "Cylinder volume";
  Modelica.SIunits.Length[n] D_h "Hydraulic diameter";
  Modelica.SIunits.ThermalDiffusivity[n] alpha_f "Thermal diffusivity";

  Modelica.SIunits.NusseltNumber[n] Nu(min=0);
  Modelica.SIunits.ThermalConductivity[n] lambda;
  Modelica.SIunits.DynamicViscosity[n] eta;

  //Real dT[n];

  //Complex Nu_c[n], T_c[n], T_w[n];

equation
  for i in 1:n loop
    // Get transport properties from Medium model
    eta[i] = Medium.dynamicViscosity(states[i]);
    assert(eta[i] > 0, "Invalid viscosity, make sure transport properties are calculated.");
    lambda[i] = Medium.thermalConductivity(states[i]);
    assert(lambda[i] > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
    cp[i] = Medium.specificHeatCapacityCp(states[i]);
    assert(cp[i] > 0, "Invalid heat capacity, make sure that your are not in the two-phase region.");
    // Find characteristic values
    volume[i] = pistonCrossArea * position[i] "Get volumes";
    D_h[i] =  4 * volume[i] / pistonCrossArea "Hydraulic diameter";
    Gamma[i] = D_h[i];
    Lambda[i] = omega_c/2/pi "Angular velocity";
    // Use transport properties to determine dimensionless numbers
    alpha_f[i]  = lambda[i] / (Medium.density(states[i]) * cp[i]);
    Pe[i] = (Lambda[i] * Gamma[i] * Gamma[i]) / (4*alpha_f[i]);
    assert(Pe[i] > 0, "Invalid Peclet number, make sure transport properties are calculated.");
    Nu[i] =  a * Pe[i]^b;
    h[i]  = Nu[i] * lambda[i] / Gamma[i];
    //dT[i] = der(Medium.temperature(states[i]));
    //Nu_c[i] = Complex(Nu[i],Nu[i]);
  end for;
  annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Kornhauser1994\">(Kornhauser1994)</a></dt>
<dd>Kornhauser, A. &amp; Smith, J.</dd>
<dd><i>Application of a complex Nusselt number to heat transfer during compression and expansion</i></dd>
<dd>Transactions of the ASME. Journal of Heat Transfer, <b>1994</b>, Vol. 116(3), pp. 536-542</dd>
</dl>
<p>You can find the paper describing the correlation here: <a href=\"http://heattransfer.asmedigitalcollection.asme.org/article.aspx?articleid=1441736\">http://heattransfer.asmedigitalcollection.asme.org/article.aspx?articleid=1441736</a></p>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>
"));
end Kornhauser1994;
