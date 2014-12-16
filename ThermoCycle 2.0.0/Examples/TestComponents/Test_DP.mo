within ThermoCycle.Examples.TestComponents;
model Test_DP

ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=-0.5,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p=400000,
    T_0=298.15)
    annotation (Placement(transformation(extent={{-84,30},{-64,50}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare
      package Medium = ThermoCycle.Media.R245fa_CP, p0=400000)
    annotation (Placement(transformation(extent={{24,32},{44,52}})));
  ThermoCycle.Components.Units.PdropAndValves.DP dP(
    h=3,
    UseHomotopy=true,
    A=4e-5,
    constinit=true,
    Mdot_nom=0.5,
    UseNom=true,
    t_init=0.5,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
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
  Components.FluidFlow.Sensors.SensTpSat sensTp(redeclare package Medium =
        ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{-56,36},{-36,56}})));
  Components.FluidFlow.Sensors.SensTpSat sensTp1(redeclare package Medium =
        ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{-4,36},{16,56}})));
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
  connect(sourceWF.flangeB, sensTp.InFlow) annotation (Line(
      points={{-65,40},{-60,40},{-60,41.2},{-53,41.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.OutFlow, dP.InFlow) annotation (Line(
      points={{-39,41.2},{-32,41.2},{-32,42},{-29,42}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dP.OutFlow, sensTp1.InFlow) annotation (Line(
      points={{-11,42},{-6,42},{-6,41.2},{-1,41.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp1.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{13,41.2},{20,41.2},{20,42},{25.6,42}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end Test_DP;
