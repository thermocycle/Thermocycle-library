within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations;
model Constant "Constant: Constant heat transfer coefficient"
  extends BaseClasses.PartialSinglePhaseCorrelation;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_c = 1000
    "Heat transfer coefficient";
equation
  U = U_c;
end Constant;
