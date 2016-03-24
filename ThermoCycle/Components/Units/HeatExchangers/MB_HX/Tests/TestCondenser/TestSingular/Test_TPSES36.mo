within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestCondenser.TestSingular;
model Test_TPSES36
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
  MovingBoundaryLibrary.Components.Condenser.Unit.Single.CondTp condTp(
    redeclare package Medium = Medium,
    AA=0.0007,
    YY=0.243,
    cpw=500,
    Mw=69,
    epsNTU_sf=true,
    Mdotnom=0.3061,
    Unom=8000,
    Unomsf=1000,
    hstart=175242,
    lstart=66.6,
    VoidFraction=false,
    VoidF=0.8,
    Ltotal=35.6,
    pstart=91000,
    TstartWall={288.15},
    Tstartsf=295.15,
    DTstartsf=278.15)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,Mdot_0=0.306,
    UseT=false,
    h_0=175242)
    annotation (Placement(transformation(extent={{-70,-12},{-50,8}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot1(
    Mdot_0=1.546,
    cp=4183,
    rho=1000,
    T_0=295.54)
    annotation (Placement(transformation(extent={{18,56},{38,76}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                       Medium, p0=
       91000)
    annotation (Placement(transformation(extent={{58,-30},{78,-10}})));
equation
  connect(sourceMdot.flangeB, condTp.InflowPF) annotation (Line(
      points={{-51,-2},{-40,-2},{-40,-12},{-20,-12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condTp.OutflowPF, sinkP.flangeB) annotation (Line(
      points={{19.6,-12},{36,-12},{36,-20},{59.6,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot1.flange, condTp.InFlowSF) annotation (Line(
      points={{36.2,65.9},{66,65.9},{66,12},{19.2,12}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_TPSES36;
