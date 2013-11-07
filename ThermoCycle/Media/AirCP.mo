within ThermoCycle.Media;
package AirCP "Air from CoolProp"
  extends CoolProp2Modelica.Interfaces.CoolPropMedium(
    mediumName = "Air",
    substanceNames = {"Air|debug=0|calc_transport=1|enable_TTSE=1"},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end AirCP;
