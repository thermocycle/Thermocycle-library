within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.Examples;
model Expander
  "A combination of Cylinder model and a reciprocating machine and valves"

  Modelica.Mechanics.Rotational.Components.Inertia inertia(
    phi(fixed=true, start=0),
    J=2,
    w(start=10.471975511966,
      fixed=true,
      displayUnit="rpm"))
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  inner Modelica.Fluid.System system(p_start=(inlet.p + outlet.p)/2, T_start=(
        inlet.T + outlet.T)/2)
    annotation (Placement(transformation(extent={{-50,-74},{-30,-54}})));
  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-40,-40},{0,0}})));
  Cylinder cylinder(
    nPorts=3,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Adair1972,
    use_angle_in=true,
    redeclare package Medium = Modelica.Media.Water.WaterIF97_ph,
    d_inlet=recipFlange.geometry.d_inlet,
    d_outlet=recipFlange.geometry.d_outlet,
    p_start=inlet.p,
    T_start=inlet.T,
    use_portsData=true,
    d_leak=recipFlange.geometry.d_leak,
    zeta_inout=recipFlange.geometry.zeta_inout,
    zeta_leak=0.5*recipFlange.geometry.zeta_leak,
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.piston.radius^2)
    annotation (Placement(transformation(extent={{-30,40},{-10,20}})));

  Modelica.Fluid.Sources.Boundary_pT inlet(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.WaterIF97_pT,
    p=2000000,
    T=573.15) annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Fluid.Sources.Boundary_pT outlet(
    nPorts=2,
    p=system.p_ambient,
    T=system.T_ambient,
    redeclare package Medium = Modelica.Media.Water.WaterIF97_pT)
    annotation (Placement(transformation(extent={{60,40},{40,60}})));
  Modelica.Fluid.Valves.ValveCompressible injectionValve(
    m_flow_nominal=1,
    redeclare package Medium = Modelica.Media.Water.WaterIF97_ph,
    dp_nominal=100000,
    p_nominal=2000000)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.Fluid.Valves.ValveCompressible exhaustValve(
    m_flow_nominal=1,
    redeclare package Medium = Modelica.Media.Water.WaterIF97_ph,
    dp_nominal=20000,
    p_nominal=100000)
    annotation (Placement(transformation(extent={{-10,66},{10,86}})));
  ValveTimer exhaustTimer(
    input_in_rad=true,
    open=3.0543261909901,
    close=3.6651914291881,
    switch=0.17453292519943)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  ValveTimer injectionTimer(
    input_in_rad=true,
    open=-0.087266462599716,
    close=0.34906585039887,
    switch=0.17453292519943)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque load(
      tau_nominal=-20, w_nominal(displayUnit="rpm") = 52.35987755983)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(C=500*25, T(start=
         773.15))
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice leakageOrifice(
    redeclare package Medium = Modelica.Media.Water.WaterIF97_ph,
    diameter=cylinder.d_leak,
    allowFlowReversal=true,
    zeta=cylinder.zeta_leak)
    annotation (Placement(transformation(extent={{-10,38},{10,58}})));
equation
  connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
      points={{-50,-30},{-40,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
      points={{-20,20},{-20,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
      points={{0,-30},{10,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(angleSensor.phi, exhaustTimer.angle_in) annotation (Line(
      points={{31,-30},{34,-30},{34,-10},{38,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angleSensor.phi, injectionTimer.angle_in) annotation (Line(
      points={{31,-30},{34,-30},{34,-50},{38,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(exhaustTimer.y, exhaustValve.opening) annotation (Line(
      points={{61,-10},{70,-10},{70,90},{0,90},{0,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(injectionTimer.y, injectionValve.opening) annotation (Line(
      points={{61,-50},{80,-50},{80,100},{-40,100},{-40,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inlet.ports[1], injectionValve.port_a) annotation (Line(
      points={{-60,50},{-50,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(injectionValve.port_b, cylinder.ports[1]) annotation (Line(
      points={{-30,50},{-22.6667,50},{-22.6667,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exhaustValve.port_a, cylinder.ports[2]) annotation (Line(
      points={{-10,76},{-20,76},{-20,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exhaustValve.port_b, outlet.ports[1]) annotation (Line(
      points={{10,76},{26,76},{26,52},{40,52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(load.flange, inertia.flange_a) annotation (Line(
      points={{-80,-30},{-70,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(angleSensor.phi, cylinder.angle_in) annotation (Line(
      points={{31,-30},{34,-30},{34,30},{-10,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cylinder.heatPort, wall.port) annotation (Line(
      points={{-30,30},{-40,30},{-40,0},{-70,0},{-70,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cylinder.ports[3], leakageOrifice.port_a) annotation (Line(
      points={{-17.3333,40},{-12,40},{-12,48},{-10,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(leakageOrifice.port_b, outlet.ports[2]) annotation (Line(
      points={{10,48},{40,48}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}})));
end Expander;
