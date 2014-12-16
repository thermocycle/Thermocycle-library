within ThermoCycle.Examples.TestComponents;
model Test_Tank_pL

ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
    Vtot=0.01,
    impose_L=true,
    impose_pressure=false,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    pstart=228288)
    annotation (Placement(transformation(extent={{-52,10},{-32,30}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    UseT=false,
    h_0=2.4E5,
    Mdot_0=0.35,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p=228288) annotation (Placement(transformation(extent={{-76,46},{-56,66}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkVdot sinkVdot(Vdot_0=2e-4,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    pstart=200000)
    annotation (Placement(transformation(extent={{-32,-40},{-12,-20}})));
equation
  connect(sourceWF.flangeB, tank_pL.InFlow)
                                         annotation (Line(
      points={{-57,56},{-42,56},{-42,28.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank_pL.OutFlow, sinkVdot.flangeB)
                                          annotation (Line(
      points={{-42,11.2},{-42,-30},{-31.8,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{20,
            100}}), graphics), Icon(coordinateSystem(extent={{-100,-100},{20,
            100}})));
end Test_Tank_pL;
