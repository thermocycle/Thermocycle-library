within ThermoCycle.Media;
package SolkathermSmooth
  "Solkatherm properties using CoolProp with Smooth density and TTSE"
  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName="SES36",
    libraryName="CoolProp",
    substanceName="SES36|rho_smoothing_xend=0.1|enable_TTSE=1",
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);

  annotation ();
end SolkathermSmooth;
