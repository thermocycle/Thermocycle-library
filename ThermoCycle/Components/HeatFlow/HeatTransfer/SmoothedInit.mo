within ThermoCycle.Components.HeatFlow.HeatTransfer;
model SmoothedInit
  "SmoothedInit: Smooth transitions between the different zones including an initialisation and a filtering"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferSmoothed(
     massFlowExp=0.0,
  redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialTwoPhaseMedium
  constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium);

  parameter Modelica.SIunits.Time t_start=5 "Start of initialization"
    annotation(Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Time t_init=5 "Duration of initialization"
    annotation(Dialog(tab="Initialization"));

  parameter Modelica.SIunits.Time filterConstant(min=1e-8) = 1e-8
    "Integration time of filter, 1e-8=disabled"
                               annotation(Dialog(group="Correlations"));

  parameter Real max_dUdt(unit="W/(m2.K.s)") = 0
    "maximum change in HTC, 0=disabled, experimental!"
                             annotation(Dialog(group="Correlations"),enabled=(filterConstant>0));

  Modelica.SIunits.CoefficientOfHeatTransfer U_limited;
  Modelica.SIunits.CoefficientOfHeatTransfer U_filtered;
  Modelica.SIunits.CoefficientOfHeatTransfer U_initialized;
  Real initialized(min=0,max=1);

  Modelica.SIunits.CoefficientOfHeatTransfer U_cor_l;
  Modelica.SIunits.CoefficientOfHeatTransfer U_cor_tp;
  Modelica.SIunits.CoefficientOfHeatTransfer U_cor_v;

  replaceable model LiquidCorrelation =
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
  constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient liquid side"
                                                     annotation(Dialog(group="Correlations"),choicesAllMatching=true);

   replaceable model TwoPhaseCorrelation =
     ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation
    "correlated heat transfer coefficient two phase side"
                                                      annotation(Dialog(group="Correlations"),choicesAllMatching=true);

  replaceable model VapourCorrelation =
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
     constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient vapour side" annotation (Dialog(group=
         "Correlations"), choicesAllMatching=true);

  LiquidCorrelation   liquidCorrelation(  redeclare final package Medium = Medium, state = state_L,  m_dot = M_dot, q_dot = q_dot[1]);
  TwoPhaseCorrelation twoPhaseCorrelation(redeclare final package Medium = Medium, state = state_TP, m_dot = M_dot, q_dot = q_dot[1]);
  VapourCorrelation   vapourCorrelation(  redeclare final package Medium = Medium, state = state_V,  m_dot = M_dot, q_dot = q_dot[1]);

  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor_LTP;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor_TPV;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_cor;

  //Define filtered states to avoid spikes at phase boundary
  Medium.ThermodynamicState state;
  Medium.ThermodynamicState state_L;
  Medium.ThermodynamicState state_TP;
  Medium.ThermodynamicState state_V "the different states";

  Medium.SpecificEnthalpy h_bub_TP;
  Medium.SpecificEnthalpy h_dew_TP;
  Medium.SpecificEnthalpy h_bub_L;
  Medium.SpecificEnthalpy h_dew_V;
  Medium.SpecificEnthalpy delta_h;
  Medium.SpecificEnthalpy h_bub;
  Medium.SpecificEnthalpy h_dew "Changed bubble and dew state enthalpies";
  Medium.AbsolutePressure p;
  Medium.SpecificEnthalpy h;
  Medium.SpecificEnthalpy h_L;
  Medium.SpecificEnthalpy h_V;
  Medium.SpecificEnthalpy h_TP;
  Real x_L,x_LTP,x_TPV,x_V "Vapor quality";

  Real dUdt_limited;

initial algorithm
  U_filtered := U_nom;
  U_limited  := U_filtered;

