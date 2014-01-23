within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model SmoothedInit
  "SmoothedInit: Smooth transitions between the different flow regimes including an initialisation and a filtering"
  extends BaseClasses.PartialConvectiveSmoothed;

  parameter Modelica.SIunits.Time t_start=5 "Start of initialization"
    annotation(Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Time t_init=5 "Duration of initialization"
    annotation(Dialog(tab="Initialization"));
  Modelica.SIunits.CoefficientOfHeatTransfer U_initialized;
  Real initialized(min=0,max=1);

  parameter Real max_dUdt(unit="W/(m2.K.s)") = 600 "maximum change in HTC"
                             annotation(Dialog(group="Correlations"));

  Real filterConstant(unit="s") = 1;
  Modelica.SIunits.CoefficientOfHeatTransfer U_filtered;

  Modelica.SIunits.CoefficientOfHeatTransfer U_cor_l;
  Modelica.SIunits.CoefficientOfHeatTransfer U_cor_tp;
  Modelica.SIunits.CoefficientOfHeatTransfer U_cor_v;

  replaceable model LiquidCorrelation =
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
  constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient liquid side"
                                                     annotation(Dialog(group="Correlations"),choicesAllMatching=true);

   replaceable model TwoPhaseCorrelation =
     ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialTwoPhaseCorrelation
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialTwoPhaseCorrelation
    "correlated heat transfer coefficient two phase side"
                                                      annotation(Dialog(group="Correlations"),choicesAllMatching=true);

  replaceable model VapourCorrelation =
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
     constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient vapour side" annotation (Dialog(group=
         "Correlations"), choicesAllMatching=true);

  LiquidCorrelation   liquidCorrelation(  redeclare final package Medium = Medium, state = FluidState[1], m_dot = M_dot, q_dot = q_dot[1]);
  TwoPhaseCorrelation twoPhaseCorrelation(redeclare final package Medium = Medium, state = FluidState[1], m_dot = M_dot, q_dot = q_dot[1]);
  VapourCorrelation   vapourCorrelation(  redeclare final package Medium = Medium, state = FluidState[1], m_dot = M_dot, q_dot = q_dot[1]);

  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor_LTP;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor_TPV;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor;

initial algorithm
  U_filtered := U_nom;

equation
  U_cor_l  = liquidCorrelation.U;
  U_cor_tp = twoPhaseCorrelation.U;
  U_cor_v  = vapourCorrelation.U;

  U_cor_LTP = (1-LTP)*U_cor_l  + LTP*U_cor_tp;
  U_cor_TPV = (1-TPV)*U_cor_tp + TPV*U_cor_v;
  U_cor     = (1-LV) *U_cor_LTP+ LV* U_cor_TPV;

  initialized     = ThermoCycle.Functions.transition_factor(start=t_start, stop=t_start+t_init, position=time);
  U_initialized   = (1-initialized)*U_nom*massFlowFactor + initialized*U_cor;
  der(U_filtered) = max(-max_dUdt,min(max_dUdt,(U_initialized-U_filtered)/filterConstant));

  for i in 1:n loop
    U[i] = U_filtered;
  end for;
end SmoothedInit;
