within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Interfaces;
connector MbOut

// parameter Integer n = 1;
  Modelica.SIunits.Temperature T;
 flow Modelica.SIunits.Power Q_flow;
 output Modelica.SIunits.Length ll;
 output Real Cdot;
end MbOut;
