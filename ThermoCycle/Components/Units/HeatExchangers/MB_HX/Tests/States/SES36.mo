within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.States;
model SES36
replaceable package Medium =
      ThermoCycle.Media.SES36_CP                     constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
import Modelica.SIunits;

parameter SIunits.AbsolutePressure p_eva = 8E5;
parameter SIunits.Temperature T_su = 20 +273.15;
parameter Medium.ThermodynamicState State_su = Medium.setState_pT(p_eva,T_su);
equation

end SES36;
