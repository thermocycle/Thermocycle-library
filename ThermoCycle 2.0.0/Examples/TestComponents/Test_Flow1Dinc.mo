within ThermoCycle.Examples.TestComponents;
model Test_Flow1Dinc
parameter Integer N = 10;
ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc       HotFluid(
    redeclare package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66,
    A=16.18,
    V=0.03781,
    Unom=30.21797814,
    Mdotnom=0.25877,
    N=N,
    steadystate=false,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff,
    pstart=100000,
    Tstart_inlet=418.15,
    Tstart_outlet=408.15)
    annotation (Placement(transformation(extent={{-20,94},{28,42}})));
    //Tstart_inlet=402.157968,
    //Tstart_outlet=357.76567852)
    //Tstart_inlet=353.82,
    //Tstart_outlet=316.91)
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot
           sourceWF1(
    h_0=470523,
    UseT=true,
    redeclare package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66,
    Mdot_0=3.1,
    p=100000,
    T_0=418.15)
    annotation (Placement(transformation(extent={{-90,62},{-70,82}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP      sinkPFluid1(redeclare
      package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66, p0=
        100000)
    annotation (Placement(transformation(extent={{74,50},{94,70}})));
  ThermoCycle.Components.HeatFlow.Sources.Source_T source_T(N=N)
    annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
  Modelica.Blocks.Sources.Constant const(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-92,18},{-72,38}})));
equation
  connect(source_T.thermalPort, HotFluid.Wall_int) annotation (Line(
      points={{-44.1,15.9},{-44.1,0},{4,0},{4,57.1667}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y, source_T.Temperature) annotation (Line(
      points={{-71,28},{-44,28},{-44,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceWF1.flangeB, HotFluid.InFlow) annotation (Line(
      points={{-71,72},{-60,72},{-60,76},{-44,76},{-44,68},{-16,68}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(HotFluid.OutFlow, sinkPFluid1.flangeB) annotation (Line(
      points={{24,67.7833},{40,67.7833},{40,60},{75.6,60}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_Flow1Dinc;
