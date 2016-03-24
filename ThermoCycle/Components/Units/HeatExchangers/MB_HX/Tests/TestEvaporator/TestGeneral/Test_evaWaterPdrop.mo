within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestEvaporator.TestGeneral;
model Test_evaWaterPdrop
replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp;
 ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Unit.EvaGw
                                                                                    evaG(
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
    TstartWall={513.15,513.15,673.15},
    Tstartsf=1273.15,
    DTstartsf=323.15)
    annotation (Placement(transformation(extent={{-24,-36},{26,14}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(Mdot_0=5, T_0=1273.15)
    annotation (Placement(transformation(extent={{-8,58},{12,78}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.5,
    T_0=349.15)
    annotation (Placement(transformation(extent={{-76,-46},{-56,-26}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(
                                                          redeclare package
      Medium =                                                                      Medium, p0=5800000)
    annotation (Placement(transformation(extent={{98,-32},{118,-12}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(redeclare package
      Medium =                                                                                Medium,Afull=0.000167529)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Modelica.Blocks.Sources.Constant Cmd_nom1(
                                           k=1)
    annotation (Placement(transformation(extent={{50,2},{66,12}},rotation=
           0)));
equation
  connect(sourceCdot.flange, evaG.InFlowSF) annotation (Line(
      points={{10.2,67.9},{46,67.9},{46,6.85714},{26.5556,6.85714}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, evaG.InFlowPF) annotation (Line(
      points={{-57,-36},{-42,-36},{-42,-30.2857},{-26.2222,-30.2857}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Cmd_nom1.y, valve.cmd) annotation (Line(
      points={{66.8,7},{70,7},{70,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaG.OutFlowPF, valve.InFlow) annotation (Line(
      points={{26.5556,-31},{50,-31},{50,-20},{61,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP1.flangeB) annotation (Line(
      points={{79,-20},{90,-20},{90,-22},{99.6,-22}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Test_evaWaterPdrop;
