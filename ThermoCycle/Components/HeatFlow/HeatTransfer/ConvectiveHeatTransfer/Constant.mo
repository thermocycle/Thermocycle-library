within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model Constant "ConstantHeatTransfer: Constant heat transfer coefficient"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation;
  Modelica.SIunits.CoefficientOfHeatTransfer U_0 "heat transfer coefficient";
equation
  U_0 = (Unom_l + Unom_tp + Unom_v)/3;
  q_dot = {U_0*(thermalPortL[i].T - T_fluid[i]) for i in 1:n};

  annotation(Documentation(info="<html>
<p>Simple heat transfer correlation with constant heat transfer coefficient. </p>
<p>Taken from: Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer</p>
</html>"));
end Constant;
