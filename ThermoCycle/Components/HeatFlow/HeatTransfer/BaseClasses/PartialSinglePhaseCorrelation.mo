within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses;
partial model PartialSinglePhaseCorrelation
  "Base class for single phase heat transfer correlations"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation(Dialog(tab="Internal Interface",enable=false));

  input Medium.ThermodynamicState state "Thermodynamic state";
  input Modelica.SIunits.MassFlowRate m_dot "Inlet massflow";
  input Modelica.SIunits.HeatFlux q_dot "Heat flow rate per area [W/m2]";

  Modelica.SIunits.CoefficientOfHeatTransfer U;
annotation(Documentation(info="<html>

<p><big> The model <b>PartialSinglePhaseCorrelation </b> is the basic model
 for the calculation of heat transfer coefficient for a fluid in single phase.</p> 
<p><big> In order to complete the model - from <FONT COLOR=blue>partial model</FONT>  to <FONT COLOR=blue> model</FONT> -
 one equation definif the value of the Coefficient of heat transfer U has to be defined.</p> 

 <p></p>
</html>"));
end PartialSinglePhaseCorrelation;
