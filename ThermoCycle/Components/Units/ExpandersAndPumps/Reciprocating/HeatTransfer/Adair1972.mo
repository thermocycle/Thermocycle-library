within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer;
model Adair1972 "Recip correlation of Adair et al. 1972, changeable parameters"
  extends
    ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.RePrHeatTransfer(
     final a = 0.053, final b = 0.800, final c = 0.600);

  import Modelica.Constants.pi;
  Modelica.SIunits.Length[n] De "Equivalent diameter 6V/A";
  Modelica.SIunits.ReynoldsNumber[n] Re;
  Modelica.SIunits.PrandtlNumber[n] Pr;
  Modelica.SIunits.NusseltNumber[n] Nu;
  Modelica.SIunits.CoefficientOfHeatTransfer[n] h;
  Modelica.SIunits.ThermalConductivity[n] lambda;
  Modelica.SIunits.DynamicViscosity[n] eta;
  Modelica.SIunits.Velocity[n] omega "Angular crank velocity";
  Modelica.SIunits.Velocity[n] omega_g "Swirl velocity";
  Modelica.SIunits.Velocity[n] omega_g1 "Swirl velocity";
  Modelica.SIunits.Velocity[n] omega_g2 "Swirl velocity";
  Modelica.SIunits.HeatFlux[n] q_w "Heat flux from wall";
  Modelica.SIunits.Volume[n] volume "Cylinder volume";
  Modelica.SIunits.Angle[n] theta "Crankshaft angle";
  Modelica.SIunits.Length[n] position "Piston position from cyl. head";
  Real tFactor[n];
  Real tFactor1[n];
  Real tFactor2[n] "Transition factor";
  Real deltaTheta "Transition interval";

equation
  deltaTheta = 0.05*pi "9 degrees crankshaft angle";
  for i in 1:n loop
    theta[i] = mod(crankshaftAngle,2*pi) "Promote input to array";
    omega[i] = der(crankshaftAngle) "Use continuous input for derivative";
    assert(noEvent(omega[i] > 1e-6), "Very low rotational speed, make sure connected the crank angle input properly.", level=  AssertionLevel.warning);
    // Equation 15 from Adair et al.
    omega_g1[i] = 2*omega[i]*(1.04+cos(2*theta[i]));
    omega_g2[i] = 2*omega[i]*1/2*(1.04+cos(2*theta[i]));
    // Removed the switch from the paper and replaced
    // it with a smooth transition.
    // if (3/2*pi<theta[i] or theta[i]<1/2*pi) then
    //   omega_g[i] = omega_g1[i];
    // else
    //   omega_g[i] = omega_g2[i];
    // end if;
    tFactor1[i] = ThermoCycle.Functions.transition_factor(
      start=1/2*pi-0.5*deltaTheta,stop=1/2*pi+0.5*deltaTheta,position=theta[i])
      "Switch from omega_g1 to omega_g2";
    tFactor2[i] = ThermoCycle.Functions.transition_factor(
      start=3/2*pi-0.5*deltaTheta,stop=3/2*pi+0.5*deltaTheta,position=theta[i])
      "Switch back from omega_g2 to omega_g1";
    tFactor[i] = tFactor1[i] + (1-tFactor2[i]);
    omega_g[i] = tFactor[i]*omega_g1[i] + (1 - tFactor[i])*omega_g2[i];

    surfaceAreas[i] = pistonCrossArea + 2 * sqrt(pistonCrossArea*pi)*position[i]
      "Defines position";
    volume[i] = pistonCrossArea * position[i] "Get volumes";
    De[i] = 6 / pistonCrossArea * volume[i];

    Gamma[i]  = De[i];
    Lambda[i] = 0.5 * De[i] * omega_g[i];

  end for;

  annotation(Documentation(info="<html>
<p>Simple heat transfer correlation with two parameters. </p>
<p>You can find the paper describing the correlation here: <a href=\"http://docs.lib.purdue.edu/icec/45/\">http://docs.lib.purdue.edu/icec/45/</a></p>
<p><h4><font color=\"#008000\">IMPLEMENTATION:</font></h4></p>
<p>Implemented in 2012 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk)</p>
</html>"));
end Adair1972;
