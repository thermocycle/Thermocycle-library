within ThermoCycle.Examples.TestComponents;
model Test_Flow1D_smoothed
  parameter Integer N = 11;
  replaceable package Medium = ThermoCycle.Media.R134a_CP
  constrainedby Modelica.Media.Interfaces.PartialMedium;
  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
    N=N,
    redeclare package Medium = Medium,
    Mdotnom=0.2,
    A=0.25,
    V=0.002,
    Unom_tp=3000,
    filter_dMdt=true,
    max_der=true,
    Unom_l=1500,
    Unom_v=1500,
    pstart=500000,
    Tstart_inlet=218.15,
    Tstart_outlet=328.15,
    redeclare model Flow1DimHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  Components.FluidFlow.Reservoirs.SourceMdot             sourceMdot1(
    redeclare package Medium = Medium,
    UseT=false,
    h_0=1.3e5,
    Mdot_0=0.15,
    p=500000,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
      Medium = Medium,
    h=254381,
    p0=500000)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Components.FluidFlow.Sources.SourceMdot2 sourceMdot2_1
    annotation (Placement(transformation(extent={{-98,12},{-78,32}})));
  Interfaces.HeatTransfer.HeatPortConverter heatPortConverter annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,76})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(
    alpha=50,
    Q_flow=50000,
    T_ref=403.15)
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Components.HeatFlow.Walls.MetalWall metalWall(
    N=N,
    Aext=1.5*flow1Dim.A,
    Aint=flow1Dim.A,
    M_wall=1,
    c_wall=500,
    Tstart_wall_1=fixedHeatFlow.T_ref,
    Tstart_wall_end=fixedHeatFlow.T_ref,
    steadystate_T_wall=false)
    annotation (Placement(transformation(extent={{-20,48},{20,8}})));
  Interfaces.HeatTransfer.ThermalPortMultiplier thermalPortMultiplier(N=N)
    annotation (Placement(transformation(extent={{-10,60},{10,40}})));
equation
  connect(sourceMdot1.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-61,0},{-16.6667,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{16.6667,0.166667},{18,0.166667},{18,0},{61.6,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot2_1.y, sourceMdot1.in_Mdot) annotation (Line(
      points={{-79,23},{-76,23},{-76,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, heatPortConverter.heatPort) annotation (Line(
      points={{-40,80},{-20,80},{-20,86},{1.83697e-015,86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(metalWall.Wall_int, flow1Dim.Wall_int) annotation (Line(
      points={{0,22},{0,8.33333}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatPortConverter.thermalPortL, thermalPortMultiplier.single)
    annotation (Line(
      points={{-1.83697e-015,66},{-1.83697e-015,60.05},{0,60.05},{0,54.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalPortMultiplier.multi, metalWall.Wall_ext) annotation (Line(
      points={{0,46.5},{0,34},{-0.4,34}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(
      StopTime=500,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end Test_Flow1D_smoothed;
