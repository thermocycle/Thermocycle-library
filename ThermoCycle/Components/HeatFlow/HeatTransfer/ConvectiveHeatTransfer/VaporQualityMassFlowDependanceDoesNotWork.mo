within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model VaporQualityMassFlowDependanceDoesNotWork
  import Components;
extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation;
constant Real width=0.1;
Modelica.SIunits.CoefficientOfHeatTransfer[n] U;
equation
  for i in 1:n loop
    U[i] = smooth(1,noEvent(
if x < -width/2
  then Unom_l*(M_dot/Mdotnom)^0.8
 elseif
       x < width/2
  then (Unom_l + (Unom_tp - Unom_l)*(1 + sin(x*Modelica.Constants.pi/width))/2)*(M_dot/Mdotnom)^0.8
 elseif
       x < 1 - width/2
  then Unom_tp*(M_dot/Mdotnom)^0.8
 elseif
       x < 1 + width/2
  then (Unom_tp + (Unom_v - Unom_tp)*(1 + sin((x - 1)*Modelica.Constants.pi)*(M_dot/Mdotnom)^0.8
    /width))/2
 else
     Unom_v));

  /* Insert Qflow and T */
q_dot = {U[i]*(thermalPortL[i].T - T_fluid[i])};
 end for;
end VaporQualityMassFlowDependanceDoesNotWork;
