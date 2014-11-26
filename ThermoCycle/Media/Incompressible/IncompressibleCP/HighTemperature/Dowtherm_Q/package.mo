within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Dowtherm_Q "Dowtherm Q Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "DowQ",
    libraryName = "CoolProp",
    substanceNames = {"DowQ|debug=0|enable_TTSE=0"});
end Dowtherm_Q;
