within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Syltherm_XLT "Syltherm XLT Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "XLT",
    libraryName = "CoolProp",
    substanceNames = {"XLT|debug=0|enable_TTSE=0"});
end Syltherm_XLT;
