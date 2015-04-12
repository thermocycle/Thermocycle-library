within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsGnielinskiShah "Gnielinski (1p) and Shah (2p)"
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.SmoothedInit (
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Gnielinski2010
              (
              d_h=d_e,
              A_cro=A_cro,
              l=0.2),
          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations.Shah1982
              (
              d_h=d_e,
              A_cro=A_cro,
              redeclare model LiquidCorrelation =
                  ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter1930
                  (d_h=d_h, A_cro=A_cro)),
          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Gnielinski2010
              (
              d_h=d_e,
              A_cro=A_cro,
              l=0.2))));

end SmoothedCorrelationsGnielinskiShah;
