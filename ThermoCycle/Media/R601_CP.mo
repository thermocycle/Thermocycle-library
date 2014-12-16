within ThermoCycle.Media;
package R601_CP "R601, n-Pentane properties using CoolProp"
  extends ExternalMedia.Media.CoolPropMedium(
  mediumName="n-Pentane",
  substanceNames={"n-Pentane"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end R601_CP;
