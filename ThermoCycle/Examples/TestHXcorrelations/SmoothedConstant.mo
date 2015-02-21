within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedConstant
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Smoothed));
end SmoothedConstant;
