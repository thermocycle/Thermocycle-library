within ThermoCycle.Media;
package R290_FPRP
  "Propane properties using Refprop through FluidProp (requires the full version of FluidProp)"
  extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
  mediumName="TestMedium",
  libraryName="FluidProp.RefProp",
  substanceNames={"propane"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end R290_FPRP;
