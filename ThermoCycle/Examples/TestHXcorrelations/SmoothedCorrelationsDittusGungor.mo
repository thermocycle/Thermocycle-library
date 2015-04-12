within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsDittusGungor
  "Dittus-Boelter (1p) and Gungor-Winterton (2p)"
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.SmoothedInit (
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter1930
              (d_h=d_e, A_cro=A_cro),
          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations.GungorWinterton1987
              (
              d_h=d_e,
              A_cro=A_cro,
              redeclare model LiquidCorrelation =
                  ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter1930
                  (d_h=d_e, A_cro=A_cro)),
          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter1930
              (d_h=d_h, A_cro=A_cro))));
end SmoothedCorrelationsDittusGungor;
