within ThermoCycle.Examples.TestComponents;
model Solar_SolaFieldSchott

 ThermoCycle.Components.Units.Solar.SolarField_SchottSopo         solarCollectorIncSchott(
    Mdotnom=0.5,
    redeclare model FluidHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Ideal,
    redeclare
      ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Schott_SopoNova.Schott_2008_PTR70_Vacuum
      CollectorGeometry,
    redeclare package Medium1 = ThermoCycle.Media.Water,
    Ns=2,
    Tstart_inlet=298.15,
    Tstart_outlet=373.15,
    pstart=1000000)
    annotation (Placement(transformation(extent={{-34,-28},{8,42}})));

 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(Mdot_0=0.5,
    redeclare package Medium = ThermoCycle.Media.Water,
    p=1000000)
    annotation (Placement(transformation(extent={{-66,-70},{-46,-50}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = ThermoCycle.Media.Water, p0=1000000)
    annotation (Placement(transformation(extent={{22,56},{42,76}})));
  Modelica.Blocks.Sources.Constant const(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-118,-22},{-98,-2}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-118,12},{-98,32}})));
  Modelica.Blocks.Sources.Constant const3(k=0)
    annotation (Placement(transformation(extent={{-98,44},{-78,64}})));
  Modelica.Blocks.Sources.Step step(
    offset=850,
    startTime=100,
    height=0)
    annotation (Placement(transformation(extent={{-110,-54},{-90,-34}})));
equation
  connect(sourceMdot.flangeB, solarCollectorIncSchott.InFlow) annotation (
      Line(
      points={{-47,-60},{-34,-60},{-34,7}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinkP.flangeB, solarCollectorIncSchott.OutFlow) annotation (Line(
      points={{23.6,66},{7.58,66},{7.58,7.7}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(const3.y, solarCollectorIncSchott.v_wind) annotation (Line(
      points={{-77,54},{-56,54},{-56,34},{2.54,34},{2.54,39.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, solarCollectorIncSchott.Theta) annotation (Line(
      points={{-97,22},{-48,22},{-48,39.55},{-7.33,39.55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, solarCollectorIncSchott.Tamb) annotation (Line(
      points={{-97,-12},{-54,-12},{-54,39.55},{-17.83,39.55}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(step.y, solarCollectorIncSchott.DNI) annotation (Line(
      points={{-89,-44},{-56,-44},{-56,39.2},{-27.28,39.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (    experiment(StopTime=1000));
end Solar_SolaFieldSchott;
