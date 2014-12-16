within ThermoCycle.Examples.TestComponents;
model Test_BoilerSystem
  Components.Units.HeatExchangers.BoilerSystem boilerSystem(
    Mdot_w_nom=2.9,
    pinch_start=25,
    DELTAT_approach=1,
    x_ex_ev_nom=0.307,
    p_start=3635000,
    T_w_su_start=380.27,
    T_w_ex_start=627,
    T_w_su_SH2_start=593.5,
    T_sf_su_start=653.15)
    annotation (Placement(transformation(extent={{-12,-28},{48,36}})));
  Queralt.Components.Valve_lin valve_water_vs_sh2(
    redeclare package Medium = ThermoCycle.Media.Water,
    UseNom=true,
    CheckValve=true,
    Xopen=0,
    Mdot_nom=0.25,
    DELTAp_nom=50000) annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={65,27})));
  Queralt.Components.Valve_lin valve_feed_water(
    redeclare package Medium = ThermoCycle.Media.Water,
    UseNom=true,
    Xopen=1,
    Mdot_nom=2.8429767731178850E+000,
    CheckValve=true,
    DELTAp_nom=50000) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={32,-36})));
  Queralt.Components.Valve_lin valve_solar(
    UseNom=true,
    Xopen=1,
    CheckValve=true,
    Mdot_nom=25,
    redeclare package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.FlueGas,
    DELTAp_nom=10000)
    annotation (Placement(transformation(extent={{-28,76},{-12,92}})));
  Queralt.Components.FlangeConverter flangeConverter(redeclare package Medium
      = ThermoCycle.Media.Incompressible.IncompressibleTables.FlueGas)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={4,64})));
  Queralt.Components.SinkP_pT sinkP1(redeclare package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.FlueGas, p0=
        2000000)
    annotation (Placement(transformation(extent={{-34,-44},{-48,-30}})));
  Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    redeclare package Medium = ThermoCycle.Media.Water,
    Mdot_0=2.8429767731178850E+000,
    T_0=333.15)
    annotation (Placement(transformation(extent={{74,-50},{94,-30}})));
  Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package Medium =
        ThermoCycle.Media.Water, p0=3430000)
    annotation (Placement(transformation(extent={{58,68},{78,88}})));
  Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
    Mdot_0=25,
    redeclare package Medium = Queralt.FlueGas,
    T_0=673.15)
    annotation (Placement(transformation(extent={{-70,76},{-50,96}})));
equation
  connect(boilerSystem.flangeA1, valve_water_vs_sh2.OutFlow) annotation (Line(
      points={{40.5,20.32},{49.25,20.32},{49.25,27},{58.7,27}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve_water_vs_sh2.InFlow, boilerSystem.flangeA) annotation (Line(
      points={{71.3,27},{82,27},{82,-25.12},{35.7,-25.12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(boilerSystem.flangeA, valve_feed_water.OutFlow) annotation (Line(
      points={{35.7,-25.12},{35.7,-24},{32,-24},{32,-28.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve_solar.OutFlow,flangeConverter. flange_ph) annotation (Line(
      points={{-12.8,84},{3.9,84},{3.9,69.1}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(flangeConverter.flange_pT, boilerSystem.inlet_sf) annotation (Line(
      points={{3.9,59.1},{3.9,47.55},{3,47.55},{3,34.72}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sinkP1.flangeB, boilerSystem.outlet_sf) annotation (Line(
      points={{-35.12,-37},{3,-37},{3,-26.4}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(sinkP.flangeB, boilerSystem.flangeB) annotation (Line(
      points={{59.6,78},{36,78},{36,74},{24.3,74},{24.3,34.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, valve_feed_water.InFlow) annotation (Line(
      points={{93,-40},{94,-40},{94,-66},{32,-66},{32,-43.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, valve_solar.InFlow) annotation (Line(
      points={{-51,86},{-36,86},{-36,84},{-27.2,84}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_BoilerSystem;
