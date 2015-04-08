within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses;
partial model PartialRecipMachine
  "Model of a one cylinder engine with crank and slider mechanism"
  import SI = Modelica.SIunits;
  parameter Boolean animate=false;
  replaceable parameter
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry
    geometry constrainedby
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry
    "Define geometry here or replace with appropriate record." annotation (
      choicesAllMatching=true, Placement(transformation(extent={{58,-123},{103,-78}})));
  final parameter SI.Length s_TDC=sqrt((geometry.crankArm.height + geometry.conrod.height)
      ^2 - geometry.d_ppin^2) "Crank shaft to TDC";
  final parameter SI.Length s_BDC=sqrt((geometry.crankArm.height - geometry.conrod.height)
      ^2 - geometry.d_ppin^2) "Crank shaft to BDC";
  final parameter SI.Length z_cra=geometry.d_ppin/(geometry.crankArm.height +
      geometry.conrod.height)*geometry.crankArm.height "Crank pin z at TDC";
  final parameter SI.Length y_cra=s_TDC/(geometry.crankArm.height + geometry.conrod.height)
      *geometry.crankArm.height "Crank pin y at TDC";
  final parameter SI.Length z_rod=geometry.d_ppin/(geometry.crankArm.height +
      geometry.conrod.height)*geometry.conrod.height "Rod pin z at TDC";
  final parameter SI.Length y_rod=s_TDC/(geometry.crankArm.height + geometry.conrod.height)
      *geometry.conrod.height "Rod pin y at TDC";
  final parameter SI.Length h_TDC=geometry.V_tdc/(Modelica.Constants.pi
      *geometry.piston.radius^2) "equivalent height at TDC";
  final parameter SI.Length h_top=s_TDC + geometry.piston.height + h_TDC
    "Height of cylinder";
  final parameter SI.Length stroke=s_TDC - s_BDC;
  final parameter SI.Length bore=geometry.piston.radius*2;
  Modelica.Mechanics.MultiBody.Parts.BodyCylinder piston(
    diameter=2*geometry.piston.radius,
    color={155,155,155},
    length=geometry.piston.height,
    r={0,-geometry.piston.height,0},
    animation=animate,
    density=geometry.piston.rho)
    annotation (Placement(transformation(
        origin={0,95},
        extent={{-15,15},{15,-15}},
        rotation=270)));
  Modelica.Mechanics.MultiBody.Parts.BodyBox conrod(
    widthDirection={1,0,0},
    r={0,y_rod,z_rod},
    animation=animate,
    width=geometry.conrod.width,
    density=geometry.conrod.rho)
                     annotation (Placement(transformation(
        origin={0,15},
        extent={{-15,-15},{15,15}},
        rotation=90)));
  Modelica.Mechanics.MultiBody.Joints.Revolute mainCrankBearing(
    useAxisFlange=true,
    n={1,0,0},
    cylinderColor={100,100,100},
    cylinderLength=0.04,
    cylinderDiameter=0.04,
    animation=animate)     annotation (Placement(transformation(extent={{-95,-80},
            {-65,-110}},      rotation=0)));
  inner Modelica.Mechanics.MultiBody.World world(nominalLength=0.5,
      enableAnimation=animate)                   annotation (Placement(
        transformation(extent={{-140,-10},{-120,10}}, rotation=0)));
  Modelica.Mechanics.Rotational.Components.Inertia internalInertia(
    phi(displayUnit="rad", start=0),
    w(start=0),
    J=1e-8)                            annotation (Placement(transformation(
          extent={{-15,-15},{15,15}},     rotation=90,
        origin={-80,-135})));
  Modelica.Mechanics.MultiBody.Parts.BodyCylinder crankshaft(
    color={100,100,100},
    animation=animate,
    r={geometry.crankShaft.height,0,0},
    diameter=2*geometry.crankShaft.radius,
    density=geometry.crankShaft.rho)
    annotation (Placement(transformation(extent={{-45,-110},{-15,-80}},
          rotation=0)));
  Modelica.Mechanics.MultiBody.Parts.BodyBox crank(
    widthDirection={1,0,0},
    r={0,y_cra,z_cra},
    animation=animate,
    width=geometry.crankArm.width,
    density=geometry.crankArm.rho)
                annotation (Placement(transformation(
        origin={0,-65},
        extent={{-15,-15},{15,15}},
        rotation=90)));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation jacketPosition(
      animation=false, r={crankshaft.r[1],h_top,geometry.d_ppin})
    annotation (Placement(transformation(extent={{-75.5,149},{-55.5,169}},
          rotation=0)));
  Modelica.Mechanics.MultiBody.Joints.Revolute crankPin(
    n={1,0,0},
    cylinderLength=0.03,
    cylinderDiameter=0.03,
    animation=animate) "This is the connection between conrod and crank arm. "
    annotation (Placement(transformation(extent={{-10,-35},{10,-15}})));
  Modelica.Mechanics.MultiBody.Joints.RevolutePlanarLoopConstraint pistonPin(
    n={1,0,0},
    cylinderLength=0.03,
    cylinderDiameter=0.03,
    frame_b(r_0(start={0,0,0})),
    animation=animate) "This is the connection between piston and conrod."
                annotation (Placement(transformation(extent={{10,45},{-10,65}})));
  Modelica.Mechanics.MultiBody.Joints.Prismatic slider(
    useAxisFlange=true,
    n={0,-1,0},
    boxHeight(displayUnit="mm") = slider.boxWidth,
    boxWidth(displayUnit="mm") = 0.5*crank.width,
    s(start=h_TDC),
    animation=false)    annotation (Placement(transformation(
        extent={{-15,-15},{15,15}},
        rotation=-90,
        origin={0,135})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b crankShaft_b
                                                              annotation (
      Placement(transformation(extent={{-190,-165},{-170,-145}}),
        iconTransformation(extent={{-200,-110},{-160,-70}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a crankShaft_a
                                                              annotation (
      Placement(transformation(extent={{173,-165},{193,-145}}),
        iconTransformation(extent={{160,-110},{200,-70}})));
equation
  connect(world.frame_b, mainCrankBearing.frame_a)
    annotation (Line(
      points={{-120,0},{-120,1},{-110,1},{-110,-95},{-103,-95},{-95,-95}},
      color={95,95,95},
      thickness=0.5));
  connect(world.frame_b, jacketPosition.frame_a)
                                              annotation (Line(
      points={{-120,0},{-120,0},{-110,0},{-110,159},{-75.5,159}},
      color={95,95,95},
      thickness=0.5));
  connect(jacketPosition.frame_b, slider.frame_a) annotation (Line(
      points={{-55.5,159},{2.75546e-015,159},{2.75546e-015,150}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mainCrankBearing.frame_b, crankshaft.frame_a)
                                               annotation (Line(
      points={{-65,-95},{-45,-95}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(crank.frame_a, crankshaft.frame_b) annotation (Line(
      points={{-9.18485e-016,-80},{-9.18485e-016,-95},{-15,-95}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slider.frame_b, piston.frame_a)    annotation (Line(
      points={{-2.75546e-015,120},{0,118},{-1.11023e-015,115},{
          2.75546e-015,115},{2.75546e-015,110}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(piston.frame_b, pistonPin.frame_b) annotation (Line(
      points={{-2.75546e-015,80},{-2.75546e-015,70},{-15,70},{-15,55},{
          -10,55}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pistonPin.frame_a, conrod.frame_b) annotation (Line(
      points={{10,55},{15,55},{15,40},{9.18485e-016,40},{9.18485e-016,30}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(conrod.frame_a, crankPin.frame_b) annotation (Line(
      points={{-9.18485e-016,-1.77636e-015},{-9.18485e-016,-10},{15,-10},
          {15,-25},{10,-25}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(crankPin.frame_a, crank.frame_b) annotation (Line(
      points={{-10,-25},{-15,-25},{-15,-40},{9.18485e-016,-40},{
          9.18485e-016,-50}},
      color={95,95,95},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mainCrankBearing.axis, internalInertia.flange_b) annotation (Line(
      points={{-80,-110},{-80,-120}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(crankShaft_b, internalInertia.flange_a) annotation (Line(
      points={{-180,-155},{-80,-155},{-80,-150}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(internalInertia.flange_a, crankShaft_a) annotation (Line(
      points={{-80,-150},{-80,-155},{183,-155}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-180},{180,180}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This is a model of the mechanical part of one cylinder of an expander.
You need to add an external calculation of the pressure in the cylinder.
This can be done with respect to the crank angle, the expander starts at
top dead center (TDC) with 0 degrees.
</p>

</html>"),
    experiment,
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-180,-180},{180,180}},
          preserveAspectRatio=true), graphics={
        Rectangle(
          extent={{-48,99},{68,23}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-50,91},{70,85}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,79},{70,73}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,65},{70,59}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,21},{-30,33},{50,33},{68,21},{-48,21}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Ellipse(
          extent={{4,51},{12,43}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-40,-129},{46,-44}}, lineColor={150,150,150}),
        Line(
          points={{0,-90},{36,-58},{8,46}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{-180,-120},{180,-180}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-160,-90},{180,-90}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{0,128},{0,-110}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.DashDot),
        Line(
          points={{8,128},{8,-110}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.DashDot)}));
end PartialRecipMachine;
