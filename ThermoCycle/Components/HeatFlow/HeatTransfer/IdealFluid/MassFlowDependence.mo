within ThermoCycle.Components.HeatFlow.HeatTransfer.IdealFluid;
model MassFlowDependence

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones_IdealFluid;
input Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal heat transfer coefficient- Average of liquid two phase and vapor";
Modelica.SIunits.CoefficientOfHeatTransfer U "Heat transfer coefficient";

equation
    U = Unom*noEvent(abs(M_dot/Mdotnom)^0.8);
  /* Insert Qflow and T */
q_dot = U*(thermalPortL.T - T_fluid);
end MassFlowDependence;
