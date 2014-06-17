within ThermoCycle.Components.FluidFlow.Reservoirs;
model SinkMdot "Mass sink for current working fluid"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.MassFlowRate Mdot_0=0
    "Imposed volumetric flow rate";
  parameter Medium.SpecificEnthalpy h_0= 1e5 "Nominal specific enthalpy";
  parameter Medium.AbsolutePressure pstart = 1E6 "Start value for the pressure";
  Modelica.SIunits.MassFlowRate Mdot;
  Modelica.SIunits.SpecificEnthalpy h;
  Interfaces.Fluid.FlangeB flangeB(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
  Modelica.Blocks.Interfaces.RealInput h_in annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,80}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-40,78})));
  Modelica.Blocks.Interfaces.RealInput Mdot_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,80})));
equation
  Mdot = Mdot_in;
  flangeB.m_flow= Mdot;
  if cardinality(Mdot_in) == 0 then
  Mdot = Mdot_0;
  end if;

  h = h_in;
  if cardinality(h_in) == 0 then
  h = h_0;
  end if;
  flangeB.h_outflow= h;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={Text(
          extent={{-84,92},{-42,54}},
          lineColor={0,0,255},
          textString="h"), Text(
          extent={{102,86},{48,60}},
          lineColor={0,0,255},
          textString="Mdot")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<HTML>
<p><big> Model <b>SinkMdot</b> sets the boundary mass flow of the fluid flowing from the port to the model (i.e. into the model).


 


</html>"),
    conversion(noneFromVersion=""));
end SinkMdot;
