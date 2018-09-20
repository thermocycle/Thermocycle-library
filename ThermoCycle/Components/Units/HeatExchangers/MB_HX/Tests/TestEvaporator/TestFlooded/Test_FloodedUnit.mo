within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestEvaporator.TestFlooded;
model Test_FloodedUnit
  replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp;

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
                                                                    redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.5,
    p=150000,
    T_0=300.15)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    cp=4000,
    Mdot_0=15,
    T_0=523.15)
             annotation (Placement(transformation(extent={{8,74},{28,94}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(
                                                          redeclare package
      Medium =                                                                       Medium,
    h=1.8E6,
    p0=3000000)
    annotation (Placement(transformation(extent={{70,-20},{90,0}})));
    parameter Integer n=2;
parameter Boolean counterCurrent = true;
ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Unit.EvaFw  evaF(
    redeclare package Medium = Medium,
    YY=1.57,
    cpw=500,
    Mw=90,
    Mdotnom=0.5,
    lstartSC=50,
    hstartTP=1.8E6,
    lstartTP=450,
    pstart=3000000,
    TstartWall={513.15,513.15},
    Tstartsf=523.15,
    DTstartsf=323.15)
    annotation (Placement(transformation(extent={{-16,-16},{24,34}})));
equation

  /* If statement to allow parallel or counter current structure*/
if counterCurrent then
else
end if;

  connect(sourceCdot.flange, evaF.InFlowSF)
    annotation (Line(
      points={{26.2,83.9},{40,83.9},{40,25.4286},{24,25.4286}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot2.flangeB, evaF.InflowPF)
    annotation (Line(
      points={{-61,-20},{-48,-20},{-48,-7.42857},{-15.5556,-7.42857}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(evaF.OutflowPF, sinkP1.flangeB)
    annotation (Line(
      points={{24,-7.42857},{71.6,-7.42857},{71.6,-10}},
      color={0,0,255},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Test_FloodedUnit;
