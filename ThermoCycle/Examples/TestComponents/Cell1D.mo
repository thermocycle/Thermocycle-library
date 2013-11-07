within ThermoCycle.Examples.TestComponents;
model Cell1D
  Components.FluidFlow.Pipes.Cell1Dim
         flow1Dim(
    Ai=0.2,
    Unom_l=400,
    Unom_tp=1000,
    Unom_v=400,
    Mdotnom=0.3,
    max_drhodt=50,
    Vi=0.005,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_smooth,
    redeclare package Medium = ThermoCycle.Media.R245faCool,
    pstart=500000)
    annotation (Placement(transformation(extent={{-24,8},{-4,28}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot  sourceMdot(
    Mdot_0=0.3,
    UseT=false,
    h_0=2.8E5,
    redeclare package Medium = ThermoCycle.Media.R245faCool,
    p=500000,
    T_0=323.15)
    annotation (Placement(transformation(extent={{-80,16},{-60,36}})));
  ThermoCycle.Components.HeatFlow.Sources.Source_T_cell source_T
    annotation (Placement(transformation(extent={{-24,44},{-4,64}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
    annotation (Placement(transformation(extent={{-66,72},{-46,92}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(h=2E5, redeclare
      package Medium = ThermoCycle.Media.R245faCool)
    annotation (Placement(transformation(extent={{34,16},{54,36}})));
  Modelica.Blocks.Sources.Ramp ramp(
    offset=5E5,
    startTime=5,
    duration=3,
    height=+3E5)
                annotation (Placement(transformation(extent={{14,56},{34,76}})));
equation
  connect(sourceMdot.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-61,26},{-42,26},{-42,18},{-24,18}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-45,82},{-28,82},{-28,80},{-13,80},{-13,59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{-4,18.1},{12,18.1},{12,26},{35.6,26}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, sinkP.in_p0) annotation (Line(
      points={{35,66},{40,66},{40,34.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flow1Dim.Wall_int, source_T.ThermalPortCell) annotation (Line(
      points={{-14,23},{-14,50.9},{-13.1,50.9}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=50, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end Cell1D;
