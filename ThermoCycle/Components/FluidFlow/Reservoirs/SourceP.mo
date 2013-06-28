within ThermoCycle.Components.FluidFlow.Reservoirs;
model SourceP "Pressure source for water/steam flows"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Pressure p0=1.01325e5 "Nominal pressure";
  parameter Modelica.SIunits.SpecificEnthalpy h=1e5 "Nominal specific enthalpy";
  Modelica.SIunits.Pressure p "Actual pressure";
  Modelica.Blocks.Interfaces.RealInput in_p0
    annotation (Placement(transformation(
        origin={-40,92},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  Modelica.Blocks.Interfaces.RealInput in_h
    annotation (Placement(transformation(
        origin={40,90},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  Interfaces.Fluid.FlangeB flange( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{84,-10},{104,10}})));
equation
    flange.p = p;
  p = in_p0;
  if cardinality(in_p0)==0 then
    in_p0 = p0 "Pressure set by parameter";
  end if;
  flange.h_outflow =in_h;
  if cardinality(in_h)==0 then
    in_h = h "Enthalpy set by parameter";
  end if;
  annotation (
    Diagram(graphics),
    Icon(graphics={Text(extent={{-106,90},{-52,50}}, textString=
                                                 "p0"), Text(extent={{66,90},
              {98,52}}, textString=
                             "h")}),
    Documentation(info="<HTML>
<p><b>Modelling options</b></p>
<p>If <tt>R</tt> is set to zero, the pressure source is ideal; otherwise, the outlet pressure decreases proportionally to the outgoing flowrate.</p>
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
</html>"));
end SourceP;
