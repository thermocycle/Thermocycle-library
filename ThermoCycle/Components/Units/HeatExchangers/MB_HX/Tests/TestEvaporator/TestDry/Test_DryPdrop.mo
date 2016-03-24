within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestEvaporator.TestDry;
model Test_DryPdrop
  replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp;
ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Unit.EvaDw
                                                                                   evaD(
    redeclare package Medium = Medium,
    YY=1.57,
    cpw=500,
    Mw=90,
    Mdotnom=0.5,
    Unomsf=1000,
    lstartSH=40,
    lstartTP=460,
    hstartSH=3.6E6,
    hstartTP=2.6E6,
    SteadyStateWall=true,
    pstart=6000000,
    TstartWall={1273.15,1273.15},
    Tstartsf=1473.15,
    DTstartsf=323.15)
    annotation (Placement(transformation(extent={{-20,-6},{30,38}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
                                                                    redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.5,
    p=150000,
    T_0=520)
    annotation (Placement(transformation(extent={{-84,-18},
            {-64,2}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    cp=4000,
    Mdot_0=15,
    T_0=1473.15)
             annotation (Placement(transformation(extent={{22,50},
            {42,70}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP2(
                                                          redeclare package
      Medium =                                                                       Medium,
    h=1.8E6,
    p0=3000000)
    annotation (Placement(transformation(extent={{90,0},{110,20}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(redeclare package
      Medium =                                                                                Medium,Afull=0.000167529)
    annotation (Placement(transformation(extent={{52,2},{72,22}})));
  Modelica.Blocks.Sources.Constant Cmd_nom1(
                                           k=1)
    annotation (Placement(transformation(extent={{42,34},{58,44}},
                                                                 rotation=
           0)));
equation
  connect(sourceMdot2.flangeB, evaD.InflowPF)
    annotation (Line(
      points={{-65,-8},{-42,-8},{-42,1.54286},{-20,1.54286}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(sourceCdot.flange, evaD.InFlowSF)
    annotation (Line(
      points={{40.2,59.9},{60,59.9},{60,31.7143},{30,31.7143}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cmd_nom1.y, valve.cmd) annotation (Line(
      points={{58.8,39},{62,39},{62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaD.OutflowPF, valve.InFlow) annotation (Line(
      points={{30,3.42857},{42,3.42857},{42,12},{53,12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(valve.OutFlow, sinkP2.flangeB) annotation (Line(
      points={{71,12},{78,12},{78,10},{91.6,10}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics));
end Test_DryPdrop;
