within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Dynalene_HC_40 "Dynalene HC 40 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "HC40",
    libraryName = "CoolProp",
    substanceNames = {"HC40|debug=0|enable_TTSE=0"});
end Dynalene_HC_40;
