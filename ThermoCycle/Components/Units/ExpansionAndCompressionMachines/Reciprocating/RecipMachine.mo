within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model RecipMachine
  "A combination of cylinder model and a reciprocating mechanism."

  RecipMachine_Flange recipFlange(redeclare
      ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.StrokeBoreGeometry
      geometry)
    annotation (Placement(transformation(extent={{-40,-40},{0,0}})));
  Cylinder cylinder(
    p_start=system.p_start,
    T_start=system.T_start,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        HeatTransfer,
    use_angle_in=true,
    stroke=recipFlange.stroke,
    nPorts=if leakage then 3 else 2,
    redeclare package Medium = Medium,
    d_inlet=recipFlange.geometry.d_inlet,
    d_outlet=recipFlange.geometry.d_outlet,
    d_leak=recipFlange.geometry.d_leak,
    zeta_inout=recipFlange.geometry.zeta_inout,
    zeta_leak=0.5*recipFlange.geometry.zeta_leak,
    pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.piston.radius^2)
    annotation (Placement(transformation(extent={{-30,40},{-10,20}})));

  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Fluid.Interfaces.FluidPort_a inlet(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-190,80},{-170,100}}),
        iconTransformation(extent={{-190,80},{-170,100}})));
  Modelica.Fluid.Interfaces.FluidPort_b outlet(redeclare package Medium =
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

parameter Boolean leakage = true "Calculate leakage flow";

  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation (
      Placement(transformation(extent={{-190,-100},{-170,-80}}),
        iconTransformation(extent={{-190,-100},{-170,-80}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b annotation (
      Placement(transformation(extent={{170,-100},{190,-80}}),
        iconTransformation(extent={{170,-100},{190,-80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a1
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Modelica.Fluid.Interfaces.FluidPort_b leakage_b(redeclare package Medium =
        Medium) if leakage
    annotation (Placement(transformation(extent={{170,30},{190,50}}),
        iconTransformation(extent={{170,-30},{190,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_b leakage_a(redeclare package Medium =
        Medium) if leakage
    annotation (Placement(transformation(extent={{-190,30},{-170,50}}),
        iconTransformation(extent={{-190,-30},{-170,-10}})));

  WallSegment                                            heatCapacitor
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifice(
    redeclare package Medium = Medium,
    diameter=cylinder.d_leak,
    zeta=cylinder.zeta_leak) if leakage
    annotation (Placement(transformation(extent={{62,40},{82,60}})));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package
      Medium = Medium) if leakage
    annotation (Placement(transformation(extent={{112,32},{132,52}})));
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
  connect(inlet, cylinder.ports[1])  annotation (Line(
      points={{-180,90},{-20,90},{-20,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(outlet, cylinder.ports[2]) annotation (Line(
      points={{180,90},{-20,90},{-20,40}},
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
  connect(cylinder.heatPort, heatCapacitor.port) annotation (Line(
      points={{-30,30},{-60,30},{-60,120},{-90,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, port_a1) annotation (Line(
      points={{-90,120},{-60,120},{-60,180},{4.44089e-16,180}},
      color={191,0,0},
      smooth=Smooth.None));
if leakage then
  connect(orifice.port_a, cylinder.ports[3]) annotation (Line(
      points={{62,50},{22,50},{22,40},{-20,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(leakage_b, teeJunctionIdeal.port_2) annotation (Line(
      points={{180,40},{156,40},{156,42},{132,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(orifice.port_b, teeJunctionIdeal.port_1) annotation (Line(
      points={{82,50},{98,50},{98,42},{112,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(teeJunctionIdeal.port_3, leakage_a) annotation (Line(
      points={{122,52},{122,76},{-148,76},{-148,40},{-180,40}},
      color={0,127,255},
      smooth=Smooth.None));
end if;
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
        Ellipse(extent={{-60,-140},{40,-40}}, lineColor={150,150,150}),
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
          smooth=Smooth.None),
        Line(
          visible=leakage,
          points={{-170,-20},{170,-20},{-58,-20},{-58,106}},
          color={0,127,255},
          thickness=0.5,
          smooth=Smooth.None)}));
end RecipMachine;
