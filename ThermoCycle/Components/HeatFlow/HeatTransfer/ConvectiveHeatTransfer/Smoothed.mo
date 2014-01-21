within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model Smoothed
  "Smoothed: Smooth transitions between the different flow regimes"
  extends BaseClasses.PartialConvectiveSmoothed;
equation
  for i in 1:n loop
    U[i] = U_nom * massFlowFactor;
  end for;
end Smoothed;
