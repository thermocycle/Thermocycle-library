within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Dowtherm_J "Dowtherm J Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName = "DowJ",
    libraryName = "CoolProp",
    substanceNames = {"DowJ|debug=0|enable_TTSE=0"});
end Dowtherm_J;
