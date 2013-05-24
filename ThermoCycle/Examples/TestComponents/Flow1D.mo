within ThermoCycle.Examples.TestComponents;
model Flow1D
parameter Integer N = 3;
  Components.FluidFlow.Pipes.Flow1Dim HotFluid(redeclare package Medium =
        Media.R245faCool,
    A=16.18,
    V=0.03781,
    Mdotconst=true,
    max_der=true,
    Unom_l=30.21797814,
    Unom_tp=30.21797814,
    Unom_v=30.21797814,
    Mdotnom=0.25877,
    N=N,
    HTtype=ThermoCycle.Functions.Enumerations.HTtypes.LiqVap,
    pstart=2300000,
    Tstart_inlet=402.157968,
    Tstart_outlet=357.76567852,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind)
    annotation (Placement(transformation(extent={{-28,98},{20,46}})));
    //Tstart_inlet=353.82,
    //Tstart_outlet=316.91)
  Components.FluidFlow.Reservoirs.SourceMdot
           sourceWF1(
    Mdot_0=0.25877,
    UseT=false,
    h_0=470523,
    p=2300000)
    annotation (Placement(transformation(extent={{-90,62},{-70,82}})));
  Components.FluidFlow.Reservoirs.SinkP      sinkPFluid1(            h=315945.576, p0=2300000)
    annotation (Placement(transformation(extent={{76,48},{96,68}})));
  Components.HeatFlow.Sources.Source_T source_T(N=N)
    annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
  Modelica.Blocks.Sources.Constant const(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-92,18},{-72,38}})));
equation
  connect(source_T.thermalPort, HotFluid.Wall_int) annotation (Line(
      points={{-44.1,15.9},{-44.1,0},{-4,0},{-4,61.1667}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-71,28},{-44,28},{-44,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceWF1.flangeB, HotFluid.InFlow) annotation (Line(
      points={{-71,72},{-60,72},{-60,76},{-44,76},{-44,72},{-24,72}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(HotFluid.OutFlow, sinkPFluid1.flangeB) annotation (Line(
      points={{16,71.7833},{46,71.7833},{46,57.8},{77.6,57.8}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Flow1D;
