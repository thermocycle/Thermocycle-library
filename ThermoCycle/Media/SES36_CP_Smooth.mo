within ThermoCycle.Media;
package SES36_CP_Smooth "SES36 -  CoolProp - rho smooth - TC"
    extends CoolProp2Modelica.Interfaces.CoolPropMedium(
  mediumName="SES36",
  substanceName="SES36|rho_smoothing_xend=0.1|enable_TTSE=1",
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end SES36_CP_Smooth;
