within ThermoCycle.Examples.TestComponents;
model valve

  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare
      package Medium = ThermoCycle.Media.R245fa_CP,  p0=400000)
    annotation (Placement(transformation(extent={{24,32},{44,52}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=2,
    startTime=1,
    height=4E5,
    offset=4E5)
    annotation (Placement(transformation(extent={{-104,78},{-84,98}})));
  Real y;
  Components.Units.PdropAndValves.Valve valve(
    UseNom=true,
    Mdot_nom=0.5,
    p_nom=400000,
    T_nom=298.15,
    DELTAp_nom=40000)
    annotation (Placement(transformation(extent={{-38,28},{-18,48}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=2,
    height=-1,
    offset=1,
    startTime=10)
    annotation (Placement(transformation(extent={{-38,74},{-18,94}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid1(
                                                               redeclare
      package Medium = ThermoCycle.Media.R245fa_CP,  p0=400000)
    annotation (Placement(transformation(extent={{-66,30},{-86,50}})));
equation
  y = ThermoCycle.Functions.weightingfactor(
        t_init=2,
        length=5,
        t=time)
  annotation (Diagram(graphics), uses(Modelica(version="3.2")));
  connect(valve.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{-19,38},{6,38},{6,42},{25.6,42}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp1.y, valve.cmd) annotation (Line(
      points={{-17,84},{4,84},{4,62},{-28,62},{-28,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinkPFluid1.flangeB, valve.InFlow) annotation (Line(
      points={{-67.6,40},{-52,40},{-52,38},{-37,38}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, sinkPFluid1.in_p0) annotation (Line(
      points={{-83,88},{-72,88},{-72,48.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (    experiment(StopTime=50));
end valve;
