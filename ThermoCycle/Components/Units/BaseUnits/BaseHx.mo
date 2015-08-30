within ThermoCycle.Components.Units.BaseUnits;
partial model BaseHx
replaceable package Medium1 = ThermoCycle.Media.DummyFluid
                                               constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid"   annotation (choicesAllMatching = true);
replaceable package Medium2 = ThermoCycle.Media.DummyFluid
                                               constrainedby
    Modelica.Media.Interfaces.PartialMedium "In Hx1DInc: Secondary fluid"  annotation (choicesAllMatching = true);
  Interfaces.Fluid.FlangeA inlet_fl1( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}}),
        iconTransformation(extent={{-110,-60},{-90,-40}})));
  Interfaces.Fluid.FlangeB outlet_fl1( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{86,-60},{106,-40}}),
        iconTransformation(extent={{90,-60},{110,-40}})));
  Interfaces.Fluid.FlangeA inlet_fl2( redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{88,50},{108,70}})));
  Interfaces.Fluid.FlangeB outlet_fl2( redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{-108,48},{-88,68}})));
  annotation (Diagram(graphics), Icon(graphics),
    Documentation(info="<HTML>
<p><big> Partial Model <b>BaseHx</b> defines the four fluid port for an heat exchanger model.
</html>"));
end BaseHx;
