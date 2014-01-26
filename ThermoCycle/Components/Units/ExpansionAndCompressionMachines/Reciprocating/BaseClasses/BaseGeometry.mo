within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses;
partial record BaseGeometry
  "Base class to define the geometry of a reciprocating machine"
  parameter Modelica.SIunits.Length l_conrod(displayUnit="mm")
    "Length of connection rod";
  parameter Modelica.SIunits.Length d_ppin(displayUnit="mm")
    "piston pin offset";
  parameter Modelica.SIunits.Length r_crank(displayUnit="mm")
    "Radius of crank shaft";
  parameter Modelica.SIunits.Length r_piston(displayUnit="mm")
    "Outer radius of piston";
  parameter Modelica.SIunits.Volume V_tdc(displayUnit="ml")
    "ml=cm^3 - clearance volume";
  parameter Modelica.SIunits.Length h_piston(displayUnit="mm")
    "Height of piston";
  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Partial Geometry</font></h4></p>
<p>Definition of basic geometry for reciprocating machines. All lengths and volumes are calculate</p>
</html>"));
end BaseGeometry;
