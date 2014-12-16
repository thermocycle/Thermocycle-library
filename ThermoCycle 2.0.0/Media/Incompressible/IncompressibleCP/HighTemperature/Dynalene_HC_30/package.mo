within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Dynalene_HC_30 "Dynalene HC 30 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "HC30",
    libraryName = "CoolProp",
    substanceNames = {"HC30|debug=0|enable_TTSE=0"});
end Dynalene_HC_30;
