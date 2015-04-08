within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsLimited
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.SmoothedInit (
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Constant
              (U_c=tester.U_nom_l),
          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations.Constant
              (U_c=tester.U_nom_tp),
          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Constant
              (U_c=tester.U_nom_v),
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          max_dUdt=5000)));
end SmoothedCorrelationsLimited;
