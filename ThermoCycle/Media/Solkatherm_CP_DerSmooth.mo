within ThermoCycle.Media;
package Solkatherm_CP_DerSmooth
  "Solkatherm - Coolprop smooth density derivative - TC"
  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName="SES36",
    libraryName="CoolProp",
    substanceName="SES36|twophase_derivsmoothing_xend=0.05",
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end Solkatherm_CP_DerSmooth;
