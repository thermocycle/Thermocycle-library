within ThermoCycle.Examples.TestComponents;
model Test_water
replaceable package Medium = CoolProp2Modelica.Media.WaterIF95_FP;

parameter Modelica.SIunits.Temperature T_su= 30 + 273.15;
parameter Modelica.SIunits.Temperature T_ex= 35 + 273.15;
parameter Modelica.SIunits.Pressure p = 1e5;

Modelica.SIunits.Density rho_su;
Modelica.SIunits.Density rho_ex;

equation
rho_su = Medium.density_pT(p,T_su);

rho_ex = Medium.density_pT(p,T_ex);

end Test_water;
