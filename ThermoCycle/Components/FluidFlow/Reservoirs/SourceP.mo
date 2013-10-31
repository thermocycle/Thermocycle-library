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


</html>"));
end SourceP;
