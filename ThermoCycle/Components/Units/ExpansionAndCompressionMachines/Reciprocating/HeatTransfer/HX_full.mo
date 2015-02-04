within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model HX_full "A combination of Cylinder model and a reciprocating machine"
  replaceable package WorkingFluid = ThermoCycle.Media.R601_CP;
  //ThermoCycle.Media.R134a_CP;
  //ThermoCycle.Media.R134aCP;
  //ThermoCycle.Media.AirCP;
  //CoolProp2Modelica.Media.R601_CP;
  //Modelica.Media.Air.DryAirNasa;
  //constrainedby Modelica.Media.Interfaces.PartialMedium;

  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  inner Modelica.Fluid.System system(p_start=2000000, T_start=473.15)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-20,-40},{20,0}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(T(start=system.T_start),
      C=0.5*2500)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-32,0})));

  Cylinder cylinder(
    redeclare package Medium = WorkingFluid,
    use_portsData=false,
    p_start=system.p_start,
    T_start=system.T_start,
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.piston.radius^2)
    annotation (Placement(transformation(extent={{-120,40},{-100,20}})));
  Cylinder annand(
    redeclare package Medium = WorkingFluid,
    use_portsData=false,
    p_start=system.p_start,
    T_start=system.T_start,
    pistonCrossArea=cylinder.pistonCrossArea,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Annand1963,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    use_HeatTransfer=true)
    annotation (Placement(transformation(extent={{-90,40},{-70,20}})));

  Cylinder woschni(
    redeclare package Medium = WorkingFluid,
    use_portsData=false,
    p_start=system.p_start,
    T_start=system.T_start,
    pistonCrossArea=cylinder.pistonCrossArea,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Woschni1967,
    use_HeatTransfer=true)
    annotation (Placement(transformation(extent={{-60,40},{-40,20}})));

  Cylinder adair(
    redeclare package Medium = WorkingFluid,
    use_portsData=false,
    p_start=system.p_start,
    T_start=system.T_start,
    pistonCrossArea=cylinder.pistonCrossArea,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Adair1972)
    annotation (Placement(transformation(extent={{-30,40},{-10,20}})));
  Cylinder destoop(
    redeclare package Medium = WorkingFluid,
    use_portsData=false,
    p_start=system.p_start,
    T_start=system.T_start,
    pistonCrossArea=cylinder.pistonCrossArea,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Destoop1986,
    use_HeatTransfer=true)
    annotation (Placement(transformation(extent={{0,40},{20,20}})));

  Cylinder kornhauser(
    redeclare package Medium = WorkingFluid,
    use_portsData=false,
    p_start=system.p_start,
    T_start=system.T_start,
    pistonCrossArea=cylinder.pistonCrossArea,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Kornhauser1994)
    annotation (Placement(transformation(extent={{30,40},{50,20}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    w(start=10, fixed=true),
    J=2000)
           annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Cylinder irimescu(
    redeclare package Medium = WorkingFluid,
    use_portsData=false,
    p_start=system.p_start,
    T_start=system.T_start,
    pistonCrossArea=cylinder.pistonCrossArea,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Irimescu2013)
    annotation (Placement(transformation(extent={{60,40},{80,20}})));
  Cylinder gnielinski(
    redeclare package Medium = WorkingFluid,
    use_portsData=false,
    p_start=system.p_start,
    T_start=system.T_start,
    pistonCrossArea=cylinder.pistonCrossArea,
    use_HeatTransfer=true,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Gnielinski2010)
    annotation (Placement(transformation(extent={{90,40},{110,20}})));
equation
  connect(recipFlange.crankShaft_a, speed.flange) annotation (Line(
      points={{20,-30},{40,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cylinder.flange, annand.flange) annotation (Line(
      points={{-110,20},{-80,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(annand.flange, woschni.flange) annotation (Line(
      points={{-80,20},{-50,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(woschni.flange, adair.flange) annotation (Line(
      points={{-50,20},{-20,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(adair.flange, destoop.flange) annotation (Line(
      points={{-20,20},{10,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(destoop.flange, kornhauser.flange) annotation (Line(
      points={{10,20},{40,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(annand.heatPort, wall.port) annotation (Line(
      points={{-90,30},{-90,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(woschni.heatPort, wall.port) annotation (Line(
      points={{-60,30},{-60,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(adair.heatPort, wall.port) annotation (Line(
      points={{-30,30},{-30,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(destoop.heatPort, wall.port) annotation (Line(
      points={{0,30},{0,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(kornhauser.heatPort, wall.port) annotation (Line(
      points={{30,30},{30,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(destoop.flange, recipFlange.flange_a) annotation (Line(
      points={{10,20},{10,0},{0,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
      points={{-40,-30},{-20,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(irimescu.heatPort, wall.port) annotation (Line(
      points={{60,30},{60,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(angleSensor.flange, recipFlange.crankShaft_b) annotation (Line(
      points={{-32,-10},{-20,-10},{-20,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(annand.angle_in, angleSensor.phi) annotation (Line(
      points={{-70,30},{-70,11},{-32,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(woschni.angle_in, angleSensor.phi) annotation (Line(
      points={{-40,30},{-40,11},{-32,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(adair.angle_in, angleSensor.phi) annotation (Line(
      points={{-10,30},{-12,30},{-12,11},{-32,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(destoop.angle_in, angleSensor.phi) annotation (Line(
      points={{20,30},{20,11},{-32,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(kornhauser.angle_in, angleSensor.phi) annotation (Line(
      points={{50,30},{50,11},{-32,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(irimescu.angle_in, angleSensor.phi) annotation (Line(
      points={{80,30},{80,11},{-32,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(irimescu.flange, kornhauser.flange) annotation (Line(
      points={{70,20},{40,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(gnielinski.heatPort, wall.port) annotation (Line(
      points={{90,30},{90,60},{0,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gnielinski.angle_in, angleSensor.phi) annotation (Line(
      points={{110,30},{110,11},{-32,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gnielinski.flange, irimescu.flange) annotation (Line(
      points={{100,20},{70,20}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-120,-80},{120,80}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-120,-80},{120,
            80}})));
end HX_full;
