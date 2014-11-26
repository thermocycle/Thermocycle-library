within ThermoCycle.Media;
package R718_CP "R718, water IAPWS 95 properties using CoolProp"
  extends ExternalMedia.Media.CoolPropMedium(
  substanceNames={"Water"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end R718_CP;
