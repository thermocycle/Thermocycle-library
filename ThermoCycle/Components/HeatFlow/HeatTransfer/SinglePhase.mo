within ThermoCycle.Components.HeatFlow.HeatTransfer;
model SinglePhase "SinglePhase: Single Phase correlation"

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones;

replaceable model LiquidCorrelation =
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
  constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient liquid side"
                                                     annotation(Dialog(group="Correlations"),choicesAllMatching=true);

//Modelica.SIunits.CoefficientOfHeatTransfer Unom
//    "Nominal heat transfer coefficient- Average of liquid two phase and vapor";
Modelica.SIunits.CoefficientOfHeatTransfer[n] U "Heat transfer coefficient";

  LiquidCorrelation   liquidCorrelation(  redeclare final package Medium = Medium, state = FluidState[1],  m_dot = M_dot, q_dot = q_dot[1]);

equation
  for i in 1:n loop
    U[i] = liquidCorrelation.U;
  /* Insert Qflow and T */
q_dot = {U[i]*(thermalPortL[i].T - T_fluid[i])};
  end for;
   annotation(Documentation(info="<html>
<p><big> The model <b>MassFlowDependance</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones\">PartialHeatTransferZones</a>
 and use the following equation to compute the heat transfer coefficient:
 
  <p>
<img src=\"modelica://ThermoCycle/Resources/Images/HTC_massFlow.png\">
</p>  
 
<p></p>
</html>"));
end SinglePhase;
