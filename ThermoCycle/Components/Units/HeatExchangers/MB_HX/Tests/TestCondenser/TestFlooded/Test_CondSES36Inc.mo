within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestCondenser.TestFlooded;
model Test_CondSES36Inc
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
      parameter Modelica.SIunits.AbsolutePressure pp = 0.91e5;
      parameter Medium.SaturationProperties sat = Medium.setSat_p(pp);
      parameter Medium.SpecificEnthalpy h0 = Medium.dewEnthalpy(sat)+5E3;
ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Condenser.Incompressible.Unit.CondFwInc
                                                                                                     condFw(
    redeclare package Medium = Medium,
    AA=0.0007,
    YY=0.243,
    Ltotal=66.6,
    cpw=500,
    Mw=69,
    epsNTU_sf=true,
    Mdotnom=0.3061,
    UnomSC=1000,
    Unomsf=1000,
    hstartSC=13167,
    lstartTP=44.2,
    lstartSC=22.2,
    SteadyStatePF=true,
    SteadyStateWall=true,
    hstartTP=175242,
    VoidFraction=true,
    UnomTP=9000,
    pstart=9100000000,
    TstartWall={288.15,288.15},
    Tstartsf=295.15,
    DTstartsf=278.15)
    annotation (Placement(transformation(extent={{-28,-4},{18,40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot1(
    Mdot_0=1.546,
    cp=4183,
    rho=1000,
    T_0=295.54)
    annotation (Placement(transformation(extent={{8,46},{28,66}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,Mdot_0=0.306,
    UseT=false,
    h_0=175242)
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                       Medium, p0=
       91000)
    annotation (Placement(transformation(extent={{48,-40},{68,-20}})));
equation
  connect(sourceCdot1.flange, condFw.InFlowSF) annotation (Line(
      points={{26.2,55.9},{54,55.9},{54,31.8286},{18.5111,31.8286}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, condFw.InflowPF) annotation (Line(
      points={{-61,-12},{-50,-12},{-50,3.54286},{-27.4889,3.54286}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condFw.OutflowPF, sinkP.flangeB) annotation (Line(
      points={{18.5111,2.28571},{38,2.28571},{38,-30},{49.6,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_CondSES36Inc;
