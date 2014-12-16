within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Dynalene_HC_50 "Dynalene HC 50 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "HC50",
    libraryName = "CoolProp",
    substanceNames = {"HC50|debug=0|enable_TTSE=0"});
end Dynalene_HC_50;
