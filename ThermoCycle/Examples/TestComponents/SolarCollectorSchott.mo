within ThermoCycle.Examples.TestComponents;
model SolarCollectorSchott

  ThermoCycle.Components.Units.Solar.SolarCollectorIncSchott    solarCollectorIncSchott(
    L=20,
    A_P=5,
    Mdotnom=0.5,
    Unom=1,
    redeclare model FluidHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Ideal,
    Tstart_inlet=298.15,
    Tstart_outlet=373.15,
    pstart=100000)
    annotation (Placement(transformation(extent={{-34,-28},{8,42}})));

 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(Mdot_0=0.5, redeclare
      package Medium =
        ThermoCycle.Media.Therminol66)
    annotation (Placement(transformation(extent={{-66,-70},{-46,-50}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =
        ThermoCycle.Media.Therminol66)
    annotation (Placement(transformation(extent={{22,56},{42,76}})));
  Modelica.Blocks.Sources.Constant const(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-98,-10},{-78,10}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-98,16},{-78,36}})));
  Modelica.Blocks.Sources.Constant const3(k=0)
    annotation (Placement(transformation(extent={{-98,44},{-78,64}})));
  Modelica.Blocks.Sources.Step step(
    height=-850,
    offset=850,
    startTime=100)
    annotation (Placement(transformation(extent={{-98,-40},{-78,-20}})));
equation
  connect(sourceMdot.flangeB, solarCollectorIncSchott.InFlow) annotation (
      Line(
      points={{-47,-60},{-13,-60},{-13,-28}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinkP.flangeB, solarCollectorIncSchott.OutFlow) annotation (Line(
      points={{23.6,66},{-13,66},{-13,42.7}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(const3.y, solarCollectorIncSchott.v_wind) annotation (Line(
      points={{-77,54},{-56,54},{-56,34},{-31.2,34},{-31.2,35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, solarCollectorIncSchott.Theta) annotation (Line(
      points={{-77,26},{-48,26},{-48,17.5},{-31.2,17.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, solarCollectorIncSchott.Tamb) annotation (Line(
      points={{-77,0},{-54,0},{-54,0.7},{-31.2,0.7}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(step.y, solarCollectorIncSchott.DNI) annotation (Line(
      points={{-77,-30},{-56,-30},{-56,-18.9},{-31.2,-18.9}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end SolarCollectorSchott;
