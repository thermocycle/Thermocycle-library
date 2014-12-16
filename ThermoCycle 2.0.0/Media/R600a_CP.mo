within ThermoCycle.Media;
package R600a_CP "R600a, Isobutane properties using CoolProp"
  extends ExternalMedia.Media.CoolPropMedium(
  mediumName="Isobutane",
  substanceNames={"IsoButane"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end R600a_CP;
