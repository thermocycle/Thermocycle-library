within ThermoCycle.Examples.TestComponents;
model Test_Flow1D_MD
  parameter Integer N = 10;
ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim_MD  flow1Dim(
    A=2,
    U_nom = 400,
    N=N,
    V=0.003,
    Mdotnom=0.3,
    redeclare package Medium = ThermoCycle.Media.SES36_CP,
    pstart=1000000,
    Tstart_inlet=323.15,
    Tstart_outlet=373.15)
    annotation (Placement(transformation(extent={{-32,2},{6,40}})));

  Components.FluidFlow.Reservoirs.SourceMdot             sourceMdot1(
    Mdot_0=0.3335,
    UseT=false,
    h_0=84867,
    redeclare package Medium = ThermoCycle.Media.SES36_CP,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-92,6},{-66,32}})));
  Components.FluidFlow.Reservoirs.SinkP             sinkP(
    h=254381,
    redeclare package Medium = ThermoCycle.Media.SES36_CP,
    p0=866735)
    annotation (Placement(transformation(extent={{50,14},{70,34}})));
  Modelica.Blocks.Sources.Sine sine(
    startTime=10,
    offset=0.3335,
    amplitude=0.5,
    phase=0,
    freqHz=0.1)
    annotation (Placement(transformation(extent={{-116,50},{-102,64}})));
  Components.HeatFlow.Sources.Source_T             source_T(N=N)
    annotation (Placement(transformation(extent={{-20,52},{14,74}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
    annotation (Placement(transformation(extent={{-52,74},{-44,82}})));
  Components.FluidFlow.Sensors.SensTpSat T_su_Sensor(redeclare package Medium
      = ThermoCycle.Media.SES36_CP)
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  Components.FluidFlow.Sensors.SensTpSat T_ex_Sensor(redeclare package Medium
      = ThermoCycle.Media.SES36_CP)
    annotation (Placement(transformation(extent={{18,16},{38,36}})));
equation
  connect(sine.y, sourceMdot1.in_Mdot) annotation (Line(
      points={{-101.3,57},{-86.8,57},{-86.8,26.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y,source_T. Temperature) annotation (Line(
      points={{-43.6,78},{-3,78},{-3,67.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(source_T.thermalPort, flow1Dim.Wall_int) annotation (Line(
      points={{-3.17,58.49},{-3.17,48},{-16,48},{-16,28.9167},{-13,28.9167}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, T_su_Sensor.InFlow) annotation (Line(
      points={{-67.3,19},{-59.65,19},{-59.65,12.4},{-49.9,12.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, T_ex_Sensor.InFlow) annotation (Line(
      points={{2.83333,21.1583},{12.4167,21.1583},{12.4167,16.4},{28.1,16.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(T_su_Sensor.InFlow, flow1Dim.InFlow) annotation (Line(
      points={{-49.9,12.4},{-34,12.4},{-34,21},{-28.8333,21}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(T_ex_Sensor.InFlow, sinkP.flangeB) annotation (Line(
      points={{28.1,16.4},{40,16.4},{40,24},{51.6,24}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-52,66},{-16,60}},
          lineColor={0,0,0},
          textString="Thermal port")}),
    experiment(StopTime=125, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end Test_Flow1D_MD;
