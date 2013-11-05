within ThermoCycle.Media;
package R134aCP "R134a from CoolProp"
  extends CoolProp2Modelica.Interfaces.CoolPropMedium(
    mediumName = "R134a",
    substanceNames = {"R134a|debug=0|calc_transport=1|enable_TTSE=1"},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end R134aCP;
