within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model Kornhauser1994Full "Complex gas spring correlation of Kornhauser 1994"
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

  Modelica.SIunits.NusseltNumber[n] Nu;
  Modelica.SIunits.NusseltNumber[n] Nu_r(min=0);
  Modelica.SIunits.NusseltNumber[n] Nu_i(min=0);

  Modelica.SIunits.ThermalConductivity[n] lambda;
  Modelica.SIunits.DynamicViscosity[n] eta;

  //Real[n] dTdt;
  //Real[n] dddt;

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
    assert(Pe[i] > 10, "Invalid Peclet number, make sure transport properties are calculated and you operate at a sufficiently high speed.");
    // Adding the complex part, note that Nu_real = Nu_im for Pe>100
    Nu_r[i] =  a * Pe[i]^b;
    Nu_i[i] =  Nu_r[i];
    // rewrite everything to get the alternate Nusselt number to stick into the original equation
    // A rewrite of Eq. 11 from the original 1994 paper
    Nu[i] = Nu_r[i] + Nu_i[i]/omega_c * der(Ts[i]) / (Ts[i] - heatPorts[i].T);
    //dddt[i] = WorkingFluid.density_derh_p(states[i])*der(Medium.specificEnthalpy(states[i])) + WorkingFluid.density_derp_h(states[i])*der(Medium.pressure(states[i]));
    //dTdt[i] = 1/WorkingFluid.partialDeriv_state("p","T","d",states[i])*der(Medium.pressure(states[i])) + 1/WorkingFluid.partialDeriv_state("d","T","p",states[i])*dddt[i];
    //Nu[i] = Nu_r[i] + Nu_i[i]/Gamma[i] * dTdt[i] / (Ts[i] - heatPorts[i].T);
    h[i]  = Nu[i] * lambda[i] / Gamma[i];
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
end Kornhauser1994Full;
