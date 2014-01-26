within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model Gnielinski2010 "Pipe correlation of Gnielinski 2010"
  extends GnielinskiHeatTransfer;

  parameter Real sigma = 0.14 "Correction exponent";

equation
  for i in 1:n loop
    Gamma[i]    = bore "Characteristic length";
    Lambda[i]   = c_m "Characteristic velocity";
    zeta[i]     = (1.80 * log10(Re[i])-1.50)^(-2);
    xtra[i]     = 0.;
    K[i]        = 1.;//(Medium.temperature(states[i])/heatPorts[i].T)^(sigma);
  end for;

  annotation (Documentation(info="<html>
<p><h4>Reference: </h4></p>
<p>In 2013, Irimescu adapted an older equation by Gnielinski for SI and CI engines. Note that this implementation contains a simplified version using only the piston speed as characteristic velocity whereas the paper by Irimescu proposes a turbulence-based approach for this purpose.</p>
<dl><dt><a name=\"Irimescu2013\">(</a>Irimescu2013)</dt>
<dd>Irimescu, A.</dd>
<dd><i>Convective heat transfer equation for turbulent flow in tubes applied to internal combustion engines operated under motored conditions</i></dd>
<dd>Applied Thermal Engineering, <b>2013</b>, Vol. 50(1), pp. 536-545</dd>
<dl><dt><a name=\"Gnielinski1976\">(</a>Gnielinski1976)</dt>
<dd>Gnielinski, V.</dd>
<dd><i>New Equations For Heat And Mass-transfer In Turbulent Pipe And Channel Flow</i></dd>
<dd>International Chemical Engineering, <b>1976</b>, Vol. 16(2), pp. 359-368</dd>
</dl><p><h4>Implementation: </h4></p>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</html>"));
end Gnielinski2010;
