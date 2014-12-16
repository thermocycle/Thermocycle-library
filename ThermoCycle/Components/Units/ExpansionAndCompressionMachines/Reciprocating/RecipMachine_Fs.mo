within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model RecipMachine_Fs
  "Model of one cylinder with force and piston position connectors"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialRecipMachine;
  Modelica.Mechanics.Translational.Sources.Force forceJacket annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={106,146})));
  Modelica.Mechanics.Translational.Sensors.RelPositionSensor positionSensor
    annotation (Placement(transformation(
        extent={{15,-15},{-15,15}},
        rotation=90,
        origin={71,121})));
  Modelica.Mechanics.Translational.Sources.Force forcePiston annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={106,96})));
  output Modelica.Blocks.Interfaces.RealOutput position       annotation (
      Placement(transformation(extent={{100,110},{120,130}}),iconTransformation(
          extent={{100,110},{120,130}})));
  input Modelica.Blocks.Interfaces.RealInput forces
    annotation (Placement(transformation(extent={{-120,100},{-80,140}}),
        iconTransformation(extent={{-120,100},{-80,140}})));
equation
  connect(positionSensor.flange_b,forcePiston. flange) annotation (Line(
      points={{71,106},{71,81},{106,81},{106,86}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(positionSensor.flange_a,forceJacket. flange) annotation (Line(
      points={{71,136},{71,161},{106,161},{106,156}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(positionSensor.s_rel, position)       annotation (Line(
      points={{87.5,121},{96,121},{96,122},{134,122},{134,120},{110,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(forces, forceJacket.f) annotation (Line(
      points={{-100,120},{-100,0},{-164,0},{-164,170},{120,170},{120,130},
          {106,130},{106,134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(forces, forcePiston.f) annotation (Line(
      points={{-100,120},{-164,120},{-164,170},{120,170},{120,112},{106,
          112},{106,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(positionSensor.flange_a, slider.support) annotation (Line(
      points={{71,136},{71,141},{9,141}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(slider.axis, positionSensor.flange_b) annotation (Line(
      points={{9,123},{34,123},{34,104},{71,104},{71,106}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-180,-180},{180,180}},
          preserveAspectRatio=true), graphics), Icon(coordinateSystem(extent={{-180,
            -180},{180,180}},      preserveAspectRatio=true), graphics={Text(
          extent={{-120,78},{-80,42}},
          pattern=LinePattern.None,
          textString="F",
          lineColor={0,0,255},
          textStyle={TextStyle.Italic}), Text(
          extent={{100,80},{140,40}},
          pattern=LinePattern.None,
          textString="s",
          lineColor={0,0,255},
          textStyle={TextStyle.Italic})}));
end RecipMachine_Fs;
