within ThermoCycle.Examples.TestComponents;
model Test_BoilerSystem

package FlueGas "Flue Gas Incompressible - TableBased"
  extends Modelica.Media.Incompressible.TableBased(
  mediumName="FlueGas",
  T_min =  Modelica.SIunits.Conversions.from_degC(150),
   T_max =  Modelica.SIunits.Conversions.from_degC(1000),
   TinK = false,
   T0=273.15+200,
   tableDensity=[150,  1/ 1287; 160,  1/ 1318; 170,  1/ 1348; 180,  1/ 1378; 190,  1/ 1409; 200,  1/ 1439; 210,  1/ 1470; 220,  1/ 1500; 230,  1/ 1530; 240,  1/ 1561; 250,  1/ 1591; 260,  1/ 1622; 270,  1/ 1652; 280,  1/ 1683; 290,  1/ 1713; 300,  1/ 1743; 310,  1/ 1774; 320,  1/ 1804; 330,  1/ 1835; 340,  1/ 1865; 350,  1/ 1895; 360,  1/ 1926; 370,  1/ 1956; 380,  1/ 1987; 390,  1/ 2017; 400,  1/ 2048; 410,  1/ 2078; 420,  1/ 2108; 430,  1/ 2139; 440,  1/ 2169; 450,  1/ 2200; 460,  1/ 2230; 470,  1/ 2260; 480,  1/ 2291; 490,  1/ 2321; 500,  1/ 2352; 510,  1/ 2382; 520,  1/ 2413; 530,  1/ 2443; 540,  1/ 2473; 550,  1/ 2504; 560,  1/ 2534; 570,  1/ 2565; 580,  1/ 2595; 590,  1/ 2625; 600,  1/ 2656; 610,  1/ 2686; 620,  1/ 2717; 630,  1/ 2747; 640,  1/ 2778; 650,  1/ 2808; 660,  1/ 2838; 670,  1/ 2869; 680,  1/ 2899; 690,  1/ 2930; 700,  1/ 2960; 710,  1/ 2990; 720,  1/ 3021; 730,  1/ 3051; 740,  1/ 3082; 750,  1/ 3112; 760,  1/ 3143; 770,  1/ 3173; 780,  1/ 3203; 790,  1/ 3234; 800,  1/ 3264; 810,  1/ 3295; 820,  1/ 3325; 830,  1/ 3355; 840,  1/ 3386; 850,  1/ 3416; 860,  1/ 3447; 870,  1/ 3477; 880,  1/ 3508; 890,  1/ 3538; 900,  1/ 3568; 910,  1/ 3599; 920,  1/ 3629; 930,  1/ 3660; 940,  1/ 3690; 950,  1/ 3720; 960,  1/ 3751; 970,  1/ 3781; 980,  1/ 3812; 990,  1/ 3842; 1000,  1/ 3873],
   tableHeatCapacity=[150,  1160; 160,  1162; 170,  1165; 180,  1168; 190,  1171; 200,  1173; 210,  1176; 220,  1179; 230,  1182; 240,  1185; 250,  1188; 260,  1191; 270,  1194; 280,  1198; 290,  1201; 300,  1204; 310,  1207; 320,  1210; 330,  1213; 340,  1216; 350,  1220; 360,  1223; 370,  1226; 380,  1229; 390,  1232; 400,  1235; 410,  1239; 420,  1242; 430,  1245; 440,  1248; 450,  1251; 460,  1254; 470,  1258; 480,  1261; 490,  1264; 500,  1267; 510,  1270; 520,  1273; 530,  1276; 540,  1279; 550,  1283; 560,  1286; 570,  1289; 580,  1292; 590,  1295; 600,  1298; 610,  1301; 620,  1304; 630,  1307; 640,  1310; 650,  1313; 660,  1316; 670,  1318; 680,  1321; 690,  1324; 700,  1327; 710,  1330; 720,  1333; 730,  1336; 740,  1338; 750,  1341; 760,  1344; 770,  1347; 780,  1349; 790,  1352; 800,  1355; 810,  1357; 820,  1360; 830,  1363; 840,  1365; 850,  1368; 860,  1370; 870,  1373; 880,  1376; 890,  1378; 900,  1381; 910,  1383; 920,  1385; 930,  1388; 940,  1390; 950,  1393; 960,  1395; 970,  1398; 980,  1400; 990,  1402; 1000,  1405],
   tableConductivity= [150,  0.03265; 160,  0.03335; 170,  0.03405; 180,  0.03474; 190,  0.03543; 200,  0.03612; 210,  0.03681; 220,  0.03749; 230,  0.03817; 240,  0.03885; 250,  0.03953; 260,  0.04021; 270,  0.04088; 280,  0.04155; 290,  0.04223; 300,  0.04289; 310,  0.04356; 320,  0.04423; 330,  0.04489; 340,  0.04555; 350,  0.04621; 360,  0.04687; 370,  0.04753; 380,  0.04819; 390,  0.04884; 400,  0.0495; 410,  0.05015; 420,  0.0508; 430,  0.05146; 440,  0.05211; 450,  0.05276; 460,  0.0534; 470,  0.05405; 480,  0.0547; 490,  0.05535; 500,  0.05599; 510,  0.05664; 520,  0.05729; 530,  0.05793; 540,  0.05858; 550,  0.05922; 560,  0.05987; 570,  0.06051; 580,  0.06116; 590,  0.06181; 600,  0.06245; 610,  0.0631; 620,  0.06374; 630,  0.06439; 640,  0.06504; 650,  0.06569; 660,  0.06633; 670,  0.06698; 680,  0.06763; 690,  0.06828; 700,  0.06894; 710,  0.06959; 720,  0.07024; 730,  0.0709; 740,  0.07155; 750,  0.07221; 760,  0.07287; 770,  0.07353; 780,  0.07419; 790,  0.07485; 800,  0.07552; 810,  0.07618; 820,  0.07685; 830,  0.07752; 840,  0.07819; 850,  0.07887; 860,  0.07954; 870,  0.08022; 880,  0.0809; 890,  0.08158; 900,  0.08226; 910,  0.08295; 920,  0.08364; 930,  0.08433; 940,  0.08502; 950,  0.08572; 960,  0.08642; 970,  0.08712; 980,  0.08782; 990,  0.08853; 1000,  0.08924],
   tableViscosity= [150,  0.00002175; 160,  0.00002215; 170,  0.00002255; 180,  0.00002295; 190,  0.00002334; 200,  0.00002373; 210,  0.00002412; 220,  0.0000245; 230,  0.00002488; 240,  0.00002526; 250,  0.00002563; 260,  0.000026; 270,  0.00002637; 280,  0.00002673; 290,  0.00002709; 300,  0.00002745; 310,  0.0000278; 320,  0.00002815; 330,  0.0000285; 340,  0.00002884; 350,  0.00002919; 360,  0.00002953; 370,  0.00002986; 380,  0.0000302; 390,  0.00003053; 400,  0.00003086; 410,  0.00003118; 420,  0.00003151; 430,  0.00003183; 440,  0.00003215; 450,  0.00003247; 460,  0.00003278; 470,  0.00003309; 480,  0.0000334; 490,  0.00003371; 500,  0.00003402; 510,  0.00003432; 520,  0.00003462; 530,  0.00003492; 540,  0.00003522; 550,  0.00003551; 560,  0.00003581; 570,  0.0000361; 580,  0.00003639; 590,  0.00003667; 600,  0.00003696; 610,  0.00003724; 620,  0.00003753; 630,  0.00003781; 640,  0.00003809; 650,  0.00003837; 660,  0.00003864; 670,  0.00003892; 680,  0.00003919; 690,  0.00003946; 700,  0.00003973; 710,  0.00004; 720,  0.00004027; 730,  0.00004053; 740,  0.0000408; 750,  0.00004106; 760,  0.00004132; 770,  0.00004158; 780,  0.00004184; 790,  0.0000421; 800,  0.00004235; 810,  0.00004261; 820,  0.00004287; 830,  0.00004312; 840,  0.00004337; 850,  0.00004362; 860,  0.00004387; 870,  0.00004412; 880,  0.00004437; 890,  0.00004462; 900,  0.00004486; 910,  0.00004511; 920,  0.00004535; 930,  0.0000456; 940,  0.00004584; 950,  0.00004608; 960,  0.00004632; 970,  0.00004656; 980,  0.0000468; 990,  0.00004704; 1000,  0.00004728],
   tableVaporPressure = fill(0,0,2));
   // Density ---->  [kg/m3]
   // HeatCapacity ----> [J/kg/K]
   // Conuctivity  ----> [W/m/K]
   // Viscosity  ---->    [Pa.s]
   // Vapor pressure ---->  [Pa]

