within ThermoCycle.Interfaces.Fluid;
connector Flange_pT
  "Flange connector for single phase flows (p and T as state variables)"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  flow Medium.MassFlowRate m_flow
    "Mass flow rate from the connection point into the component";
  Medium.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream Medium.Temperature T_outflow
    "Temperature close to the connection point if m_flow < 0";
  stream Medium.MassFraction Xi_outflow[Medium.nXi]
    "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
  stream Medium.ExtraProperty C_outflow[Medium.nC]
    "Properties c_i/m close to the connection point if m_flow < 0";
  annotation (Documentation(info="<HTML>
  <p><big>The flange_pT considers pressure and temperature as state variables. The reason for this flange lies in the fact
   that most of incompressible fluids are defined with polynomials or tables which are exlicit in temperature. The use of this flange 
   to characterize the flow of incompressible fluids increases the computational efficiency.  
</HTML>",
      revisions="<html>
University of Li&egrave;ge, November 2012"),
    Diagram(graphics),
    Icon(graphics));
end Flange_pT;
