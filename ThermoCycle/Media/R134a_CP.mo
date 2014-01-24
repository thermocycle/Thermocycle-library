within ThermoCycle.Media;
package R134a_CP "R134A - Coolprop TransportProp, TTSE - TC"
  extends CoolProp2Modelica.Interfaces.CoolPropMedium(
    mediumName = "R134a",
    substanceNames = {"R134a|debug=0|calc_transport=1|enable_TTSE=1"},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end R134a_CP;
