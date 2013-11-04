within ThermoCycle.Examples.TestComponents;
model Tank

ThermoCycle.Components.Units.Tanks.Tank_pL tank(
    Vtot=0.01,
    impose_L=true,
    impose_pressure=false,
    pstart=228288)
    annotation (Placement(transformation(extent={{-22,6},{-2,26}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    UseT=false,
    h_0=2.4E5,
    Mdot_0=0.35,
    p=228288) annotation (Placement(transformation(extent={{-44,46},{-24,66}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkVdot sinkVdot(Vdot_0=2e-4, pstart=
        200000)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(sourceWF.flangeB, tank.InFlow) annotation (Line(
      points={{-25,56},{-12,56},{-12,24.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank.OutFlow, sinkVdot.flangeB) annotation (Line(
      points={{-12,7.2},{-12,-30},{0.2,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
                    graphics));
end Tank;
