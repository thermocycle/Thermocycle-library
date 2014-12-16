within ThermoCycle.Examples.TestComponents;
model Test_MBeva
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    UseT=false,
    h_0=852450,
    Mdot_0=0.05,
    redeclare package Medium = ThermoCycle.Media.Water,
    p=6000000)
    annotation (Placement(transformation(extent={{-84,-54},{-64,-34}})));
  Modelica.Blocks.Sources.Constant Hin(k=852540)
    annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant Pout(k=1e5)
    annotation (Placement(transformation(extent={{110,0},{90,20}}, rotation=
           0)));
 ThermoCycle.Components.Units.HeatExchangers.MBeva MB_eva(
    A=0.0314159,
    L=1,
    M_tot=9.35E+01,
    c_wall=385,
    rho_wall=8.93e3,
    TwSB(start=510.97 + 50, displayUnit="K"),
    TwTP(start=548.79 + 21, displayUnit="K"),
    TwSH(start=585.97 + 35, displayUnit="K"),
    Tsf_SU_start=360 + 273.15,
    U_SB=3000,
    U_TP=10000,
    U_SH=3000,
    L_SB(start=0.2),
    L_TP(start=0.4),
    h_EX(start=3043000),
    Void=0.665,
    dVoid_dp=0,
    dVoid_dh=0,
    Usf=20000,
    ETA=1,
    redeclare package Medium = ThermoCycle.Media.Water,
    p(start=6000000),
    dTsf_start=343.15)
    annotation (Placement(transformation(extent={{-26,-38},{22,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    rho=1000,
    Mdot_0=2,
    cp=2046,
    T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =
        ThermoCycle.Media.Water)
    annotation (Placement(transformation(extent={{76,-34},{96,-14}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(
    UseNom=true,
    redeclare package Medium = ThermoCycle.Media.Water,
    Mdot_nom=0.05,
    p_nom=6000000,
    T_nom=643.15,
    DELTAp_nom=5000000)
    annotation (Placement(transformation(extent={{46,-40},{66,-20}})));
equation
  connect(Hin.y, sourceMdot.in_h) annotation (Line(
      points={{-79,-6},{-68,-6},{-68,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Pout.y, sinkP.in_p0) annotation (Line(
      points={{89,10},{82,10},{82,-15.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceCdot.flange, MB_eva.InFlow_sf) annotation (Line(
      points={{20.2,39.9},{34,39.9},{34,0.4},{22,0.4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, MB_eva.InFlow) annotation (Line(
      points={{-65,-44},{-58,-44},{-58,-40},{-50,-40},{-50,-29.36},{-25.52,
          -29.36}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(MB_eva.OutFlow, valve.InFlow) annotation (Line(
      points={{22,-29.36},{40,-29.36},{40,-30},{47,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP.flangeB) annotation (Line(
      points={{65,-30},{72,-30},{72,-24},{77.6,-24}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,60}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            60}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_MBeva;
