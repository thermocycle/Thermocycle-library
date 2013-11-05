within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer;
model HX_full "A combination of Cylinder model and a reciprocating machine"
  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    J=200,
    w(start=10.471975511966,
      fixed=true,
      displayUnit="rpm"))
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  inner Modelica.Fluid.System system(p_start=15*system.p_ambient, T_start=
        473.15)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
  Cylinder cylinder(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    p_start=system.p_start,
    T_start=system.T_start,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    use_portsData=false,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.IdealHeatTransfer)
    annotation (Placement(transformation(extent={{-100,40},{-80,20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(T(start=system.T_start),
      C=0.5*2500)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Cylinder annand1963(
    p_start=system.p_start,
    T_start=system.T_start,
    use_portsData=false,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Annand1963,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    pistonCrossArea=cylinder.pistonCrossArea,
    redeclare package Medium = CoolProp2Modelica.Media.R601_CP)
    annotation (Placement(transformation(extent={{-70,40},{-50,20}})));

  Cylinder woschni1967(
    p_start=system.p_start,
    T_start=system.T_start,
    use_portsData=false,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Woschni1967,
    pistonCrossArea=cylinder.pistonCrossArea,
    redeclare package Medium = CoolProp2Modelica.Media.R601_CP)
    annotation (Placement(transformation(extent={{-40,40},{-20,20}})));

  Cylinder adair1972(
    p_start=system.p_start,
    T_start=system.T_start,
    use_portsData=false,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Adair1972,
    pistonCrossArea=cylinder.pistonCrossArea,
    redeclare package Medium = CoolProp2Modelica.Media.R601_CP)
    annotation (Placement(transformation(extent={{-10,40},{10,20}})));

  Cylinder destoop1986(
    p_start=system.p_start,
    T_start=system.T_start,
    use_portsData=false,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Destoop1986,
    pistonCrossArea=cylinder.pistonCrossArea,
    redeclare package Medium = CoolProp2Modelica.Media.R601_CP)
    annotation (Placement(transformation(extent={{20,40},{40,20}})));

  Cylinder kornhauser1994(
    p_start=system.p_start,
    T_start=system.T_start,
    use_portsData=false,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Kornhauser1994,
    pistonCrossArea=cylinder.pistonCrossArea,
    redeclare package Medium = CoolProp2Modelica.Media.R601_CP)
    annotation (Placement(transformation(extent={{50,40},{70,20}})));

equation
  connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
      points={{-40,-30},{-20,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, speed.flange) annotation (Line(
      points={{20,-30},{40,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
      points={{20,-30},{20,-10},{40,-10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(annand1963.angle_in, angleSensor.phi) annotation (Line(
      points={{-50,30},{-50,50},{90,50},{90,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(annand1963.heatPort, wall.port) annotation (Line(
      points={{-70,30},{-70,60},{4.44089e-16,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cylinder.flange, recipFlange.flange_a) annotation (Line(
      points={{-90,20},{-90,10},{0,10},{0,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(annand1963.flange, recipFlange.flange_a) annotation (Line(
      points={{-60,20},{-60,10},{0,10},{0,-1.11022e-15},{-1.11022e-15,
          -1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(woschni1967.flange, recipFlange.flange_a) annotation (Line(
      points={{-30,20},{-30,10},{0,10},{0,-1.11022e-15},{-1.11022e-15,
          -1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(woschni1967.heatPort, wall.port) annotation (Line(
      points={{-40,30},{-40,60},{4.44089e-16,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(woschni1967.angle_in, angleSensor.phi) annotation (Line(
      points={{-20,30},{-20,50},{90,50},{90,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(adair1972.heatPort, wall.port) annotation (Line(
      points={{-10,30},{-10,60},{4.44089e-16,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(adair1972.angle_in, angleSensor.phi) annotation (Line(
      points={{10,30},{10,50},{90,50},{90,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(adair1972.flange, recipFlange.flange_a) annotation (Line(
      points={{6.66134e-16,20},{6.66134e-16,10},{0,10},{0,-1.11022e-15},{
          -1.11022e-15,-1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(destoop1986.heatPort, wall.port) annotation (Line(
      points={{20,30},{20,60},{4.44089e-16,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(destoop1986.angle_in, angleSensor.phi) annotation (Line(
      points={{40,30},{40,50},{90,50},{90,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(destoop1986.flange, recipFlange.flange_a) annotation (Line(
      points={{30,20},{30,10},{0,10},{0,-1.11022e-15},{-1.11022e-15,
          -1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(kornhauser1994.heatPort, wall.port) annotation (Line(
      points={{50,30},{50,60},{5.55112e-16,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(kornhauser1994.angle_in, angleSensor.phi) annotation (Line(
      points={{70,30},{70,50},{90,50},{90,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(recipFlange.flange_a, kornhauser1994.flange) annotation (Line(
      points={{0,0},{0,10},{60,10},{60,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(cylinder.heatPort, wall.port) annotation (Line(
      points={{-100,30},{-100,60},{5.55112e-16,60}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-80},{100,80}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-80},{100,
            80}})));
end HX_full;
