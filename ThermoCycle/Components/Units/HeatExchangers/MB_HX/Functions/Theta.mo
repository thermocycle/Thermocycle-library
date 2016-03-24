within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Functions;
function Theta
  input Real hh;
  input Real h_l;
  input Real drdp_l;
  input Real rho_l;
  input Real dhdp_l;
  input Real h_v;
  input Real drdp_v;
  input Real rho_v;
  input Real dhdp_v;
  output Real Theta;
algorithm
  Theta:= max(Modelica.Constants.small,(hh - h_l)*drdp_l - rho_l*dhdp_l +(h_v - hh)*drdp_v +rho_v*dhdp_v);
end Theta;
