within ThermoCycle.Components.HeatFlow.HeatTransfer;
model MassFlowDependence

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones;
Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal heat transfer coefficient- Average of liquid two phase and vapor";
Modelica.SIunits.CoefficientOfHeatTransfer[n] U "Heat transfer coefficient";

equation
  for i in 1:n loop
    Unom = (Unom_l + Unom_tp + Unom_v)/3;
    U[i] = Unom*noEvent(0.00001 + abs(M_dot/Mdotnom)^0.8);
  /* Insert Qflow and T */
q_dot = {U[i]*(thermalPortL[i].T - T_fluid[i])};
  end for;
   annotation(Documentation(info="<html>
<p><big> The model <b>MassFlowDependance</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones\">PartialHeatTransferZones</a>
 and use the following equation to compute the heat transfer coefficient:
 
  <p>
<img src=\"modelica://ThermoCycle/Resources/Images/HTC_massFlow.png\">
</p>  
 
<p></p>
</html>"));
end MassFlowDependence;
