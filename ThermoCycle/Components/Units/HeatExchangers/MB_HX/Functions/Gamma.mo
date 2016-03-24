within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Functions;
function Gamma
input Real hh;
input Real rho_l;
input Real rho_v;
input Real h_l;
input Real h_v;
output Real Gamma;
algorithm
Gamma:= max(Modelica.Constants.small,rho_l*(hh -h_l) + rho_v*(h_v - h_l));
end Gamma;
