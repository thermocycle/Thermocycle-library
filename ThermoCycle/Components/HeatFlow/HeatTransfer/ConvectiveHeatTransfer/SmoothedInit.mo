within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model SmoothedInit
  "SmoothedInit: Smooth transitions between the different flow regimes including an initialisation"
  extends BaseClasses.PartialConvectiveSmoothed;

  parameter Modelica.SIunits.Time t_start=5 "Start of initialization"
    annotation(Dialog(tab="Initialization"));

  parameter Modelica.SIunits.Time t_init=5 "Duration of initialization"
    annotation(Dialog(tab="Initialization"));

//   parameter Modelica.SIunits.CoefficientOfHeatTransfer U_cor_l
//     "correlated heat transfer coefficient liquid side" annotation(Dialog(group="Correlations"));
   parameter Modelica.SIunits.CoefficientOfHeatTransfer U_cor_tp
    "correlated heat transfer coefficient two phase side"  annotation(Dialog(group="Correlations"));
//   parameter Modelica.SIunits.CoefficientOfHeatTransfer U_cor_v = 600
//     "correlated heat transfer coefficient vapor side" annotation(Dialog(group="Correlations"));

  Modelica.SIunits.CoefficientOfHeatTransfer U_cor_l;
  Modelica.SIunits.CoefficientOfHeatTransfer U_cor_v = 600;

  replaceable model LiquidCorrelation =
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
  constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient liquid side"
                                                     annotation(Dialog(group="Correlations"),choicesAllMatching=true);
//   replaceable model VapourCorrelation =
//       ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
//   constrainedby
//     ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
//     "correlated heat transfer coefficient vapour side"
//                                                      annotation(Dialog(group="Correlations"),choicesAllMatching=true);

  LiquidCorrelation liquidCorrelation(redeclare final package Medium = Medium, state = FluidState[1], m_dot = M_dot);
//  VapourCorrelation vapourCorrelation(redeclare final package Medium = Medium, state = FluidState[1], m_dot = M_dot);

  Real initialised(min=0,max=1);
  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor_LTP;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor_TPV;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor;

algorithm
  U_cor_l  := max(1,min(10000,liquidCorrelation.U));
  //U_cor_tp := max(50,min(10000,liquidCorrelation.U));
  //U_cor_v  := max(1,min(10000,vapourCorrelation.U));

equation
  U_cor_LTP = (1-LTP)*U_cor_l  + LTP*U_cor_tp;
  U_cor_TPV = (1-TPV)*U_cor_tp + TPV*U_cor_v;
  U_cor     = (1-LV) *U_cor_LTP+ LV* U_cor_TPV;

  initialised = ThermoCycle.Functions.transition_factor(start=t_start, stop=t_start+t_init, position=time);

  for i in 1:n loop
    U[i] = (1-initialised)*U_nom + initialised*U_cor;
  end for;
end SmoothedInit;
