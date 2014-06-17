within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Therminol_72 "Therminol 72 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends CoolProp2Modelica.Interfaces.IncompressibleCoolPropMedium(
    mediumName = "T72",
    libraryName = "CoolProp",
    substanceNames = {"T72|debug=0|enable_TTSE=0"});
end Therminol_72;
