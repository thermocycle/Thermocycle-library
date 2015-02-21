within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsMartinGunger
  "Martin PHX in single-phase and Gungor Winterton in two-phase"
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SmoothedInit
          (
          filterConstant=0,
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          max_dUdt=0,
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.Martin,
          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.Martin,
          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations.GungorWinterton87
              (d_hyd(displayUnit="mm") = 0.0065, redeclare model
                LiquidCorrelation =
                  ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.DittusBoelter
                  (d_hyd(displayUnit="mm") = 0.0065)))));

end SmoothedCorrelationsMartinGunger;
