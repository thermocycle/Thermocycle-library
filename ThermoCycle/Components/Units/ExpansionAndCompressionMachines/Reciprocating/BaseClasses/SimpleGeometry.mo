within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses;
partial record SimpleGeometry "Simple geometry"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry(
    final d_ppin=0,
    final r_crank=0.5*stroke,
    final r_piston=0.5*bore,
    final h_piston=bore,
    final r_crankshaft=r_shaft,
    final m_conrod=m_con,
    final m_crankshaft=m_shaft,
    final m_crank=m_cra,
    final m_piston=m_pis);
  parameter Modelica.SIunits.Length l_conrod(displayUnit="mm")
    "Length of connection rod";
  parameter Modelica.SIunits.Length stroke(displayUnit="mm") "Stroke length";
  parameter Modelica.SIunits.Length bore(displayUnit="mm") "Cylinder bore";
  parameter Modelica.SIunits.Volume V_tdc(displayUnit="ml")
    "ml=cm^3 - clearance volume";
  parameter Modelica.SIunits.Length r_shaft(displayUnit="mm") = 0.02
    "Radius of crank shaft";
  parameter Modelica.SIunits.Mass m_con(displayUnit="kg") = 0.35
    "Mass of connection rod";
  parameter Modelica.SIunits.Mass m_shaft(displayUnit="kg") = 0.3
    "Mass of crank shaft";
  parameter Modelica.SIunits.Mass m_cra(displayUnit="kg") = 0.1
    "Mass of crank arm";
  parameter Modelica.SIunits.Mass m_pis(displayUnit="kg") = 0.35
    "Mass of piston";

  annotation (Documentation(info="<html>
<p>This is a simplified geometry definition assuming no piston pin offset. This allows us to define the geometry using the well-established quantities stroke and bore. </p>
</html>"));
end SimpleGeometry;
