within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.BaseClasses;
partial record SimpleGeometry "Simple geometry"
  extends
    ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.BaseClasses.BaseGeometry(
    final d_ppin=0,
    final r_crank=0.5*stroke,
    final r_piston=0.5*bore,
    final h_piston=bore);
  parameter Modelica.SIunits.Length l_conrod(displayUnit="mm")
    "Length of connection rod";
  parameter Modelica.SIunits.Length stroke(displayUnit="mm") "Stroke length";
  parameter Modelica.SIunits.Length bore(displayUnit="mm") "Cylinder bore";
  parameter Modelica.SIunits.Volume V_tdc(displayUnit="ml")
    "ml=cm^3 - clearance volume";
end SimpleGeometry;