end FlueGas;

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
  Components.Units.PdropAndValves.Valve_lin
                               valve_water_vs_sh2(
    redeclare package Medium = ThermoCycle.Media.Water,
    UseNom=true,
    CheckValve=true,
    Xopen=0,
    Mdot_nom=0.25,
    DELTAp_nom=50000) annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=180,
        origin={65,27})));
  Components.Units.PdropAndValves.Valve_lin
                               valve_feed_water(
    redeclare package Medium = ThermoCycle.Media.Water,
    UseNom=true,
    Xopen=1,
    Mdot_nom=2.8429767731178850E+000,
    CheckValve=true,
    DELTAp_nom=50000) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={32,-36})));
  Components.Units.PdropAndValves.Valve_lin
                               valve_solar(
    UseNom=true,
    Xopen=1,
    CheckValve=true,
    Mdot_nom=25,
    redeclare package Medium =
        FlueGas,
    DELTAp_nom=10000)
    annotation (Placement(transformation(extent={{-28,76},{-12,92}})));
  Interfaces.Fluid.FlangeConverter   flangeConverter(redeclare package Medium
      = FlueGas)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={4,64})));
  Components.FluidFlow.Reservoirs.SinkP_pT
                              sinkP1(redeclare package Medium =
        FlueGas, p0=
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
    redeclare package Medium = FlueGas,
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
