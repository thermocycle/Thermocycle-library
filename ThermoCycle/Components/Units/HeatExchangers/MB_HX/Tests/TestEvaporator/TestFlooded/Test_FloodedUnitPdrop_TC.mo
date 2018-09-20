within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestEvaporator.TestFlooded;
model Test_FloodedUnitPdrop_TC
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
    annotation (Placement(transformation(extent={{-18,-20},{22,30}})));
  Modelica.Blocks.Sources.Constant Cmd_nom(k=1)
    annotation (Placement(transformation(extent={{38,10},
            {54,20}},                                            rotation=
           0)));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP2(
                                                          redeclare package
      Medium =                                                                       Medium,
    h=1.8E6,
    p0=3000000)
    annotation (Placement(transformation(extent={{80,-10},
            {100,10}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(redeclare package
      Medium =                                                                                Medium,Afull=0.000167529)
    annotation (Placement(transformation(extent={{48,-22},{68,-2}})));

    parameter Integer n=2;
parameter Boolean counterCurrent = true;

equation
  connect(sourceCdot.flange, evaF.InFlowSF)
    annotation (Line(
      points={{26.2,83.9},{40,83.9},{40,21.4286},{22,21.4286}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot2.flangeB, evaF.InflowPF)
    annotation (Line(
      points={{-61,-20},{-48,-20},{-48,-11.4286},{-17.5556,-11.4286}},
      color={0,0,255},
      smooth=Smooth.None));

// Time        kk
// 0        0.000167529
// 1000        0.000167529

  connect(Cmd_nom.y, valve.cmd) annotation (Line(
      points={{54.8,15},{58,15},{58,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaF.OutflowPF, valve.InFlow) annotation (Line(
      points={{22,-11.4286},{36,-11.4286},{36,-12},{49,-12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP2.flangeB) annotation (Line(
      points={{67,-12},{78,-12},{78,0},{81.6,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Test_FloodedUnitPdrop_TC;
