within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.TestCases;
model PV_tester "Test model"

  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    J=2,
    w(start=10.471975511966,
      fixed=true,
      displayUnit="rpm"))
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.RecipMachine_PV
    recipPV(redeclare StrokeBoreGeometry geometry, pressure(start=
          closedVolume.p_start))
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  ClosedVolume closedVolume
    annotation (Placement(transformation(extent={{-10,16},{10,40}})));
equation
  connect(inertia.flange_b, recipPV.crankShaft_b)             annotation (Line(
      points={{-40,-30},{-20,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(recipPV.crankShaft_a, speed.flange) annotation (Line(
      points={{20,-30},{40,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(closedVolume.pressure, recipPV.pressure) annotation (Line(
      points={{-11.25,28},{-20,28},{-20,-6.66667},{-11.1111,-6.66667}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(recipPV.volume, closedVolume.volume) annotation (Line(
      points={{12.2222,-6.66667},{20,-6.66667},{20,28},{12.5,28}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}}),
                      graphics), Icon(coordinateSystem(extent={{-80,-80},
            {80,80}})),
    experiment(StopTime=15));
end PV_tester;
