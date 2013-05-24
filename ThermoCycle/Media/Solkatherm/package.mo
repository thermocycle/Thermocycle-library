within ThermoCycle.Media;
package Solkatherm "Package using REFPROP"
  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName="SES36",
    libraryName="CoolProp",
    substanceName="SES36",
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end Solkatherm;
