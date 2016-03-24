within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.ComparisonSolarField;
model Test_EvaWaterFlow1dim
  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
    N=N,
    Mdotnom=0.5,
    Unom_l=2500,
    Unom_tp=8000,
    Unom_v=2000,
    pstart=6000000,
    redeclare model Flow1DimHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.VaporQualityDependance)
    annotation (Placement(transformation(extent={{-18,-64},{20,-32}})));
  ThermoCycle.Components.HeatFlow.Walls.MetalWall metalWall(
    M_wall=80,
    c_wall=500,
    N=N)
    annotation (Placement(transformation(extent={{-16,-14},{16,16}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.5,
    T_0(displayUnit="K") = 350,
    p=6000000)
    annotation (Placement(transformation(extent={{-74,-62},{-54,-42}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       6000000)
    annotation (Placement(transformation(extent={{78,-62},{98,-42}})));
  MovingBoundaryLibrary.Components.Wall.ReceiverFlow1D receiverFlow1D(N=N)
    annotation (Placement(transformation(extent={{-42,54},{-22,74}})));
  Modelica.Blocks.Sources.CombiTimeTable Irradiance(smoothness=Modelica.Blocks.
        Types.Smoothness.LinearSegments, table=[0.0,1200; 20000,1200; 24000,1100;
        50000,1100; 54000,1000; 80000,1000; 84000,1100; 110000,1100; 130000,1300;
        140000,1300])
    annotation (Placement(transformation(extent={{-90,52},{-70,72}},
        rotation=0)));
equation
  connect(metalWall.Wall_ext, flow1Dim.Wall_int) annotation (Line(
      points={{-0.32,-3.5},{-0.32,-21.75},{1,-21.75},{1,-41.3333}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-55,-52},{-34,-52},{-34,-48},{-14.8333,-48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{16.8333,-47.8667},{50,-47.8667},{50,-52},{79.6,-52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(receiverFlow1D.thermalPort, metalWall.Wall_int) annotation (
      Line(
      points={{-23,64},{0,64},{0,5.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Irradiance.y[1], receiverFlow1D.Irr) annotation (Line(
      points={{-69,62},{-60,62},{-60,64},{-43,64}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end Test_EvaWaterFlow1dim;
