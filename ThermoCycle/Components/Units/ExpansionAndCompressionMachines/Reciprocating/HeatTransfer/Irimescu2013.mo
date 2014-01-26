within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model Irimescu2013 "Recip ICE correlation of Irimescu 2013"
  extends GnielinskiHeatTransfer;

  import Modelica.Constants.pi;
  Medium.ThermodynamicState[n] states_w "Thermodynamic states at wall";
  Modelica.SIunits.DynamicViscosity[n] eta_w "At wall temperature";

equation
  for i in 1:n loop
    states_w[i] = Medium.setState_pTX(Medium.pressure(states[i]),heatPorts[i].T,{1});//,states[i].X);
    //assert(false, "Concentration is neglected heat transfer model Irimescu2013", AssertionLevel.warning);

    eta_w[i]    = Medium.dynamicViscosity(states_w[i]);
    assert(eta_w[i] > 0, "Invalid viscosity, make sure transport properties are calculated.");

    Gamma[i]    = bore "Characteristic length";
    Lambda[i]   = c_c "Characteristic velocity";
    zeta[i]     = (1.82 * log10(Re[i])-1.64)^(-2);
    xtra[i]     = 1000.;
    K[i]        = (eta[i]/eta_w[i])^(0.14);
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
end Irimescu2013;
