within ThermoCycle.Examples.TestComponents;
model Test_Cell1D

  Components.FluidFlow.Pipes.Cell1Dim
         flow1Dim(
    Ai=0.2,
    Unom_l=400,
    Unom_tp=1000,
    Unom_v=400,
    max_drhodt=50,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    Mdotnom=0.3335,
    hstart=84867,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind,
    redeclare model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence,
    Vi=0.038,
    pstart=866735)
    annotation (Placement(transformation(extent={{-16,10},{4,30}})));

  Components.FluidFlow.Reservoirs.SourceMdot SourceMdot(
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    h_0=84867,
    Mdot_0=0.3334,
    UseT=true,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
      Medium = ThermoCycle.Media.R407c_CP,
    h=254381,
    p0=866735)
    annotation (Placement(transformation(extent={{22,10},{42,30}})));
  Modelica.Blocks.Sources.Step StepBlock(
    startTime=10,
    height=-15,
    offset=83.11 + 273.15)
    annotation (Placement(transformation(extent={{-76,40},{-60,56}})));
equation
  connect(SourceMdot.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-41,20},{-16,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{4,20.1},{25,20.1},{25,20},{23.6,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(StepBlock.y, SourceMdot.in_T) annotation (Line(
      points={{-59.2,48},{-50.2,48},{-50.2,26}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},{60,
            80}}),      graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-20},{60,80}})));
end Test_Cell1D;
