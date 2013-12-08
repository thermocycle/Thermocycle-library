within ThermoCycle.Examples.TestComponents;
model Pump

  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Pump
                                          pump(redeclare package Medium =
        ThermoCycle.Media.R245faCool)
    annotation (Placement(transformation(extent={{-16,-14},{10,12}})));
  Components.FluidFlow.Reservoirs.SourceP sourceP(redeclare package Medium =
        ThermoCycle.Media.R245faCool, p0=115794)
    annotation (Placement(transformation(extent={{-100,-16},{-80,4}})));
  Components.FluidFlow.Reservoirs.SourceP sourceP1(redeclare package Medium =
        ThermoCycle.Media.R245faCool, p0=863885)
    annotation (Placement(transformation(extent={{76,6},{56,26}})));
  Modelica.Blocks.Sources.Constant const(k=34)
    annotation (Placement(transformation(extent={{-70,46},{-50,66}})));
equation
  connect(sourceP.flange, pump.InFlow) annotation (Line(
      points={{-80.6,-6},{-46,-6},{-46,-0.35},{-12.36,-0.35}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump.OutFlow, sourceP1.flange) annotation (Line(
      points={{4.28,8.62},{34,8.62},{34,16},{56.6,16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(const.y, pump.flow_in) annotation (Line(
      points={{-49,56},{-7.16,56},{-7.16,9.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Pump;
