within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses;
partial model PartialTwoPhaseCorrelation
  "Base class for two-phase heat transfer correlations"
    extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferCorrelation;

  input Medium.ThermodynamicState state "Thermodynamic state";
  replaceable package Medium =
      ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium                          constrainedby
    Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium in the component"
      annotation(Dialog(tab="Internal Interface",enable=false));

  Medium.ThermodynamicState bubbleState;
  Medium.ThermodynamicState bubbleState_TP "Thermodynamic state";
  Medium.ThermodynamicState dewState;
  Medium.ThermodynamicState dewState_TP "Thermodynamic state";
  Medium.ThermodynamicState filteredState "Thermodynamic state";
  Modelica.SIunits.QualityFactor x "Vapour quality";
  Real deltaX = 1e-5;

  Medium.SpecificEnthalpy h_bub_TP;
  Medium.SpecificEnthalpy h_dew_TP;
  Medium.SpecificEnthalpy h_bub_L;
  Medium.SpecificEnthalpy h_dew_V "Changed bubble and dew state enthalpies";
  Medium.AbsolutePressure p;

equation
  p           = Medium.pressure(state);
  bubbleState = Medium.setBubbleState(Medium.setSat_p(p));
  dewState    = Medium.setDewState(   Medium.setSat_p(p));
  h_bub_L     = Medium.specificEnthalpy(bubbleState);
  h_dew_V     = Medium.specificEnthalpy(   dewState);
  h_bub_TP       = h_bub_L + (0+deltaX)*(h_dew_V - h_bub_L);
  h_dew_TP       = h_bub_L + (1-deltaX)*(h_dew_V - h_bub_L);
  bubbleState_TP = Medium.setState_phX(p=p,h=h_bub_TP,phase=2);
  dewState_TP    = Medium.setState_phX(p=p,h=h_dew_TP,phase=2);

  // Filter the input to provide saturation conditions only.
  // Be careful, vapourQuality function is limited to 0<=x<=1
  if     (Medium.vapourQuality(state) < 0+deltaX) then
    filteredState =  bubbleState_TP;
  elseif (Medium.vapourQuality(state) > 1-deltaX) then
    filteredState =  dewState_TP;
  else
    filteredState =  state;
  end if;
  x =  Medium.vapourQuality(filteredState);
annotation(Documentation(info="<html>

<p><big> The model <b>PartialTwoPhaseCorrelation </b> is the basic model
 for the calculation of heat transfer coefficient for a fluid in two-phase.</p> 
 <p><big> In order to complete the model - from <FONT COLOR=blue>partial model</FONT>  to <FONT COLOR=blue> model</FONT> -
 one equation calculating the heat transfer coefficient needs to be provided.</p>
 <p></p>
</html>"));
end PartialTwoPhaseCorrelation;
