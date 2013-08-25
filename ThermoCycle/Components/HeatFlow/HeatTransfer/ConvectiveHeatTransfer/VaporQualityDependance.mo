within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model VaporQualityDependance

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation;
constant Real width=0.1;
Modelica.SIunits.CoefficientOfHeatTransfer[n] U;

equation
  for i in 1:n loop
    U[i] = smooth(1,noEvent(
if x < -width/2
  then Unom_l
 elseif
       x < width/2
  then Unom_l + (Unom_tp - Unom_l)*(1 + sin(x*Modelica.Constants.pi/width))/2
 elseif
       x < 1 - width/2
  then Unom_tp
 elseif
       x < 1 + width/2
  then Unom_tp + (Unom_v - Unom_tp)*(1 + sin((x - 1)*Modelica.Constants.pi
    /width))/2
 else
     Unom_v));

  /* Insert Qflow and T */
q_dot = {U[i]*(thermalPortL[i].T - T_fluid[i])};
 end for;
end VaporQualityDependance;
