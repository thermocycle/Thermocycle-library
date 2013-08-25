within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model MassFlowDependence

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation;
Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal heat transfer coefficient- Average of liquid two phase and vapor";
Modelica.SIunits.CoefficientOfHeatTransfer[n] U "Heat transfer coefficient";

equation
  for i in 1:n loop
    Unom = (Unom_l + Unom_tp + Unom_v)/3;
    U[i] = Unom*noEvent(abs((M_dot/Mdotnom)^0.8));
  /* Insert Qflow and T */
q_dot = {U[i]*(thermalPortL[i].T - T_fluid[i])};
 end for;
end MassFlowDependence;
