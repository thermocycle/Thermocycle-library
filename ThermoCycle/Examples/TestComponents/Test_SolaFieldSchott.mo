within ThermoCycle.Examples.TestComponents;
model Test_SolaFieldSchott

 ThermoCycle.Components.Units.Solar.SolarField_SchottSopo         solarCollectorIncSchott(
    Mdotnom=0.5,
    redeclare model FluidHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Ideal,
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
    p=1000000,
    T_0=353.15)
    annotation (Placement(transformation(extent={{-66,-70},{-46,-50}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = ThermoCycle.Media.Water, p0=1000000)
    annotation (Placement(transformation(extent={{22,56},{42,76}})));
  Modelica.Blocks.Sources.Constant const(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-94,-8},{-74,12}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-94,18},{-74,38}})));
  Modelica.Blocks.Sources.Constant const3(k=0)
    annotation (Placement(transformation(extent={{-92,48},{-72,68}})));
  Modelica.Blocks.Sources.Step step(
    startTime=100,
    height=0,
    offset=0)
    annotation (Placement(transformation(extent={{-94,-40},{-74,-20}})));
equation
  connect(sourceMdot.flangeB, solarCollectorIncSchott.InFlow) annotation (
      Line(
      points={{-47,-60},{-6,-60},{-6,-28.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinkP.flangeB, solarCollectorIncSchott.OutFlow) annotation (Line(
      points={{23.6,66},{-6,66},{-6,41.3636}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(const3.y, solarCollectorIncSchott.v_wind) annotation (Line(
      points={{-71,58},{-56,58},{-56,34},{-30.7333,34},{-30.7333,35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, solarCollectorIncSchott.Theta) annotation (Line(
      points={{-73,28},{-48,28},{-48,21.3182},{-30.5,21.3182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, solarCollectorIncSchott.Tamb) annotation (Line(
      points={{-73,2},{-54,2},{-54,6.04545},{-30.9667,6.04545}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(step.y, solarCollectorIncSchott.DNI) annotation (Line(
      points={{-73,-30},{-56,-30},{-56,-12.4091},{-30.5,-12.4091}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-80},{60,100}}),
                      graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-80},{60,100}})));
end Test_SolaFieldSchott;
