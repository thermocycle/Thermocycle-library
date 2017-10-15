within ThermoCycle.Interfaces.Fluid;
connector Flange "Flange connector for water/steam flows"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  flow Medium.MassFlowRate m_flow
    "Mass flow rate from the connection point into the component";
  Medium.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream Medium.SpecificEnthalpy h_outflow
    "Specific thermodynamic enthalpy close to the connection point if m_flow < 0";
 stream Medium.MassFraction Xi_outflow[Medium.nXi]
    "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
  stream Medium.ExtraProperty C_outflow[Medium.nC]
    "Properties c_i/m close to the connection point if m_flow < 0";
  annotation (Documentation(info="<HTML>.
</HTML>",
      revisions="<html>
University of Li&egrave;ge, November 2012"),
    Diagram(graphics),
    Icon(graphics));
end Flange;
