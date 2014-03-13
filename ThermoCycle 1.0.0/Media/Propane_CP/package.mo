within ThermoCycle.Media;
package Propane_CP "Propane - CoolProp - TC"
  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName="TestMedium",
    libraryName="CoolProp",
    substanceName="propane",
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);


  annotation ();
end Propane_CP;
