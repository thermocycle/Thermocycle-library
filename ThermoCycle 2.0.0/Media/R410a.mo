within ThermoCycle.Media;
package R410a "R410a from CoolProp"
extends ExternalMedia.Media.CoolPropMedium(
  mediumName = "R410a",
  substanceNames = {"R410a|rho_smoothing_xend=0.1|enable_TTSE=1"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end R410a;
