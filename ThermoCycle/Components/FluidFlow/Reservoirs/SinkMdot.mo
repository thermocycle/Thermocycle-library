within ThermoCycle.Components.FluidFlow.Reservoirs;
model SinkMdot "Mass sink for current working fluid"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model";
  parameter Modelica.SIunits.MassFlowRate Mdot_0=0
    "Imposed volumetric flow rate";
  parameter Medium.SpecificEnthalpy h_out=1e5 "Nominal specific enthalpy";
  parameter Medium.AbsolutePressure pstart = 1E6 "Start value for the pressure";
  Modelica.SIunits.MassFlowRate Mdot;

  Interfaces.Fluid.FlangeB flangeB(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
equation

  flangeB.m_flow= Mdot;

  Mdot = Mdot_0;
  flangeB.h_outflow= h_out;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
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
end SinkMdot;
