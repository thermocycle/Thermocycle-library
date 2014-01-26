within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model Adair1972 "Recip compressor correlation of Adair 1972"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.RePrHeatTransfer(
    final a=0.053,
    final b=0.800,
    final c=0.600);

   parameter Boolean inletTDC = true
    "admission at TDC (expander) or BDC (compressor)";

  import Modelica.Constants.pi;
  Modelica.SIunits.Length[n]          De "Equivalent diameter 6V/A";
  Modelica.SIunits.AngularVelocity[n] omega_g "Swirl velocity";
  Modelica.SIunits.Volume[n]          volume "Cylinder volume";
  Real tFactor[n];
  Real tFactor1[n];
  Real tFactor2[n] "Transition factor";
  Real deltaTheta "Transition interval";

protected
  Real thetaCorr;

algorithm
  if inletTDC then
    thetaCorr := 0;
  else
    thetaCorr := pi;
  end if;

equation
  deltaTheta = 0.05*pi "9 degrees crankshaft angle";
  for i in 1:n loop
    // Equation 15 from Adair et al.
    //omega_g1[i] = 2*omega[i]*(1.04+cos(2*theta[i]));
    //omega_g2[i] = 2*omega[i]*1/2*(1.04+cos(2*theta[i]));
    // Removed the switch from the paper and replaced
    // it with a smooth transition.
    //if (3/2*pi<theta[i] or theta[i]<1/2*pi) then
    //  omega_g[i] = omega_g1[i];
    //else
    //  omega_g[i] = omega_g2[i];
    //end if;
    tFactor1[i] = ThermoCycle.Functions.transition_factor(
       start=1/2*pi-0.5*deltaTheta,stop=1/2*pi+0.5*deltaTheta,position=theta)
      "Switch from omega_g1 to omega_g2";
    tFactor2[i] = ThermoCycle.Functions.transition_factor(
       start=3/2*pi-0.5*deltaTheta,stop=3/2*pi+0.5*deltaTheta,position=theta)
      "Switch back from omega_g2 to omega_g1";
    tFactor[i] = tFactor1[i] - tFactor2[i];
    omega_g[i] = (1-(tFactor[i]*0.5))*2*omega_c/2/pi*(1.04+cos(2*theta));
    volume[i] = pistonCrossArea * position[i] "Get volumes";
    De[i] = 6 / pistonCrossArea * volume[i];

    Gamma[i]  = De[i];
    Lambda[i] = 0.5 * De[i] * omega_g[i];

  end for;

  annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Adair1972\">(Adair1972)</a></dt>
<dd>Adair, R.P., Qvale, E.B. &amp; Pearson, J.T.</dd>
<dd><i>Instantaneous Heat Transfer to the Cylinder Wall in Reciprocating Compressors</i></dd>
<dd>Proceedings of the International Compressor Engineering Conference</dd>
<dd><b>1972</b>(Paper 86), pp. 521-526</dd>
</dl>
<p>You can find the paper describing the correlation here: <a href=\"http://docs.lib.purdue.edu/icec/45/\">http://docs.lib.purdue.edu/icec/45</a></p>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>

"));
end Adair1972;
