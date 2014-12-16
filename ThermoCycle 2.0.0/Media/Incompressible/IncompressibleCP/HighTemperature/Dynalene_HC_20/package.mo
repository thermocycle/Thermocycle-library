within ThermoCycle.Media.Incompressible.IncompressibleCP.HighTemperature;
package Dynalene_HC_20 "Dynalene HC 20 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName = "HC20",
    libraryName = "CoolProp",
    substanceNames = {"HC20|debug=0|enable_TTSE=0"});
end Dynalene_HC_20;
