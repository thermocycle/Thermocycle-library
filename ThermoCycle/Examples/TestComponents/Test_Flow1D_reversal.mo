within ThermoCycle.Examples.TestComponents;
model Test_Flow1D_reversal
  parameter Integer N = 10;
  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
    A=2,
    Unom_l=400,
    Unom_tp=1000,
    Unom_v=400,
    N=N,
    V=0.003,
    Mdotnom=0.3,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_smooth,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    pstart=500000,
    Tstart_inlet=323.15,
    Tstart_outlet=373.15)
    annotation (Placement(transformation(extent={{-22,16},{-2,36}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    Mdot_0=0.3,
    UseT=false,
    h_0=2E5,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p=500000,
    T_0=293.15)
    annotation (Placement(transformation(extent={{-80,16},{-60,36}})));
  ThermoCycle.Components.HeatFlow.Sources.Source_T source_T(N=N)
    annotation (Placement(transformation(extent={{-24,48},{-4,68}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
    annotation (Placement(transformation(extent={{-66,72},{-46,92}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(h=4e5, redeclare
      package Medium = ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{34,16},{54,36}})));
  Modelica.Blocks.Sources.Ramp ramp(
    offset=5E5,
    duration=5,
    startTime=5,
    height=8E5) annotation (Placement(transformation(extent={{14,56},{34,76}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=5,
    startTime=5,
    offset=0.3,
    height=-0.6)
                annotation (Placement(transformation(extent={{-112,44},{-92,64}})));
equation
  connect(sourceMdot.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-61,26},{-20.3333,26}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_T.thermalPort, flow1Dim.Wall_int) annotation (Line(
      points={{-14.1,53.9},{-14.1,43.95},{-12,43.95},{-12,30.1667}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-45,82},{-28,82},{-28,80},{-14,80},{-14,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{-3.66667,26.0833},{12,26.0833},{12,26},{35.6,26}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, sinkP.in_p0) annotation (Line(
      points={{35,66},{40,66},{40,34.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, sourceMdot.in_Mdot) annotation (Line(
      points={{-91,54},{-76,54},{-76,32}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=50, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end Test_Flow1D_reversal;
