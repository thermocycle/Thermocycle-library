within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.TestCases;
model Flange_tester "A combination of a flange and a reciprocating machine"

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
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
  Modelica.Mechanics.Translational.Sources.Force force(useSupport=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-20,
    duration=1,
    offset=30,
    startTime=0)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
equation
  connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
      points={{-40,-30},{-20,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, speed.flange) annotation (Line(
      points={{20,-30},{40,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(force.flange, recipFlange.flange_a) annotation (Line(
      points={{-1.22629e-15,20},{-1.04854e-15,20},{-1.04854e-15,
          -1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(ramp.y, force.f) annotation (Line(
      points={{-29,60},{2.87043e-15,60},{2.87043e-15,42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-80,-80},
            {80,80}})));
end Flange_tester;
