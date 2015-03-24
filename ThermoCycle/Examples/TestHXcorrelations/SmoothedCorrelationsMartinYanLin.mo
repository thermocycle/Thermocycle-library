within ThermoCycle.Examples.TestHXcorrelations;
model SmoothedCorrelationsMartinYanLin
  "Martin PHX in single-phase and Yan & Lin evaporation"
  extends Test_HeatTransferTester(tester(redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SmoothedInit
          (
          t_start=Modelica.Constants.small,
          t_init=Modelica.Constants.small,
          redeclare model LiquidCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.Martin,

          redeclare model VapourCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.Martin,

          redeclare model TwoPhaseCorrelation =
              ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations.YanLin_Evaporation
              (d_hyd(displayUnit="m") = 2*0.002, A_cro=0.002*0.1))));

end SmoothedCorrelationsMartinYanLin;
