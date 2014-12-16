within ThermoCycle.Media;
package LiBr_CP "Lithium bromide solution properties from CoolProp"
  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
  mediumName="LiBr",
  substanceNames={"LiBr|calc_transport=1"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.pTX);
end LiBr_CP;
