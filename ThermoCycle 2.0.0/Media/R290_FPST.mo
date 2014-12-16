within ThermoCycle.Media;
package R290_FPST "Propane properties using the StanMix library of FluidProp"
  extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
  mediumName="TestMedium",
  libraryName="FluidProp.StanMix",
  substanceNames={"propane"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end R290_FPST;
