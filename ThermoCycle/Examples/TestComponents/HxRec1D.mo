within ThermoCycle.Examples.TestComponents;
model HxRec1D
ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot   sourceWF(
    Mdot_0=0.25877,
    UseT=false,
    h_0=250853)
    annotation (Placement(transformation(extent={{-96,-62},{-76,-42}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkP    sinkPFluid(p0=2351190)
    annotation (Placement(transformation(extent={{74,-66},{94,-46}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot   sourceWF1(
    Mdot_0=0.25877,
    UseT=false,
    h_0=470523)
    annotation (Placement(transformation(extent={{96,52},{76,72}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP   sinkPFluid1(p0=153454)
    annotation (Placement(transformation(extent={{-68,64},{-88,84}})));
  ThermoCycle.Components.Units.HeatExchangers.HxRec1D hxRec1D(redeclare package
      Medium1 =
        Media.R245faCool,                                                                                   redeclare
      package Medium2 =
        Media.R245faCool)
    annotation (Placement(transformation(extent={{24,36},{-32,-20}})));
equation
  connect(sourceWF1.flangeB, hxRec1D.inlet_fl1) annotation (Line(
      points={{77,62},{54,62},{54,17.3333},{14.6667,17.3333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hxRec1D.outlet_fl1, sinkPFluid1.flangeB) annotation (Line(
      points={{-22.6667,17.3333},{-48,17.3333},{-48,73.8},{-69.6,73.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceWF.flangeB, hxRec1D.inlet_fl2) annotation (Line(
      points={{-77,-52},{-60,-52},{-60,-3.2},{-22.2933,-3.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hxRec1D.outlet_fl2, sinkPFluid.flangeB) annotation (Line(
      points={{14.2933,-2.82667},{42,-2.82667},{42,-56.2},{75.6,-56.2}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HxRec1D;
