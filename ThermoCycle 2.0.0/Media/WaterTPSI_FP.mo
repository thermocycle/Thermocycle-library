within ThermoCycle.Media;
package WaterTPSI_FP
  extends ExternalMedia.Media.FluidPropMedium(
  mediumName="Water",
  libraryName="FluidProp.TPSI",
  substanceNames={"H2O"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end WaterTPSI_FP;
