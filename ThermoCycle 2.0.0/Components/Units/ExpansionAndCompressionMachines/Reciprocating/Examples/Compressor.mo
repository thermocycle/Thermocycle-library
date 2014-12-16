within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.Examples;
model Compressor
  "A combination of Cylinder model, a reciprocating machine and check valves"
  replaceable package WorkingFluid = ExternalMedia.Media.CoolPropMedium(substanceNames={"R134a|calc_transport=1"},mediumName="R134a",ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph) constrainedby
    Modelica.Media.Interfaces.PartialMedium;

  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    J=2,
    w(start=104.71975511966,
      fixed=true,
      displayUnit="rpm"))
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  inner Modelica.Fluid.System system(
    p_start(displayUnit="Pa") = WorkingFluid.saturationPressure(
      system.T_start) - 5,
    dp_small(displayUnit="Pa"),
    T_start=373.15)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-20,-80},{20,-40}})));
  Cylinder cylinder(
    nPorts=2,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    use_HeatTransfer=true,
    p_start=inlet.p,
    redeclare package Medium = WorkingFluid,
    T_start=system.T_start - 1,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Adair1972,
    use_portsData=true,
    d_inlet=recipFlange.geometry.d_inlet,
    d_outlet=recipFlange.geometry.d_outlet,
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.piston.radius^2)
    annotation (Placement(transformation(extent={{-10,-10},{10,-30}})));

  Modelica.Fluid.Sources.Boundary_pT inlet(
    nPorts=1,
    redeclare package Medium = WorkingFluid,
    p=125000,
    T=333.15) annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Fluid.Sources.Boundary_pT outlet(
    nPorts=1,
    redeclare package Medium = WorkingFluid,
    p=1000000,
    T=473.15)           annotation (Placement(transformation(extent={{70,-10},{50,
            10}})));

  Modelica.Fluid.Valves.ValveCompressible suctionValve(
    m_flow_nominal=0.1,
    filteredOpening=true,
    leakageOpening=1e-7,
    redeclare package Medium = WorkingFluid,
    riseTime(displayUnit="ms") = 1e-05,
    dp_nominal=50000,
    p_nominal=100000)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Fluid.Valves.ValveCompressible exhaustValve(
    m_flow_nominal=0.1,
    filteredOpening=true,
    riseTime=suctionValve.riseTime,
    leakageOpening=suctionValve.leakageOpening,
    redeclare package Medium = WorkingFluid,
    dp_nominal=50000,
    p_nominal=1000000)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(C=0.5*2500, T(start=
          system.T_start, fixed=true))
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Nonlinear.Limiter limitIn(uMin=0, uMax=1) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,30})));
  Modelica.Fluid.Sensors.RelativePressure dpInlet(redeclare package Medium =
        WorkingFluid)
    annotation (Placement(transformation(extent={{-30,80},{-10,100}})));
  Modelica.Blocks.Nonlinear.Limiter limitOut(uMin=0, uMax=1) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,30})));
  Modelica.Fluid.Sensors.RelativePressure dpOutlet(redeclare package Medium =
        WorkingFluid)
    annotation (Placement(transformation(extent={{10,80},{30,100}})));
  Modelica.Blocks.Math.Gain gainIn(k=0.01) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,60})));
  Modelica.Blocks.Math.Gain gainOut(k=0.01) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,60})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorque(
      tau_constant=50)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
      points={{-30,-70},{-20,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
      points={{0,-30},{0,-40}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
      points={{20,-70},{30,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inlet.ports[1], suctionValve.port_a)   annotation (Line(
      points={{-50,0},{-30,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(suctionValve.port_b, cylinder.ports[1])   annotation (Line(
      points={{-10,0},{0,0},{0,-10},{-2,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exhaustValve.port_a, cylinder.ports[2]) annotation (Line(
      points={{10,0},{0,0},{0,-10},{2,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(angleSensor.phi, cylinder.angle_in) annotation (Line(
      points={{51,-70},{54,-70},{54,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cylinder.heatPort, wall.port) annotation (Line(
      points={{-10,-20},{-20,-20},{-20,-40},{-50,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dpInlet.port_a, suctionValve.port_a) annotation (Line(
      points={{-30,90},{-40,90},{-40,0},{-30,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpInlet.port_b, suctionValve.port_b) annotation (Line(
      points={{-10,90},{0,90},{0,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpInlet.port_b, dpOutlet.port_a) annotation (Line(
      points={{-10,90},{10,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exhaustValve.port_b, dpOutlet.port_b) annotation (Line(
      points={{30,0},{40,0},{40,90},{30,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exhaustValve.port_b, outlet.ports[1]) annotation (Line(
      points={{30,0},{50,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpInlet.p_rel, gainIn.u) annotation (Line(
      points={{-20,81},{-20,76.5},{-20,72},{-20,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gainIn.y, limitIn.u) annotation (Line(
      points={{-20,49},{-20,47.25},{-20,47.25},{-20,45.5},{-20,42},{-20,
          42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpOutlet.p_rel, gainOut.u) annotation (Line(
      points={{20,81},{20,76.5},{20,72},{20,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gainOut.y, limitOut.u) annotation (Line(
      points={{20,49},{20,47.25},{20,47.25},{20,45.5},{20,42},{20,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(constantTorque.flange, inertia.flange_a) annotation (Line(
      points={{-60,-70},{-50,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(limitIn.y, suctionValve.opening) annotation (Line(
      points={{-20,19},{-20,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limitOut.y, exhaustValve.opening) annotation (Line(
      points={{20,19},{20,8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}})));
end Compressor;
