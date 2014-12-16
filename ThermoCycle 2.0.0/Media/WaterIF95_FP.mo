within ThermoCycle.Media;
package WaterIF95_FP
  extends ExternalMedia.Media.FluidPropMedium(
  mediumName="Water",
  libraryName="FluidProp.RefProp",
  substanceNames={"H2O"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end WaterIF95_FP;
