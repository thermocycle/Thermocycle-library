within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestEvaporator.TestGeneral;
model Test_evaWaterUnit
  replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp;
ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Unit.EvaGw  evaG(
    redeclare package Medium = Medium,
    YY=1.57,
    cpw=500,
    Mw=90,
    hstartSC=7.7E5,
    hstartTP=2E6,
    hstartSH=3E6,
    lstartSC=50,
    lstartTP=200,
    lstartSH=250,
    h_pf_out=3E6,
    SteadyStatePF=true,
    pstart=6000000,
    Mdotnom=0.5,
    TstartWall={513.15,513.15,673.15},
    Tstartsf=1273.15,
    DTstartsf=323.15)
    annotation (Placement(transformation(extent={{-24,-32},{26,18}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(Mdot_0=5, T_0=1273.15)
    annotation (Placement(transformation(extent={{-8,58},{12,78}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.5,
    T_0=349.15)
    annotation (Placement(transformation(extent={{-76,-46},{-56,-26}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       6000000)
    annotation (Placement(transformation(extent={{76,-46},{96,-26}})));
equation
  connect(sourceCdot.flange, evaG.InFlowSF) annotation (Line(
      points={{10.2,67.9},{46,67.9},{46,10.8571},{26.5556,10.8571}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, evaG.InFlowPF) annotation (Line(
      points={{-57,-36},{-42,-36},{-42,-26.2857},{-26.2222,-26.2857}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaG.OutFlowPF, sinkP.flangeB) annotation (Line(
      points={{26.5556,-27},{42,-27},{42,-36},{77.6,-36}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Test_evaWaterUnit;
