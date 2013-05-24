within ThermoCycle.Media;
package PropaneCP "Package using REFPROP"
  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName="TestMedium",
    libraryName="CoolProp",
    substanceName="propane",
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end PropaneCP;
