within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.Sizing;
model SizingvalveWater_TC
  import Components;
  replaceable package Medium =
     ExternalMedia.Examples.WaterCoolProp;

 parameter Real kk( start = 1, fixed = false) = 1;

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceP sourceP(redeclare package
      Medium = Medium,
    p0=6000000,
    T_0=648.15)
    annotation (Placement(transformation(extent={{-70,-2},{-50,18}})));
  Modelica.Blocks.Sources.Constant Cmd_nom(k=1)
    annotation (Placement(transformation(extent={{-26,40},{-10,50}},
                                                                 rotation=
           0)));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = Medium, p0=5800000)
    annotation (Placement(transformation(extent={{36,30},{56,50}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(redeclare package
      Medium = Medium,Mdot_nom=0.5, Afull=kk)
    annotation (Placement(transformation(extent={{-8,-2},{12,18}})));

Modelica.SIunits.MassFlowRate m_dot =  valve.Mdot;

initial equation
  m_dot = 0.5;

equation
  connect(sourceP.flange, valve.InFlow) annotation (Line(
      points={{-50.6,8},{-7,8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Cmd_nom.y, valve.cmd) annotation (Line(
      points={{-9.2,45},{2,45},{2,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP.flangeB) annotation (Line(
      points={{11,8},{22,8},{22,40},{37.6,40}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics));
end SizingvalveWater_TC;
