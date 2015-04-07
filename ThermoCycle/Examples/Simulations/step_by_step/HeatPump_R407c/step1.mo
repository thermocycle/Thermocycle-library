within ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c;
model step1

  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
    Mdotnom=0.044,
    redeclare model Flow1DimHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    A=4,
    V=0.002,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    pstart=1650000,
    Tstart_inlet=345.15,
    Tstart_outlet=305.15)
    annotation (Placement(transformation(extent={{18,6},{-18,42}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    Mdot_0=0.044,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    p=1600000,
    T_0=345.15)
    annotation (Placement(transformation(extent={{68,14},{48,34}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = ThermoCycle.Media.R407c_CP,
                                        p0=1650000)
    annotation (Placement(transformation(extent={{-54,14},{-74,34}})));
  ThermoCycle.Components.HeatFlow.Sources.Source_T source_T(N=10)
    annotation (Placement(transformation(extent={{-10,52},{10,72}})));
  Modelica.Blocks.Sources.Constant const(k=280)
    annotation (Placement(transformation(extent={{-52,72},{-36,88}})));
equation
  connect(sourceMdot.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{49,24},{15,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
      points={{-15,24.15},{-35.5,24.15},{-35.5,24},{-55.6,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_T.thermalPort, flow1Dim.Wall_int) annotation (Line(
      points={{-0.1,57.9},{-0.1,52.95},{0,52.95},{0,31.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-35.2,80},{0,80},{0,66}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),      graphics));
end step1;
