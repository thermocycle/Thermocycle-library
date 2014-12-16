within ThermoCycle.Examples.TestComponents;
model Test_Valve

  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare
      package Medium = ThermoCycle.Media.R245fa_CP,  p0=400000)
    annotation (Placement(transformation(extent={{56,-20},{76,0}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=2,
    startTime=1,
    height=4E5,
    offset=4E5)
    annotation (Placement(transformation(extent={{-72,26},{-52,46}})));
  Real y;
  Components.Units.PdropAndValves.Valve valve(
    UseNom=true,
    Mdot_nom=0.5,
    p_nom=400000,
    T_nom=298.15,
    DELTAp_nom=40000)
    annotation (Placement(transformation(extent={{-6,-24},{14,-4}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=2,
    height=-1,
    offset=1,
    startTime=10)
    annotation (Placement(transformation(extent={{-6,22},{14,42}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid1(
                                                               redeclare
      package Medium = ThermoCycle.Media.R245fa_CP,  p0=400000)
    annotation (Placement(transformation(extent={{-34,-22},{-54,-2}})));
equation
  y = ThermoCycle.Functions.weightingfactor(
        t_init=2,
        length=5,
        t=time)
  annotation (Diagram(graphics), uses(Modelica(version="3.2")));
  connect(valve.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{13,-14},{38,-14},{38,-10},{57.6,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp1.y, valve.cmd) annotation (Line(
      points={{15,32},{36,32},{36,10},{4,10},{4,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinkPFluid1.flangeB, valve.InFlow) annotation (Line(
      points={{-35.6,-12},{-20,-12},{-20,-14},{-5,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, sinkPFluid1.in_p0) annotation (Line(
      points={{-51,36},{-40,36},{-40,-3.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,
            -100},{100,80}}),
                      graphics),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-80,-100},{100,80}})));
end Test_Valve;
