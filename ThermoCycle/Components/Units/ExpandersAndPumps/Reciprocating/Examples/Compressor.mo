within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.Examples;
model Compressor
  "A combination of Cylinder model, a reciprocating machine and check valves"

  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    J=2,
    w(start=10.471975511966,
      fixed=true,
      displayUnit="rpm"))
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  inner Modelica.Fluid.System system(
    p_start(displayUnit="Pa") = ThermoCycle.Media.R134aCP.saturationPressure(
      system.T_start) - 5,
    dp_small(displayUnit="Pa"),
    T_start=268.15)
    annotation (Placement(transformation(extent={{-50,-74},{-30,-54}})));
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-40,-40},{0,0}})));
  Cylinder cylinder(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    use_portsData=false,
    nPorts=2,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer.Kornhauser1994,
    p_start=inlet.p,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    T_start=inlet.T)
    annotation (Placement(transformation(extent={{-30,40},{-10,20}})));

  Modelica.Fluid.Sources.Boundary_pT inlet(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    p=system.p_ambient,
    T=system.T_ambient)
              annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Fluid.Sources.Boundary_pT outlet(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    p=1000000,
    T=473.15)           annotation (Placement(transformation(extent={{40,40},{
            20,60}})));

  Modelica.Fluid.Valves.ValveCompressible suctionValve(
    checkValve=true,
    m_flow_nominal=0.1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    dp_nominal=50000,
    p_nominal=100000)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.Fluid.Valves.ValveCompressible exhaustValve(
    checkValve=true,
    m_flow_nominal=0.1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    dp_nominal=50000,
    p_nominal=1000000)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque motor(w_nominal(
        displayUnit="rpm") = 52.35987755983, tau_nominal=50)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(C=0.5*2500, T(
        start=373.15))
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Constant const(k=0.75)
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));
equation
  connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
      points={{-50,-30},{-40,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
      points={{-20,20},{-20,-1.11022e-15}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
      points={{-1.11022e-15,-30},{10,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inlet.ports[1], suctionValve.port_a)   annotation (Line(
      points={{-60,50},{-50,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(suctionValve.port_b, cylinder.ports[1])   annotation (Line(
      points={{-30,50},{-22,50},{-22,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exhaustValve.port_a, cylinder.ports[2]) annotation (Line(
      points={{-10,50},{-18,50},{-18,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(motor.flange, inertia.flange_a)
                                         annotation (Line(
      points={{-80,-30},{-70,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(angleSensor.phi, cylinder.angle_in) annotation (Line(
      points={{31,-30},{34,-30},{34,30},{-10,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, suctionValve.opening) annotation (Line(
      points={{-59,84},{-40,84},{-40,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, exhaustValve.opening) annotation (Line(
      points={{-59,84},{0,84},{0,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(exhaustValve.port_b, outlet.ports[1]) annotation (Line(
      points={{10,50},{20,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cylinder.heatPort, wall.port) annotation (Line(
      points={{-30,30},{-40,30},{-40,10},{-70,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}})));
end Compressor;
