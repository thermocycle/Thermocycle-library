within ThermoCycle.Components.Units.BaseUnits;
partial model BaseHxConst
replaceable package Medium1 = ThermoCycle.Media.DummyFluid
                                               constrainedby
    Modelica.Media.Interfaces.PartialMedium   annotation (choicesAllMatching = true);
  Interfaces.Fluid.Flange_Cdot inletSf
    annotation (Placement(transformation(extent={{88,40},{108,60}}),
        iconTransformation(extent={{90,40},{110,60}})));
  Interfaces.Fluid.Flange_ex_Cdot outletSf
    annotation (Placement(transformation(extent={{-106,40},{-86,60}}),
        iconTransformation(extent={{-110,40},{-90,60}})));
  Interfaces.Fluid.FlangeA inletWf( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}}),
        iconTransformation(extent={{-110,-60},{-90,-40}})));
  Interfaces.Fluid.FlangeB outletWf( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{86,-60},{106,-40}}),
        iconTransformation(extent={{90,-60},{110,-40}})));
  annotation (Diagram(graphics), Icon(graphics),
    Documentation(info="<HTML>
<p><big> Partial Model <b>BaseHx</b> defines the four fluid port for an heat exchanger model that uses as secondary fluid a constant heat capacity fluid
</html>"));
end BaseHxConst;
