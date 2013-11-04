within ThermoCycle.Examples.TestComponents;
model DP
ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=-0.5,
    p=400000,
    T_0=298.15)
    annotation (Placement(transformation(extent={{-84,30},{-64,50}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(p0=400000)
    annotation (Placement(transformation(extent={{24,32},{44,52}})));
  ThermoCycle.Components.Units.PdropAndValves.DP dP(
    h=3,
    UseHomotopy=true,
    A=4e-5,
    constinit=true,
    Mdot_nom=0.5,
    UseNom=true,
    t_init=0.5,
    p_nom=400000,
    T_nom=298.15,
    DELTAp_stat_nom=40000,
    DELTAp_lin_nom=5000,
    DELTAp_quad_nom=60000)
    annotation (Placement(transformation(extent={{-30,32},{-10,52}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=2,
    startTime=1,
    offset=0.5)
    annotation (Placement(transformation(extent={{-104,78},{-84,98}})));
  Real y;
equation
  connect(ramp.y, sourceWF.in_Mdot) annotation (Line(
      points={{-83,88},{-60,88},{-60,58},{-80,58},{-80,46}},
      color={0,0,127},
      smooth=Smooth.None));
  y = ThermoCycle.Functions.weightingfactor(
        t_init=2,
        length=5,
        t=time)
  annotation (Diagram(graphics), uses(Modelica(version="3.2")));
  connect(sourceWF.flangeB, dP.InFlow) annotation (Line(
      points={{-65,40},{-58,40},{-58,38},{-50,38},{-50,42},{-29,42}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dP.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{-11,42},{0,42},{0,36},{14,36},{14,42},{25.6,42}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end DP;
