within ThermoCycle.Components.Units.ControlSystems;
model SH_block
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
  Modelica.Blocks.Interfaces.RealInput T_measured
    annotation (Placement(transformation(extent={{-132,30},{-92,70}}),
        iconTransformation(extent={{-126,30},{-86,70}})));
  Modelica.Blocks.Interfaces.RealInput p_measured
    annotation (Placement(transformation(extent={{-130,-60},{-90,-20}}),
        iconTransformation(extent={{-122,-60},{-82,-20}})));
  Modelica.Blocks.Interfaces.RealOutput DeltaT
    annotation (Placement(transformation(extent={{96,-10},{116,10}}),
        iconTransformation(extent={{96,-10},{126,20}})));

//Modelica.SIunits.Temperature Tsat "saturation temperature at the measured pressure";
 Medium.SaturationProperties sat;

equation
  sat = Medium.setSat_p(p_measured);

  DeltaT = T_measured - sat.Tsat;

  annotation (Diagram(graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,255})}), Icon(graphics={
        Text(
          extent={{-94,72},{-50,34}},
          lineColor={0,0,255},
          textString="T"),
        Text(
          extent={{-90,-14},{-40,-52}},
          lineColor={0,0,255},
          textString="p"),
        Text(
          extent={{-6,16},{96,-10}},
          lineColor={0,0,255},
          textString="DELTA_T"),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}));
end SH_block;
