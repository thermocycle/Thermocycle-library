within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestCondenser.TestGeneral;
model Test_CondSES36
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
      parameter Modelica.SIunits.AbsolutePressure pp = 0.91e5;
      parameter Medium.SaturationProperties sat = Medium.setSat_p(pp);
      parameter Medium.SpecificEnthalpy h0 = Medium.dewEnthalpy(sat)+5E3;
 ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Condenser.Unit.CondGw
                                                                                    condGw(
    redeclare package Medium = Medium,
    AA=0.0007,
    YY=0.243,
    Ltotal=66.6,
    cpw=500,
    Mw=69,
    Mdotnom=0.3061,
    UnomSC=1000,
    UnomTP=1000,
    UnomSH=3000,
    Unomsf=1000,
    hstartSH=h0,
    hstartTP=1e5,
    hstartSC=13167,
    lstartSH=22.2,
    lstartTP=22.2,
    lstartSC=22.2,
    SteadyStatePF=true,
    SteadyStateWall=true,
    VoidFraction=true,
    epsNTU_sf=false,
    pstart=9100000000,
    TstartWall={288.15,288.15,288.15},
    Tstartsf=295.15,
    DTstartsf=278.15)
    annotation (Placement(transformation(extent={{-20,-22},{26,22}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot1(
    Mdot_0=1.546,
    cp=4183,
    rho=1000,
    T_0=295.54)
    annotation (Placement(transformation(extent={{8,46},{28,66}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,Mdot_0=0.306,
    UseT=false,
    h_0=h0)
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                       Medium,p0=91000)
    annotation (Placement(transformation(extent={{48,-40},{68,-20}})));
equation
  connect(sourceCdot1.flange, condGw.InFlowSF) annotation (Line(
      points={{26.2,55.9},{54,55.9},{54,15.7143},{26.5111,15.7143}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(condGw.InFlowPF, sourceMdot.flangeB) annotation (Line(
      points={{-19.4889,-14.4571},{-22,-14.4571},{-22,-12},{-61,-12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condGw.OutFlowPF, sinkP.flangeB) annotation (Line(
      points={{26.5111,-15.7143},{34,-15.7143},{34,-30},{49.6,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_CondSES36;
