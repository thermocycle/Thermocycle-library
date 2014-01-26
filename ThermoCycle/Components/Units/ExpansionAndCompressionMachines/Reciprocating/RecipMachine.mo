within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model RecipMachine
  "A combination of cylinder model and a reciprocating mechanism."

  RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
    annotation (Placement(transformation(extent={{-40,-40},{0,0}})));
  Cylinder cylinder(
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
    p_start=system.p_start,
    T_start=system.T_start,
    use_portsData=false,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        HeatTransfer,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    nPorts=2,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-30,40},{-10,20}})));

  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-190,80},{-170,100}}),
        iconTransformation(extent={{-190,80},{-170,100}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{170,80},{190,100}}),
        iconTransformation(extent={{170,80},{190,100}})));
inner outer Modelica.Fluid.System system;
replaceable package Medium = Modelica.Media.Interfaces.PartialMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid" annotation (choicesAllMatching=true);
replaceable model HeatTransfer =
ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.ConstantHeatTransfer
      (alpha0=30) constrainedby
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer
    "Wall heat transfer"
    annotation (choicesAllMatching=true);

  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation (
      Placement(transformation(extent={{-190,-100},{-170,-80}}),
        iconTransformation(extent={{-190,-100},{-170,-80}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b annotation (
      Placement(transformation(extent={{170,-100},{190,-80}}),
        iconTransformation(extent={{170,-100},{190,-80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a1
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
equation
  connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
      points={{-20,20},{-20,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
      points={{0,-30},{12,-30},{12,-10},{20,-10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(angleSensor.phi, cylinder.angle_in) annotation (Line(
      points={{41,-10},{50,-10},{50,30},{-10,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, cylinder.ports[1]) annotation (Line(
      points={{-180,90},{-22,90},{-22,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, cylinder.ports[2]) annotation (Line(
      points={{180,90},{-18,90},{-18,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_a, flange_b) annotation (Line(
      points={{0,-30},{90,-30},{90,-90},{180,-90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(recipFlange.crankShaft_b, flange_a) annotation (Line(
      points={{-40,-30},{-110,-30},{-110,-90},{-180,-90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(flange_a, flange_a) annotation (Line(
      points={{-180,-90},{-177,-90},{-177,-90},{-180,-90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(cylinder.heatPort, port_a1) annotation (Line(
      points={{-30,30},{-36,30},{-36,180},{0,180}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-180,-180},{180,180}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-180,-180},{180,
            180}}, preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-56,99},{60,23}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-58,91},{62,85}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,79},{62,73}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,65},{62,59}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-56,21},{-38,33},{42,33},{60,21},{-56,21}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Ellipse(
          extent={{-4,51},{4,43}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-48,-129},{32,-49}}, lineColor={150,150,150}),
        Line(
          points={{-8,-90},{28,-58},{0,46}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{-170,-130},{190,-190}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-170,-90},{170,-90}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-8,128},{-8,-110}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.DashDot),
        Line(
          points={{0,128},{0,-110}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.DashDot),
        Polygon(
          points={{-60,150},{64,150},{64,-12},{72,-12},{72,158},{-68,158},{-68,
              -12},{-60,-12},{-60,150}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-170,90},{-160,90},{-160,140},{-60,140}},
          color={0,127,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{170,90},{160,90},{160,140},{64,140}},
          color={0,127,255},
          thickness=0.5,
          smooth=Smooth.None)}));
end RecipMachine;
