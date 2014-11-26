within ThermoCycle.Media;
package R410a_debug "R410a, properties using Refprop via CoolProp"
  extends ExternalMedia.Media.CoolPropMedium(
  mediumName="R410a",
  substanceNames={"REFPROP-MIX:R32[0.697615]&R125[0.302385]|debug=1"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end R410a_debug;
