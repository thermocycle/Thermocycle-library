within ThermoCycle.Media;
package PropaneFP "Package using REFPROP"
  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName="TestMedium",
    libraryName="FluidProp.RefProp",
    substanceName="propane",
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);


  annotation ();
end PropaneFP;
