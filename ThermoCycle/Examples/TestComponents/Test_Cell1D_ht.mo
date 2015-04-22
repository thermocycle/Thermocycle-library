within ThermoCycle.Examples.TestComponents;
model Test_Cell1D_ht

  Components.FluidFlow.Pipes.Cell1Dim
         flow1Dim(
    Ai=0.2,
    Unom_l=400,
    Unom_tp=1000,
    Unom_v=400,
    max_drhodt=50,
    Vi=0.005,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    Mdotnom=0.3335,
    hstart=84867,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind,
    pstart=866735,
    redeclare model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence)
    annotation (Placement(transformation(extent={{-28,10},{-8,30}})));

  ThermoCycle.Components.HeatFlow.Sources.Source_T_cell source_T
    annotation (Placement(transformation(extent={{-32,50},{-12,70}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
    annotation (Placement(transformation(extent={{-66,72},{-46,92}})));
  Components.FluidFlow.Reservoirs.SourceMdot             sourceMdot1(
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    UseT=false,
    h_0=84867,
    Mdot_0=0.3334,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-84,10},{-64,30}})));
  Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
      Medium = ThermoCycle.Media.R407c_CP,
    h=254381,
    p0=866735)
    annotation (Placement(transformation(extent={{46,12},{66,32}})));
  Modelica.Blocks.Sources.Step step(
    height=-0.1334,
    offset=0.3334,
    startTime=10)
    annotation (Placement(transformation(extent={{-106,42},{-86,62}})));
equation
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-45,82},{-21,82},{-21,65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flow1Dim.Wall_int, source_T.ThermalPortCell) annotation (Line(
      points={{-18,25},{-18,56.9},{-21.1,56.9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-65,20},{-28,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{-8,20.1},{16,20.1},{16,22},{47.6,22}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(step.y, sourceMdot1.in_Mdot) annotation (Line(
      points={{-85,52},{-80,52},{-80,26}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end Test_Cell1D_ht;
