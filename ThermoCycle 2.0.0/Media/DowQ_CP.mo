within ThermoCycle.Media;
package DowQ_CP "DowthermQ properties from CoolProp"
  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
  mediumName="DowQ",
  substanceNames={"DowQ|calc_transport=1"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.pT);
end DowQ_CP;
