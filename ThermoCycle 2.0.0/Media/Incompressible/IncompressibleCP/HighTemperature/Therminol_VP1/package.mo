within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Therminol_VP1 "Therminol VP1 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "TVP1",
    libraryName = "CoolProp",
    substanceNames = {"TVP1"});
end Therminol_VP1;
