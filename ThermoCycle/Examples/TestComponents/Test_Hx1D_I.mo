within ThermoCycle.Examples.TestComponents;
model Test_Hx1D_I
// parameter Real k( start = 1, fixed = false)= 1;
//
// Modelica.SIunits.Power PowerRec = Recuperator.Q_hot_;

  ThermoCycle.Components.Units.HeatExchangers.Hx1D    Recuperator(
    redeclare package Medium1 = ThermoCycle.Media.SES36_CP,
    redeclare package Medium2 = ThermoCycle.Media.SES36_CP,
    MdotNom_Hot=0.3335,
    MdotNom_Cold=0.3335,
    steadystate_h_cold=true,
    N=10,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff,
    Unom_l_cold=1500,
    Unom_tp_cold=1500,
    Unom_v_cold=1500,
    Unom_l_hot=1000,
    Unom_tp_hot=1000,
    Unom_v_hot=1000,
    Ahot=1,
    Acold=1,
    pstart_cold=863885,
    pstart_hot=127890,
    Tstart_inlet_cold=303.59,
    Tstart_outlet_cold=356.26,
    Tstart_inlet_hot=368.05,
    Tstart_outlet_hot=315.81)
    annotation (Placement(transformation(extent={{-34,-22},{28,40}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    redeclare package Medium = ThermoCycle.Media.SES36_CP,
    Mdot_0=0.3335,
    p=888343,
    T_0=303.59)
    annotation (Placement(transformation(extent={{-94,-28},{-74,-8}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = ThermoCycle.Media.SES36_CP,
    h=290659,
    p0=863885)
    annotation (Placement(transformation(extent={{68,-48},{88,-28}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
    redeclare package Medium = ThermoCycle.Media.SES36_CP,
    Mdot_0=0.3335,
    UseT=false,
    h_0=236271,
    p=127890,
    T_0=368.05)
    annotation (Placement(transformation(extent={{26,70},{46,90}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(
    redeclare package Medium = ThermoCycle.Media.SES36_CP,
    h=363652,
    p0=127890)
    annotation (Placement(transformation(extent={{-54,72},{-36,90}})));
// initial equation
// PowerRec = 20.330e3;

  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensTp(redeclare package
      Medium = ThermoCycle.Media.SES36_CP)
    annotation (Placement(transformation(extent={{-32,18},{-52,38}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensTp1(redeclare package
      Medium = ThermoCycle.Media.SES36_CP)
    annotation (Placement(transformation(extent={{30,-12},{50,8}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensTp2(redeclare package
      Medium = ThermoCycle.Media.SES36_CP)
    annotation (Placement(transformation(extent={{-62,-22},{-42,-2}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensTp3(redeclare package
      Medium = ThermoCycle.Media.SES36_CP)
    annotation (Placement(transformation(extent={{40,34},{60,54}})));
equation

  connect(Recuperator.outlet_fl1, sensTp1.InFlow) annotation (Line(
      points={{17.6667,-1.33333},{26,-1.33333},{26,-6.8},{33,-6.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp1.OutFlow, sinkP.flangeB) annotation (Line(
      points={{47,-6.8},{60,-6.8},{60,-38},{69.6,-38}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.InFlow, Recuperator.outlet_fl2) annotation (Line(
      points={{-35,23.2},{-30,20.9867},{-23.2533,20.9867}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.OutFlow, sinkP1.flangeB) annotation (Line(
      points={{-49,23.2},{-66,23.2},{-66,81},{-52.56,81}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, sensTp2.InFlow) annotation (Line(
      points={{-75,-18},{-66,-18},{-66,-16.8},{-59,-16.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp2.OutFlow, Recuperator.inlet_fl1) annotation (Line(
      points={{-45,-16.8},{-32,-16.8},{-32,-1.33333},{-23.6667,-1.33333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, sensTp3.InFlow) annotation (Line(
      points={{45,80},{54,80},{54,58},{32,58},{32,39.2},{43,39.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp3.OutFlow, Recuperator.inlet_fl2) annotation (Line(
      points={{57,39.2},{68,39.2},{68,21.4},{17.2533,21.4}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}}),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_Hx1D_I;
