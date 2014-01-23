within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses;
partial model PartialTwoPhaseCorrelation
  "Base class for two phase heat transfer correlations"

  replaceable package Medium = Modelica.Media.Interfaces.PartialTwoPhaseMedium constrainedby
    Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium in the component"
      annotation(Dialog(tab="Internal Interface",enable=false));

  input Medium.ThermodynamicState state "Thermodynamic state";
  input Modelica.SIunits.MassFlowRate m_dot "Inlet massflow";
  input Modelica.SIunits.HeatFlux q_dot "Heat flow rate per area [W/m2]";

  Modelica.SIunits.CoefficientOfHeatTransfer U;

  Medium.ThermodynamicState bubbleState "Thermodynamic state";
  Medium.ThermodynamicState dewState "Thermodynamic state";
  Medium.ThermodynamicState filteredState "Thermodynamic state";
  Modelica.SIunits.QualityFactor x "Vapour quality";
  Real deltaX = 1e-5;

algorithm
  bubbleState := Medium.setBubbleState(Medium.setSat_p(Medium.pressure(state)));
  dewState    := Medium.setDewState(   Medium.setSat_p(Medium.pressure(state)));
  // Filter the input to provide saturation conditions only
  if     (Medium.vapourQuality(state) <= 0.0) then
    filteredState := bubbleState;
  elseif (Medium.vapourQuality(state) >= 1.0) then
    filteredState := dewState;
  else
    filteredState := state;
  end if;
  x := max(deltaX,min(1-deltaX,Medium.vapourQuality(filteredState)));

end PartialTwoPhaseCorrelation;
