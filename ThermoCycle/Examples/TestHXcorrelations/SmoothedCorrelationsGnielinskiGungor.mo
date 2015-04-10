within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsGnielinskiGungor
  "Gnielinski pipe in single-phase and simplified Gungor Winterton in two-phase"
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.SmoothedInit (
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Gnielinski2010
              (
              d_i(displayUnit="mm") = 0.002*2,
              l=0.2,
              A_cro=0.002*0.1),
          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations.GungorWinterton87
              (
              d_hyd(displayUnit="mm") = 0.002*2,
              A_cro=0.002*0.1,
              redeclare model LiquidCorrelation =
                  ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter1930
                  (d_hyd(displayUnit="mm") = 0.002*2, A_cro=0.002*0.1)),
          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Gnielinski2010
              (
              d_i(displayUnit="mm") = 0.002*2,
              l=0.2,
              A_cro=0.002*0.1))));

end SmoothedCorrelationsGnielinskiGungor;
