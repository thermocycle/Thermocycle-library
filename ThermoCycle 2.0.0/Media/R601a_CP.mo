within ThermoCycle.Media;
package R601a_CP "R601a, Isopentane properties using CoolProp"
  extends ExternalMedia.Media.CoolPropMedium(
  mediumName="Isopentane",
  substanceNames={"IsoPentane"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end R601a_CP;
