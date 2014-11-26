within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Therminol_D12 "Therminol D12 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "TD12",
    libraryName = "CoolProp",
    substanceNames = {"TD12|debug=0|enable_TTSE=0"});
end Therminol_D12;
