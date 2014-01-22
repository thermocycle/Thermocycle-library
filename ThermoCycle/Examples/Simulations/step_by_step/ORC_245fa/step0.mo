within ThermoCycle.Examples.Simulations.step_by_step.ORC_245fa;
model step0
parameter Integer N=10;
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare
      package Medium = ThermoCycle.Media.R245fa_CP,  p0=2357000)
    annotation (Placement(transformation(extent={{82,-10},{102,10}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=0.2588,
    h_0=281455,
    UseT=true,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p=2357000,
    T_0=353.15)
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
 ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim    flow1Dim(
    A=16.18,
    V=0.03781,
    Mdotnom=0.25,
    steadystate=false,
    Mdotconst=true,
    Unom_l=300,
    Unom_tp=700,
    Unom_v=400,
    N=12,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    pstart=2500000,
    Tstart_inlet=323.15,
    Tstart_outlet=323.15)
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{72,56},{52,76}})));
ThermoCycle.Components.FluidFlow.Pipes.Flow1DConst SecondaryFluid(
    A=16.18,
    V=0.03781,
    steadystate=true,
    Mdotnom=1,
    N=12,
    Unom=100,
    Tstart_inlet=473.15,
    Tstart_outlet=373.15)
    annotation (Placement(transformation(extent={{10,90},{-20,58}})));
 ThermoCycle.Components.HeatFlow.Walls.MetalWall metalWall(
    M_wall=10,
    c_wall=500,
    steadystate_T_wall=true,
    N=12,
    Aext=16,
    Aint=16,
    Tstart_wall_1=423.15,
    Tstart_wall_end=443.15)
    annotation (Placement(transformation(extent={{-28,10},{22,42}})));
equation
  connect(sourceWF.flangeB, flow1Dim.InFlow) annotation (Line(
      points={{-73,0},{-14.3333,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{2.33333,0.0833333},{44,0.0833333},{44,0},{83.6,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_Cdot.flange, SecondaryFluid.flange_Cdot) annotation (Line(
      points={{53.8,65.9},{34.9,65.9},{34.9,74},{10,74}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(SecondaryFluid.Wall_int, metalWall.Wall_int) annotation (Line(
      points={{-5,66},{-3,66},{-3,30.8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(metalWall.Wall_ext, flow1Dim.Wall_int) annotation (Line(
      points={{-3.5,21.2},{-3.5,12.6},{-6,12.6},{-6,4.16667}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end step0;
