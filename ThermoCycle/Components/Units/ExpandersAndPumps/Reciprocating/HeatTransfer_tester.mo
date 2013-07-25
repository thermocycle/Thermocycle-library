within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating;
model HeatTransfer_tester
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
  inner Modelica.Fluid.System system(p_start=40*system.p_ambient, T_start=1273.15)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
  Cylinder cylinder(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    p_start=system.p_start,
    T_start=system.T_start,
    use_HeatTransfer=true,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    use_portsData=false,
    use_angle_in=true,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Adair1972)
    annotation (Placement(transformation(extent={{-10,40},{10,20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(C=0.5*25, T(start=
          773.15))
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
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
  connect(wall.port, cylinder.heatPort)    annotation (Line(
      points={{-30,40},{-30,30},{-10,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
      points={{20,-30},{20,-10},{40,-10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(angleSensor.phi, cylinder.angle_in) annotation (Line(
      points={{61,-10},{70,-10},{70,30},{10,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-80,-80},
            {80,80}})));
end HeatTransfer_tester;
