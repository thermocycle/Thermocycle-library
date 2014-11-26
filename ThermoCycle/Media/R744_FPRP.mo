within ThermoCycle.Media;
package R744_FPRP "Carbon-Dioxide from Refprop via FluidProp"
  extends ExternalMedia.Media.FluidPropMedium(
  mediumName="Carbon Dioxide",
  libraryName="FluidProp.RefProp",
  substanceNames={"CO2"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end R744_FPRP;
