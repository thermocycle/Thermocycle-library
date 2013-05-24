within ThermoCycle.Examples.TestComponents;
model Tank

  ThermoCycle.Components.Units.Tanks.Tank_pL tank(
    Vtot=0.01,
    impose_L=true,
    impose_pressure=false,
    pstart=228288)
    annotation (Placement(transformation(extent={{-24,6},{-4,26}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=0.2587,
    UseT=false,
    h_0=2.4E5,
    p=228288) annotation (Placement(transformation(extent={{-42,46},{-22,66}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkVdot sinkVdot(Vdot=2e-4, pstart=228288)
    annotation (Placement(transformation(extent={{-6,-28},{14,-8}})));
 ThermoCycle.Components.Units.Tanks.Tank tank_old(
    Vtot=0.01,
    level_start=0.6,
    pstart=200000)
    annotation (Placement(transformation(extent={{34,6},{54,26}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF1(
    Mdot_0=0.2587,
    UseT=false,
    p=200000,
    h_0=2.4E5) annotation (Placement(transformation(extent={{10,46},{30,66}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkVdot sinkVdot1(Vdot=2e-4, pstart=200000)
    annotation (Placement(transformation(extent={{46,-28},{66,-8}})));
equation
  connect(sourceWF.flangeB, tank.InFlow) annotation (Line(
      points={{-23,56},{-14,56},{-14,24.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank.OutFlow, sinkVdot.flangeB) annotation (Line(
      points={{-14,7.2},{-14,-18},{-5.8,-18}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceWF1.flangeB, tank_old.InFlow) annotation (Line(
      points={{29,56},{44,56},{44,24.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank_old.OutFlow, sinkVdot1.flangeB) annotation (Line(
      points={{44,7.2},{46.2,7.2},{46.2,-18}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end Tank;
