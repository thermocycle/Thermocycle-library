within ThermoCycle.Components.FluidFlow.Reservoirs;
model Source_pT "Source in pressure and temperature for current working fluid"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Medium.Temperature T=273.15+25 "Temperature of fluid going out";
  parameter Medium.AbsolutePressure p = 1E6 "Start value for the pressure";
  Medium.SpecificEnthalpy h_out "enthalpy of the fluid going out";
  Medium.SpecificEnthalpy h "enthalpy of the fluid coming in";
  Interfaces.Fluid.FlangeB flangeB(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{82,-10},{102,10}}),
        iconTransformation(extent={{82,-10},{102,10}})));
equation
  h= inStream(flangeB.h_outflow);
  p= flangeB.p;
  h_out = Medium.specificEnthalpy_pT(p,T);
  flangeB.h_outflow= h_out;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<HTML>
<p><b>Modelling options</b></p>
<p>If <tt>R</tt> is set to zero, the pressure sink is ideal; otherwise, the inlet pressure increases proportionally to the incoming flowrate.</p>
<p>If the <tt>in_p0</tt> connector is wired, then the source pressure is given by the corresponding signal, otherwise it is fixed to <tt>p0</tt>.</p>
<p>If the <tt>in_h</tt> connector is wired, then the source pressure is given by the corresponding signal, otherwise it is fixed to <tt>h</tt>.</p>
</HTML>",
        revisions="<html>
<ul>
<li><i>16 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Medium model and standard medium definition added.</li>
<li><i>18 Jun 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Removed <tt>p0_fix</tt> and <tt>hfix</tt>; the connection of external signals is now detected automatically.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
</ul>
</html>"),
    conversion(noneFromVersion=""));
end Source_pT;
