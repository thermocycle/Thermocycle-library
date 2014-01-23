within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations;
model Constant "Constant: Constant heat transfer coefficient"
  extends BaseClasses.PartialTwoPhaseCorrelation;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_c = 3000
    "Heat transfer coefficient";
equation
  U = U_c;
end Constant;
