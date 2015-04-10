within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsDittusCooper
  "A combination of the Dittus-Boelter equation for single phase and the Cooper evaporation correlation"
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.SmoothedInit (
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter1930
              (d_hyd(displayUnit="mm") = 0.002*2, A_cro=0.002*0.1),
          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations.Cooper_Evaporation,
          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter1930
              (d_hyd(displayUnit="mm") = 0.002*2, A_cro=0.002*0.1))));
end SmoothedCorrelationsDittusCooper;
