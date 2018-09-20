within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestEvaporator.TestIncompressible;
model TestEvaSES36UnitInc
replaceable package Medium =
     ThermoCycle.Media.SES36_CP;

ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Incompressible.Unit.EvaGwInc evaGw(
    redeclare package Medium = Medium,
    Ltotal=66.6,
    AA=0.0007,
    cpw=500,
    Mw=69,
    epsNTU_sf=true,
    Mdotnom=0.3061,
    Unomsf=1000,
    hstartSC=2,
    hstartTP=50,
    hstartSH=14.6,
    lstartSC=8E4,
    lstartTP=2E5,
    lstartSH=256022,
    SteadyStatePF=true,
    UnomSC=3000,
    UnomTP=8700,
    UnomSH=3000,
    YY=0.243,
    VoidFraction=true,
    pstart=810927,
    TstartWall={393.15,393.15,393.15},
    Tstartsf=398.15,
    DTstartsf=278.15)
    annotation (Placement(transformation(extent={{-30,-32},{22,26}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{-32,62},{-12,82}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    T_0=293.27)
    annotation (Placement(transformation(extent={{-82,-64},{-62,-44}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       810927)
    annotation (Placement(transformation(extent={{72,-64},{92,-44}})));
equation
  connect(sourceCdot.flange, evaGw.InFlowSF) annotation (Line(
      points={{-13.8,71.9},{52,71.9},{52,14},{22,14},{22,16.8857},{22.5778,
          16.8857}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, evaGw.InFlowPF) annotation (Line(
      points={{-63,-54},{-50,-54},{-50,-23.7143},{-29.4222,-23.7143}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaGw.OutFlowPF, sinkP.flangeB) annotation (Line(
      points={{22.5778,-24.5429},{40,-24.5429},{40,-54},{73.6,-54}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end TestEvaSES36UnitInc;
