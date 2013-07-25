within ThermoCycle.Examples.TestComponents;
model flow1D
  parameter Integer N = 10;
  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
    A=2,
    Unom_l=400,
    Unom_tp=1000,
    Unom_v=400,
    N=N,
    V=0.003,
    Mdotnom=0.3,
    pstart=500000,
    Tstart_inlet=323.15,
    Tstart_outlet=373.15,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal)
    annotation (Placement(transformation(extent={{-32,8},{6,46}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot Source(
    Mdot_0=0.3,
    UseT=false,
    h_0=2E5,
    p=500000,
    T_0=293.15)
    annotation (Placement(transformation(extent={{-84,10},{-50,44}})));
  ThermoCycle.Components.HeatFlow.Sources.Source_T source_T(N=N)
    annotation (Placement(transformation(extent={{-30,42},{4,64}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
    annotation (Placement(transformation(extent={{-62,64},{-54,72}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP Sink(h=0e5)
    annotation (Placement(transformation(extent={{18,14},{46,42}})));
  Modelica.Blocks.Sources.Ramp ramp(
    offset=5E5,
    duration=5,
    startTime=5,
    height=9E5) annotation (Placement(transformation(extent={{10,62},{20,72}})));
equation
  connect(Source.flangeB, flow1Dim.InFlow)     annotation (Line(
      points={{-51.7,27},{-28.8333,27}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_T.thermalPort, flow1Dim.Wall_int) annotation (Line(
      points={{-13.17,48.49},{-13.17,43.95},{-13,43.95},{-13,34.9167}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, Sink.flangeB)  annotation (Line(
      points={{2.83333,27.1583},{12,27.1583},{12,27.72},{20.24,27.72}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, Sink.in_p0)  annotation (Line(
      points={{20.5,67},{26.4,67},{26.4,40.32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-53.6,68},{-13,68},{-13,57.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-62,56},{-26,50}},
          lineColor={0,0,0},
          textString="Thermal port")}),
    experiment(StopTime=50, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end flow1D;
