within ThermoCycle.Components.HeatFlow.HeatTransfer;
model Constant "Constant: Constant heat transfer coefficient"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones;
  Modelica.SIunits.CoefficientOfHeatTransfer U_0 "heat transfer coefficient";
equation
  U_0 = (Unom_l + Unom_tp + Unom_v)/3;
  q_dot = {U_0*(thermalPortL[i].T - T_fluid[i]) for i in 1:n};

  annotation(Documentation(info="<html>
<p><big> The model <b>Constant</b> compute a constant heat transfer coefficient as an average between the liquid the two-phase
 and the vapor term. </p>
<p></p>
</html>"));
end Constant;
