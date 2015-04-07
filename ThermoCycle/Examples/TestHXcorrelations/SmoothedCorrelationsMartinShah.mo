within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsMartinShah
  "Martin PHX in single-phase and Shah for evaporation"
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.SmoothedInit (
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Martin,
          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Martin,
          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations.Shah_Evaporation
              (
              d_hyd(displayUnit="m") = 0.002*2,
              A_cro=0.002*0.1,
              redeclare model LiquidCorrelation =
                  ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter
                  (d_hyd(displayUnit="m") = 0.002*2, A_cro=0.002*0.1)))));

end SmoothedCorrelationsMartinShah;
