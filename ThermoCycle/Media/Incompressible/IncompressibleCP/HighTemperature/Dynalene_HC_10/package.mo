within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Dynalene_HC_10 "Dynalene HC 10 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "HC10",
    libraryName = "CoolProp",
    substanceNames = {"HC10|debug=0|enable_TTSE=0"});
end Dynalene_HC_10;
