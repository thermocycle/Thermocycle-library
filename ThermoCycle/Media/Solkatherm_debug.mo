within ThermoCycle.Media;
package Solkatherm_debug
  "Solkatherm properties using CoolProp with debug option"
  extends ExternalMedia.Media.CoolPropMedium(
  mediumName="SES36",
  substanceNames={"SES36|calc_transport=0|debug=1|enable_TTSE=1"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
    // calc_transport: set to one to compute the transport properties (not yet implemented in January 2013)
    // debug: integer from 0 to 10. 0 corresponds to no debut, while 10 is maximum debug.
    //        This outputs the different calls received by CoolProp in the console window
    // enable_TTSE: set to 1 to enable interpolated properties as a function of p-h
    //              Involves about 2 more seconds at initialization but integration is about 40 times faster

  annotation ();
end Solkatherm_debug;
