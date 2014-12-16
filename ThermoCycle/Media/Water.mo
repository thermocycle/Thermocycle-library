within ThermoCycle.Media;
package Water "Water - CoolProp - TC"
  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "water",
    substanceNames = {"water"},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end Water;
