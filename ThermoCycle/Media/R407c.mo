within ThermoCycle.Media;
package R407c "R407c from CoolProp"
  extends CoolProp2Modelica.Interfaces.CoolPropMedium(
    mediumName = "R407c",
    substanceNames = {"R407c"},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end R407c;
