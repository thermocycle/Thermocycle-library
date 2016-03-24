within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Interfaces;
connector MbIn
 // parameter Integer n = 1;
  Modelica.SIunits.Temperature T;
 flow Modelica.SIunits.Power Q_flow;
 input Modelica.SIunits.Length ll;
 input Real Cdot;
end MbIn;
