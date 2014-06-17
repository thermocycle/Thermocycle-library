within ThermoCycle.Examples.TestComponents;
model Test_Properties
replaceable package Medium = ThermoCycle.Media.R245fa_CP;

parameter Modelica.SIunits.Pressure P = 211000 "pressure in Pa";

parameter Modelica.SIunits.SpecificEnthalpy h = 245e3 "Enthalpy";

Modelica.SIunits.Temperature T;
equation

  T = Medium.temperature_ph(P,h);

end Test_Properties;
