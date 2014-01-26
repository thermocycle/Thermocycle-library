within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Therminol_66 "Therminol 66 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName = "T66",
    libraryName = "CoolProp",
    substanceNames = {"T66"});
end Therminol_66;