equation
//   x_L   = 0-max(smoothingRange/divisor,10*Modelica.Constants.small);
//   x_LTP = 0+max(smoothingRange/divisor,10*Modelica.Constants.small);
//   x_TPV = 1-max(smoothingRange/divisor,10*Modelica.Constants.small);
//   x_V   = 1+max(smoothingRange/divisor,10*Modelica.Constants.small);

  state    = FluidState[1];
  p        = Medium.pressure(state);
  h        = Medium.specificEnthalpy(state);

  h_bub    = Medium.bubbleEnthalpy(Medium.setSat_p(p));
  h_dew    = Medium.dewEnthalpy(   Medium.setSat_p(p));
  delta_h  = h_dew-h_bub;

  h_bub_L  = h_bub + x_L  *delta_h;
  h_bub_TP = h_bub + x_LTP*delta_h;
  h_dew_TP = h_bub + x_TPV*delta_h;
  h_dew_V  = h_bub + x_V  *delta_h;

  h_L      = min(h,h_bub_L);
  h_TP     = max(h_bub_TP,min(h_dew_TP, h));
  h_V      = max(h,h_dew_V);

  if forcePhase == 0 then
    assert(abs(delta_h)>0.1,"Cannot determine the phase if bubble and dew enthalpy are equal");
    state_L  = Medium.setState_phX(p=p,h=h_L);
    state_TP = Medium.setState_phX(p=p,h=h_TP);
    state_V  = Medium.setState_phX(p=p,h=h_V);
  else // use enthalpy directly
    state_L  = Medium.setState_phX(p=p,h=h);
    state_TP = state_L;
    state_V  = state_L;
  end if;

  U_cor_l  = liquidCorrelation.U;
  U_cor_tp = twoPhaseCorrelation.U;
  U_cor_v  = vapourCorrelation.U;

  U_cor_LTP = (1-LTP)*U_cor_l + LTP*U_cor_tp;
  U_cor_TPV = (1-TPV)*U_cor_tp + TPV*U_cor_v;
  U_cor     = (1-LV) *U_cor_LTP+ LV* U_cor_TPV;

  initialized     = ThermoCycle.Functions.transition_factor(start=t_start, stop=t_start+t_init, position=time);
  U_initialized   = (1-initialized)*U_nom*massFlowFactor + initialized*U_cor;

  der(U_filtered) = (U_initialized-U_filtered)/filterConstant;

   if max_dUdt<=0 then
     der(U_limited) = der(U_filtered);
     dUdt_limited = der(U_limited);
   else
     dUdt_limited = (ThermoCycle.Functions.transition_factor(start=-max_dUdt, stop=max_dUdt, position=(U_filtered-U_limited)/1e-5)-0.5)*2;
     der(U_limited) = dUdt_limited*max_dUdt;
     //der(U_limited) = ThermoCycle.Functions.transition_factor(-max_dUdt,max_dUdt,abs(der(U_filtered))) * sign(der(U_filtered)) * max_dUdt;
     //der(U_limited) = smooth(0, noEvent(if dUdt_filtered > max_dUdt then max_dUdt else if dUdt_filtered < -max_dUdt then -max_dUdt else dUdt_filtered));
   end if;

  for i in 1:n loop
    U[i] = U_limited;
    q_dot[i] = U[i]*(thermalPortL[i].T - T_fluid[i]);
  end for;

 annotation(Documentation(info="<html>
<p>The model <b>SmoothedInit</b> extends the partial model <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferSmoothed\">PartialHeatTransferSmoothed</a> and allows the user to choose the correlation to calculate the heat transfer coefficient in the different zones: </p>
<p><ul>
<li>liquidCorrelation: correlation for the liquid zone. The user can choose between the ones listed in <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations\">SinglePhaseCorrelations</a> </li>
<li>twoPhaseCorrelation : correlation for the two-phase zone. The user can choose between the ones listed in <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations\">TwoPhaseCorrelations</a> </li>
<li>vaporCorrelation: correlation for the vapor zone.The user can choose between the ones listed in <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations\">SinglePhaseCorrelations</a> </li>
</ul></p>
<p>In order to increase the robustness of the model an initialization option is available:the heat transfer coefficient value is initialized with the nominal value defined by the user U_nom, and after a certain time (t_init - see below) the value is smoothed to the one calculated with the correlations previusly defined by the user.</p>
<p>In cases of fluctuating pressures and chattering, applying a first order filter to the change in heat transfer coefficient increases stability, set the parameter filterConstant &GT; 0 to activate it.</p>
<p>A limiter for the maximum change of the heat transfer coefficient with respect to time can be activated by setting the parameter max_dUdt &GT;=0 in the general tab. </p>
<p>In the <b>Initialization</b> tab the following options are availabe: </p>
<li><ul>
<li>t_start: start time for <i>Initialization</i> </li>
<li>t_init: duration of the <i>Initialization</i> </li>
</ul></li>
</ul></p>
</html>"));
end SmoothedInit;
