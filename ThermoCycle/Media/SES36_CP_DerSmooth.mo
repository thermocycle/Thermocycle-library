within ThermoCycle.Media;
package SES36_CP_DerSmooth "SES36 -  CoolProp - DerSmooth - TC"
    extends ExternalMedia.Media.CoolPropMedium(
  mediumName="SES36",
  substanceNames={"SES36|twophase_derivsmoothing_xend=0.05"},
  ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
end SES36_CP_DerSmooth;
