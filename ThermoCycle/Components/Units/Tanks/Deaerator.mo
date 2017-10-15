within ThermoCycle.Components.Units.Tanks;
model Deaerator
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);

  /******************************* PARAMETERS *****************************/

  parameter Modelica.SIunits.Volume Vtot=0.002 "Volume of the tank";
  parameter Modelica.SIunits.Pressure p_ng = 0
    "Partial pressure of non-condensable gases";
  parameter Modelica.SIunits.Pressure pstart=5e5 "Initial pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Real L_start=0.6 "Initial level"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean impose_L=true "if true, imposes the initial tank level"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean impose_pressure=false
    "if true, imposes the initial tank pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean SteadyState_p=false
    "if true, imposes initial steady-state on the pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean SteadyState_L=false
    "if true, imposes initial steady-state on the tank level"
    annotation (Dialog(tab="Initialization"));

/******************************* VARIABLES *****************************/

    Medium.ThermodynamicState stateOut_l;

 /******************************* COMPONENTS *****************************/
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow_l(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-40,54},{-20,74}}),
        iconTransformation(extent={{-40,54},{-20,74}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow_v(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-40,20},{-20,40}}),
        iconTransformation(extent={{-40,20},{-20,40}})));
 ThermoCycle.Components.Units.Tanks.Drum_pL drum_pL(
    redeclare package Medium = Medium,
    Vtot=Vtot,
    p_ng=p_ng,
    pstart=pstart,
    L_start=L_start,
    impose_L=impose_L,
    impose_pressure=impose_pressure,
    SteadyState_p=SteadyState_p,
    SteadyState_L=SteadyState_L)
    annotation (Placement(transformation(extent={{2,38},{22,58}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow_v(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow_l(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}}),
        iconTransformation(extent={{-10,-80},{10,-60}})));
equation
   stateOut_l = Medium.setState_ph(OutFlow_l.p,OutFlow_l.h_outflow);

  connect(InFlow_l, drum_pL.InFlow) annotation (Line(
      points={{-30,64},{-16,64},{-16,48},{3,48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(InFlow_v, drum_pL.InFlow) annotation (Line(
      points={{-30,30},{-22,30},{-22,28},{-16,28},{-16,48},{3,48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(drum_pL.OutFlow_v, OutFlow_v)
                                      annotation (Line(
      points={{12,57},{6,57},{6,90},{0,90}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(drum_pL.OutFlow_l, OutFlow_l)
                                       annotation (Line(
      points={{12,39},{6,39},{6,-70},{0,-70}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(extent={{-100,20},{100,-60}},
                                              lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135},
          radius=10),
        Rectangle(extent={{-100,-24},{100,-60}},
                                              lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,99,191},
          radius=10),
        Rectangle(extent={{-100,-24},{100,-42}},
          fillPattern=FillPattern.Solid,
          fillColor={0,99,191},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(extent={{-20,80},{20,14}}, lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.VerticalCylinder,
          radius=6),
        Line(
          points={{-22,64},{18,64},{-6,64}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,30},{20,30},{-4,30}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-86,-46},{88,-46},{32,-46}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-26,1.84308e-016},{40,0},{4,0}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-30,-20},
          rotation=90),
        Line(
          points={{-16,36},{-12,30},{-12,36},{-12,30},{-8,36},{-8,36}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-4,36},{0,30},{0,36},{0,30},{4,36},{4,36}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{8,36},{12,30},{12,36},{12,30},{16,36},{16,36}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-16,58},{-12,64},{-12,58},{-12,64},{-8,58},{-8,58}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-4,58},{0,64},{0,58},{0,64},{4,58},{4,58}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{8,58},{12,64},{12,58},{12,64},{16,58},{16,58}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-80,-40},{-76,-46},{-76,-40},{-76,-46},{-72,-40},{-72,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,-40},{-56,-46},{-56,-40},{-56,-46},{-52,-40},{-52,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,-40},{-36,-46},{-36,-40},{-36,-46},{-32,-40},{-32,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,-40},{-16,-46},{-16,-40},{-16,-46},{-12,-40},{-12,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-40},{4,-46},{4,-40},{4,-46},{8,-40},{8,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,-40},{24,-46},{24,-40},{24,-46},{28,-40},{28,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,-40},{44,-46},{44,-40},{44,-46},{48,-40},{48,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,-40},{64,-46},{64,-40},{64,-46},{68,-40},{68,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{80,-40},{84,-46},{84,-40},{84,-46},{88,-40},{88,-40}},
          color={255,0,0},
          smooth=Smooth.None),
        Text(extent={{-72,10},{128,-16}},   textString="%name")}),
         Documentation(info="<html>
<p><big>Model <b>Deareator</b> is a variation of the  <a href=\"modelica://ThermoCycle.Components.Units.Tanks.Drum_pL\">Drum_pL</a>. 
<p><big>It represents a tray-type dearator.It is modeled as a liquid-vapor tank in which  saturated vapor is injected to extract the air dissolved in the liquid.
It is composed by four flow connectors and by the Drum_pL model.
<p><big>The parameters and modeling options for this model are the same that for the Drum_pL model

<ul>
<li> InFlow_l: it represents the boiler feed water
<li> InFlow_v: it represents the low-pressure heated steam which enters below the perforation trays to remove the gas dissolved and it also enters in the horizontal storage vessel to keep the deaerated water warm
<li> OutFlow_v: it represents the gas/steam mixture
 <li> OutFlow_l: it represents the dearated water which is collected at the bottoò of the storage vessel</li>

</html>"),                       Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end Deaerator;
