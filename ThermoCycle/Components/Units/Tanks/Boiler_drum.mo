within ThermoCycle.Components.Units.Tanks;
model Boiler_drum
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);

 /******************************* PARAMETERS *****************************/
  parameter Modelica.SIunits.Volume Vtot=0.002 "Volume of the tank";
  parameter Modelica.SIunits.Pressure p_ng = 0
    "Partial pressure of non-condensable gases";
  parameter Modelica.SIunits.Pressure pstart=5e5 "Initial pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter Real L_start=0.6 "Initial level"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean impose_L=true "Set to yes to impose the initial tank level"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean impose_pressure=false
    "Set to yes to impose the initial tank pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean SteadyState_p=false
    "Set to yes to impose initial steady-state on the pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean SteadyState_L=false
    "Set to yes to impose initial steady-state on the tank level"
    annotation (Dialog(tab="Initialisation"));

 /******************************* VARIABLES *****************************/

  Medium.ThermodynamicState stateIn_Evaporator;
  Medium.ThermodynamicState stateIn_Economizer;
  Medium.ThermodynamicState stateOut_v;
  Medium.ThermodynamicState stateOut_l;

 /******************************* COMPONENTS *****************************/

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
    annotation (Placement(transformation(extent={{-86,-58},{-66,-38}}),
        iconTransformation(extent={{-86,-58},{-66,-38}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow_economizer(redeclare package
      Medium = Medium) annotation (Placement(transformation(extent={{-44,56},
            {-24,76}}), iconTransformation(extent={{-10,-98},{10,-78}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow_evaporator(redeclare package
      Medium = Medium) annotation (Placement(transformation(extent={{-38,0},
            {-18,20}}), iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealOutput level annotation (Placement(
        transformation(extent={{82,42},{120,80}}), iconTransformation(extent={{86,-8},
            {102,8}})));
equation

  stateIn_Evaporator = Medium.setState_ph(InFlow_evaporator.p,inStream(InFlow_evaporator.h_outflow));
  stateIn_Economizer = Medium.setState_ph(InFlow_economizer.p,inStream(InFlow_economizer.h_outflow));
  stateOut_v = Medium.setState_ph(OutFlow_v.p,OutFlow_v.h_outflow);
  stateOut_l = Medium.setState_ph(OutFlow_l.p,OutFlow_l.h_outflow);

  connect(drum_pL.OutFlow_v,OutFlow_v)
                                      annotation (Line(
      points={{12,57},{6,57},{6,90},{0,90}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(drum_pL.OutFlow_l,OutFlow_l) annotation (Line(
      points={{12,39},{6,39},{6,-48},{-76,-48}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(InFlow_evaporator, drum_pL.InFlow) annotation (Line(
      points={{-28,10},{-28,40},{-26,40},{-26,48},{3,48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(InFlow_economizer, drum_pL.InFlow) annotation (Line(
      points={{-34,66},{-34,48},{3,48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(drum_pL.level, level) annotation (Line(
      points={{21.4,48},{56,48},{56,61},{101,61}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={0,0,0},
          lineThickness=1,
          startAngle=0,
          endAngle=360,
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={0,0,0},
          lineThickness=1,
          startAngle=180,
          endAngle=360,
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{-41,-26},{41,-26},{33,-26}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-24,-36},{24,-36},{16,-36}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-13,-46},{13,-46},{5,-46}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-4,-56},{4,-56},{-4,-56}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Text(extent={{-100,48},{100,14}},
          textString="%name",
          lineColor={0,0,0}),
        Line(
          points={{-67,-14},{67,-14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None)}),
                   Documentation(info="<html>
<p><big>Model <b>Boiler Drum</b> is a variation of the  <a href=\"modelica://ThermoCycle.Components.Units.Tanks.Drum_pL\">Drum_pL</a>. 
<p><big>It represents the drum for a boiler system.
<p><big>The parameters and modeling options for this model are the same that for the Drum_pL model

<p><big> It has two inputs and two outputs:A description of the four different port is repored hereunder:
<ul>
<li> InFlow_economizer: it represents the feed water flow coming from the economizer
<li> InFlow_evaporator: it represents the flow coming from the evaporator.
<li> OutFlow_l: it represents the flow going out to the evaporator
 <li> OutFlow_v: it represents for the saturated steam mainly going to the superheater section</li>

</html>"));
end Boiler_drum;
