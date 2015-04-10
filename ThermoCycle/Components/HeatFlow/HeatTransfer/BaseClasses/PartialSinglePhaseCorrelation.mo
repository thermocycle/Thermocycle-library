within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses;
partial model PartialSinglePhaseCorrelation
  "Base class for single-phase heat transfer correlations"
    extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferCorrelation;

  input Medium.ThermodynamicState state "Thermodynamic state";
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation(Dialog(tab="Internal Interface",enable=false));

annotation(Documentation(info="<html>

<p><big> The model <b>PartialSinglePhaseCorrelation</b> is the basic model
 for the calculation of heat transfer coefficient for a fluid in single-phase.</p> 
 <p><big> In order to complete the model - from <FONT COLOR=blue>partial model</FONT>  to <FONT COLOR=blue> model</FONT> -
 one equation calculating the heat transfer coefficient needs to be provided.</p>
 <p></p>
</html>"));
end PartialSinglePhaseCorrelation;
