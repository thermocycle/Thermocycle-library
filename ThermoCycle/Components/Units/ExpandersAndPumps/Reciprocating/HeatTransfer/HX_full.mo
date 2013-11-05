within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer;
model HX_full "A combination of Cylinder model and a reciprocating machine"
  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    J=200,
    w(
      start=10.471975511966,
      fixed=true,
      displayUnit="rpm"))
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  inner Modelica.Fluid.System system(p_start=40*system.p_ambient, T_start=1273.15)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
  Cylinder cylinder(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    p_start=system.p_start,
    T_start=system.T_start,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    use_portsData=false)
    annotation (Placement(transformation(extent={{-80,40},{-60,20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(C=0.5*250, T(
        start=773.15))
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Cylinder annand1963(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    p_start=system.p_start,
    T_start=system.T_start,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    use_portsData=false,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Annand1963,

    use_angle_in=true,
    stroke=recipFlange.stroke)
    annotation (Placement(transformation(extent={{-50,40},{-30,20}})));
  Cylinder woschni1967(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    p_start=system.p_start,
    T_start=system.T_start,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    use_portsData=false,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Woschni1967)
    annotation (Placement(transformation(extent={{-20,40},{0,20}})));
  Cylinder adair1972(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    p_start=system.p_start,
    T_start=system.T_start,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    use_portsData=false,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Adair1972)
    annotation (Placement(transformation(extent={{10,40},{30,20}})));
  Cylinder destoop1986(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    p_start=system.p_start,
    T_start=system.T_start,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    use_portsData=false,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Destoop1986)
    annotation (Placement(transformation(extent={{40,40},{60,20}})));
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
      points={{-30,30},{-30,50},{70,50},{70,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(annand1963.heatPort, wall.port) annotation (Line(
      points={{-50,30},{-50,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cylinder.flange, recipFlange.flange_a) annotation (Line(
      points={{-70,20},{-70,10},{0,10},{0,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(annand1963.flange, recipFlange.flange_a) annotation (Line(
      points={{-40,20},{-40,10},{0,10},{0,-1.11022e-15},{-1.11022e-15,
          -1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(woschni1967.flange, recipFlange.flange_a) annotation (Line(
      points={{-10,20},{-10,10},{0,10},{0,0},{-1.11022e-15,-1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(woschni1967.heatPort, wall.port) annotation (Line(
      points={{-20,30},{-20,60},{5.55112e-16,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(woschni1967.angle_in, angleSensor.phi) annotation (Line(
      points={{0,30},{0,50},{70,50},{70,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(adair1972.heatPort, wall.port) annotation (Line(
      points={{10,30},{10,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(adair1972.angle_in, angleSensor.phi) annotation (Line(
      points={{30,30},{32,30},{32,50},{70,50},{70,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(adair1972.flange, recipFlange.flange_a) annotation (Line(
      points={{20,20},{20,10},{0,10},{0,0},{-1.11022e-15,-1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(destoop1986.heatPort, wall.port) annotation (Line(
      points={{40,30},{40,60},{5.55112e-16,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(destoop1986.angle_in, angleSensor.phi) annotation (Line(
      points={{60,30},{60,50},{70,50},{70,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(destoop1986.flange, recipFlange.flange_a) annotation (Line(
      points={{50,20},{50,10},{0,10},{0,0},{-1.11022e-15,-1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-80,-80},
            {80,80}})));
end HX_full;
