within ThermoCycle.Examples.TestComponents;
model flow1D
  parameter Integer N = 10;
  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
    A=2,
    Unom_l=400,
    Unom_v=400,
    N=N,
    V=0.003,
    Mdotnom=0.3,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare package Medium = CoolProp2Modelica.Media.SES36_CP,
    redeclare model Flow1DimHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
    Unom_tp=400,
    pstart=1000000,
    Tstart_inlet=323.15,
    Tstart_outlet=373.15)
    annotation (Placement(transformation(extent={{-40,-4},{-2,34}})));

  ThermoCycle.Components.HeatFlow.Sources.Source_T source_T(N=N)
    annotation (Placement(transformation(extent={{-30,42},{4,64}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
    annotation (Placement(transformation(extent={{-62,64},{-54,72}})));
  Components.FluidFlow.Reservoirs.SourceMdot             sourceMdot1(
    redeclare package Medium = CoolProp2Modelica.Media.SES36_CP,
    Mdot_0=0.3335,
    UseT=false,
    h_0=84867,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-102,6},{-76,32}})));
  Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
      Medium = CoolProp2Modelica.Media.SES36_CP,
    h=254381,
    p0=866735)
    annotation (Placement(transformation(extent={{50,14},{70,34}})));
  Modelica.Blocks.Sources.Sine sine(
    startTime=10,
    offset=0.3335,
    amplitude=0.5,
    phase=0,
    freqHz=0.1)
    annotation (Placement(transformation(extent={{-116,50},{-102,64}})));
  Components.FluidFlow.Sensors.SensTp T_su_Sensor(redeclare package Medium =
        CoolProp2Modelica.Media.SES36_CP)
    annotation (Placement(transformation(extent={{-66,10},{-46,30}})));
  Components.FluidFlow.Sensors.SensTp T_ex_Sensor(redeclare package Medium =
        CoolProp2Modelica.Media.SES36_CP)
    annotation (Placement(transformation(extent={{14,14},{34,34}})));
equation
  connect(source_T.thermalPort, flow1Dim.Wall_int) annotation (Line(
      points={{-13.17,48.49},{-13.17,43.95},{-21,43.95},{-21,22.9167}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-53.6,68},{-13,68},{-13,57.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, sourceMdot1.in_Mdot) annotation (Line(
      points={{-101.3,57},{-98.5,57},{-98.5,26.8},{-96.8,26.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, T_ex_Sensor.InFlow) annotation (Line(
      points={{-5.16667,15.1583},{4,15.1583},{4,19.2},{17,19.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(T_ex_Sensor.OutFlow, sinkP.flangeB) annotation (Line(
      points={{31,19.2},{38,19.2},{38,24},{51.6,24}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-120,-100},{80,
            100}}),     graphics={Text(
          extent={{-62,56},{-26,50}},
          lineColor={0,0,0},
          textString="Thermal port")}),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-120,-100},{80,100}})));
end flow1D;
