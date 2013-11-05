within ThermoCycle.Media;
package Solkatherm_Der_Smooth
  "Solkatherm properties using CoolProp Smooth Derivative of density"
  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName="SES36",
    libraryName="CoolProp",
    substanceName="SES36|twophase_derivsmoothing_xend=0.05",
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end Solkatherm_Der_Smooth;
