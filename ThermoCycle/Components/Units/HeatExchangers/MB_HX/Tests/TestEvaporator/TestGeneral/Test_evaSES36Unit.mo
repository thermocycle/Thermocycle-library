within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestEvaporator.TestGeneral;
model Test_evaSES36Unit
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
 ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Unit.EvaGw
                                                                                    evaG(
    redeclare package Medium = Medium,
    cpw=500,
    Ltotal=66.6,
    AA=0.0007,
    YY=0.243,
    Mw=69,
    counterCurrent=true,
    Mdotnom=0.3061,
    UnomSC=3000,
    UnomTP=8700,
    UnomSH=3000,
    Unomsf=1000,
    hstartSC=8E4,
    hstartTP=2E5,
    hstartSH=256022,
    lstartSC=22.2,
    lstartTP=22.2,
    lstartSH=22.2,
    h_pf_out=256022,
    SteadyStateWall=true,
    SteadyStatePF=true,
    Set_h_pf_out=false,
    epsNTU_sf=true,
    VoidFraction=false,
    pstart=810927,
    TstartWall={393.15,393.15,393.15},
    Tstartsf=398.15,
    DTstartsf=283.15)
    annotation (Placement(transformation(extent={{-24,-36},{26,14}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    T_0=293.27)
    annotation (Placement(transformation(extent={{-88,-42},{-68,-22}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       810927)
    annotation (Placement(transformation(extent={{88,-24},{108,-4}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{-12,42},{8,62}})));
equation
  connect(sourceMdot.flangeB, evaG.InFlowPF) annotation (Line(
      points={{-69,-32},{-36,-32},{-36,-30.2857},{-26.2222,-30.2857}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaG.OutFlowPF, sinkP.flangeB) annotation (Line(
      points={{26.5556,-31},{62,-31},{62,-14},{89.6,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, evaG.InFlowSF) annotation (Line(
      points={{6.2,51.9},{58,51.9},{58,6.85714},{26.5556,6.85714}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Test_evaSES36Unit;
