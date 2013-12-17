within ThermoCycle.Examples.TestComponents;
model Cell1D

  Components.FluidFlow.Pipes.Cell1Dim
         flow1Dim(
    Ai=0.2,
    Unom_l=400,
    Unom_tp=1000,
    Unom_v=400,
    max_drhodt=50,
    Vi=0.005,
    redeclare package Medium = CoolProp2Modelica.Media.SES36_CP,
    Mdotnom=0.3335,
    hstart=84867,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind,
    pstart=866735)
    annotation (Placement(transformation(extent={{-24,8},{-4,28}})));
  ThermoCycle.Components.HeatFlow.Sources.Source_T_cell source_T
    annotation (Placement(transformation(extent={{-24,44},{-4,64}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
    annotation (Placement(transformation(extent={{-66,72},{-46,92}})));
  Components.FluidFlow.Reservoirs.SourceMdot             sourceMdot1(
    redeclare package Medium = CoolProp2Modelica.Media.SES36_CP,
    Mdot_0=0.3335,
    UseT=false,
    h_0=84867,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-90,12},{-70,32}})));
  Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
      Medium = CoolProp2Modelica.Media.SES36_CP,
    h=254381,
    p0=866735)
    annotation (Placement(transformation(extent={{40,4},{60,24}})));
equation
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-45,82},{-28,82},{-28,80},{-13,80},{-13,59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flow1Dim.Wall_int, source_T.ThermalPortCell) annotation (Line(
      points={{-14,23},{-14,50.9},{-13.1,50.9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-71,22},{-40,22},{-40,18},{-24,18}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{-4,18.1},{16,18.1},{16,16},{41.6,16},{41.6,14}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end Cell1D;
