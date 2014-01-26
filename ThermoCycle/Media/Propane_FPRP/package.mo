within ThermoCycle.Media;
package Propane_FPRP "Propane - FluidProp.RefProp - TC"
  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName="TestMedium",
    libraryName="FluidProp.RefProp",
    substanceName="propane",
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);


  annotation ();
end Propane_FPRP;
