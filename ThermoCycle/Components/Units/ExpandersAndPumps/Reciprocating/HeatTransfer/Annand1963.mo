within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer;
model Annand1963 "Recip ICE correlation of Annand 1963"
  extends
    ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.RePrHeatTransfer(
     final a = 0.575, final b = 0.700, final c = 0.000);

  import Modelica.Constants.pi;
  Modelica.SIunits.Velocity[n]        c_m "Piston speed";
  Modelica.SIunits.Angle[n]           theta "Crankshaft angle";
  Modelica.SIunits.AngularVelocity[n] omega "Angular crank velocity";
  Modelica.SIunits.Length             bore;

equation
  pistonCrossArea = pi*bore*bore/4 "Defines bore";
  for i in 1:n loop
    theta[i] = mod(crankshaftAngle,2*pi) "Promote input to array";
    omega[i] = der(crankshaftAngle) "Use continuous input for derivative";
    assert(noEvent(omega[i] > 1e-6), "Very low rotational speed, make sure connected the crank angle input properly.", level=  AssertionLevel.warning);
    assert(noEvent(strokeLength > 1e-6), "Very short stroke length, make sure you set the parameter in your cylinder model.", level=  AssertionLevel.warning);

    c_m[i] = omega[i]/2/pi*strokeLength;

    Lambda[i] = c_m[i];
    Gamma[i]  = bore;

  end for;

  annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Annand1963\">(Annand1963)</a></dt>
<dd>Annand, W.</dd>
<dd><i>Heat transfer in cylinders of reciprocating internal combustion engines</i></dd>
<dd>Proceedings of the Institution of Mechanical Engineers, <b>1963</b>, Vol. 177(36), pp. 973-996</dd>
</dl>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>
"));
end Annand1963;
