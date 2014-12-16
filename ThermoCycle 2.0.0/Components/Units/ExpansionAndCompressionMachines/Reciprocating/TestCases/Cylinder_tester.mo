within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.TestCases;
model Cylinder_tester
  "A combination of Cylinder model and a reciprocating machine"

  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    J=2,
    w(start=10.471975511966,
      fixed=true,
      displayUnit="rpm"))
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  inner Modelica.Fluid.System system(p_start=40*system.p_ambient, T_start=
        1273.15)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
  Cylinder cylinder(
    p_start=system.p_start,
    T_start=system.T_start,
    use_portsData=false,
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.piston.radius^2,
    use_HeatTransfer=false,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{-10,40},{10,20}})));

equation
  connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
      points={{-40,-30},{-20,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, speed.flange) annotation (Line(
      points={{20,-30},{40,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
      points={{6.10623e-16,20},{-1.04854e-15,20},{-1.04854e-15,-1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-80,-80},
            {80,80}})));
end Cylinder_tester;
