within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses;
partial record BaseGeometry
  "Base class to define the geometry of a reciprocating machine"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Length l_conrod(displayUnit="mm")
    "Length of connection rod";
  parameter Modelica.SIunits.Mass m_conrod(displayUnit="kg")
    "Mass of connection rod";
  parameter Modelica.SIunits.Length d_ppin(displayUnit="mm")
    "piston pin offset";
  parameter Modelica.SIunits.Length r_crank(displayUnit="mm")
    "Length of crank arm";
  parameter Modelica.SIunits.Mass m_crank(displayUnit="kg") "Mass of crank arm";
  parameter Modelica.SIunits.Length r_crankshaft(displayUnit="mm")
    "Radius of crank shaft";
  parameter Modelica.SIunits.Mass m_crankshaft(displayUnit="kg")
    "Mass of crank shaft";
  parameter Modelica.SIunits.Length r_piston(displayUnit="mm")
    "Outer radius of piston";
  parameter Modelica.SIunits.Length h_piston(displayUnit="mm")
    "Height of piston";
  parameter Modelica.SIunits.Mass m_piston(displayUnit="kg") "Mass of piston";
  parameter Modelica.SIunits.Volume V_tdc(displayUnit="ml")
    "ml=cm^3 - clearance volume";
  parameter Modelica.SIunits.Length d_inlet(displayUnit="mm")
    "Hydraulic diameter of inlet port";
  parameter Modelica.SIunits.Length d_outlet(displayUnit="mm")
    "Hydraulic diameter of outlet port";
  parameter Real zeta_inout "friction coefficient valve ports";
  parameter Modelica.SIunits.Length d_leak(displayUnit="mm")
    "Hydraulic diameter of leakage gap";
  parameter Real zeta_leak "friction coefficient leakage";

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Partial Geometry</font></h4></p>
<p>Definition of basic geometry for reciprocating machines. All lengths and volumes are calculate</p>
</html>"));
end BaseGeometry;
