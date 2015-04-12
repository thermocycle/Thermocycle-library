within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsMartinCooper "Martin (1p) and Cooper (2p)"
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.SmoothedInit (
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Martin2010
              (a_hat = a_hat, phi = phi, Lambda = Lambda, B_p = B_p),
          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Martin2010
              (a_hat = a_hat, phi = phi, Lambda = Lambda, B_p = B_p),
          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations.Cooper1984
              (C=1.0))));

end SmoothedCorrelationsMartinCooper;
