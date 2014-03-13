within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.TestCases;
model Fs_tester "Test model for Fs connectors"

  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    J=2,
    w(start=10.471975511966,
      fixed=true,
      displayUnit="rpm"))
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  RecipMachine_Fs recipFs(redeclare StrokeBoreGeometry
      geometry)
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-20,
    duration=1,
    offset=30,
    startTime=0)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(inertia.flange_b, recipFs.crankShaft_b) annotation (Line(
      points={{-40,-30},{-20,-30}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(recipFs.crankShaft_a, speed.flange) annotation (Line(
      points={{20,-30},{40,-30}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(ramp.y, recipFs.forces) annotation (Line(
      points={{-39,10},{-26,10},{-26,-6.66667},{-11.1111,-6.66667}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-80,-80},
            {80,80}})));
end Fs_tester;
