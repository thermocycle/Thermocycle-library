within ThermoCycle.Media;
package Air_CP "Air- Coolprop TransportProp, TTSE - TC"
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "Air",
    substanceNames = {"Air|debug=0|calc_transport=1|enable_TTSE=1"},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end Air_CP;
