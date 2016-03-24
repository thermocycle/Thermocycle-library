within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.States;
model Water
replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

parameter Modelica.SIunits.AbsolutePressure pp = 60E5;
parameter Modelica.SIunits.SpecificEnthalpy hh = 2.8E6+4E3;
Medium.ThermodynamicState fluidState =  Medium.setState_ph(pp,hh) "State, mean";
Medium.SaturationProperties sat =  Medium.setSat_p(pp) "Saturation";

end Water;
