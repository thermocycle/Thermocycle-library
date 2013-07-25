within ThermoCycle.Examples.TestComponents;
model Pump
ThermoCycle.Components.Units.ExpandersAndPumps.Pump Pump
    annotation (Placement(transformation(extent={{-26,-16},{4,14}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceP sourceP(p0=142000)
    annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(p0=2351000)
    annotation (Placement(transformation(extent={{56,-10},{76,10}})));
  Modelica.Blocks.Sources.Ramp f_pp(
    duration=100,
    offset=30,
    startTime=400,
    height=0)      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-18,58})));
equation
  connect(sourceP.flange, Pump.InFlow) annotation (Line(
      points={{-58.6,0},{-40.2,0},{-40.2,-0.25},{-21.8,-0.25}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Pump.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{-2.6,10.1},{26,10.1},{26,-0.2},{57.6,-0.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(f_pp.y, Pump.flow_in) annotation (Line(
      points={{-18,47},{-18,22},{-17.3,22},{-17.3,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Pump;
