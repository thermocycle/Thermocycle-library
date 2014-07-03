within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses;
record BaseGeometry
  "Base class to define the geometry of a reciprocating machine"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Length d_ppin(displayUnit="mm")
    "piston pin offset";
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

  InputObject piston(final kind = 1, final width = 0, dens(displayUnit="kg/m3") = 0.5*7700)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  InputObject conrod(final kind = 2, final radius = 0,  dens(displayUnit="kg/m3") = 7700)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  InputObject crankArm(final kind = 2, final radius = 0,  dens(displayUnit="kg/m3") = 7700)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  InputObject crankShaft(final kind = 1, final width = 0,  dens(displayUnit="kg/m3") = 7700)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Partial Geometry</font></h4></p>
<p>Definition of basic geometry for reciprocating machines. All lengths and volumes are calculated</p>
</html>"));
end BaseGeometry;
