within ThermoCycle.Media.Incompressible.IncompressibleCP.Refrigerants;
package Hydrocarbon_Mixture "Hydrocarbon_Mixture Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName = "HCM",
    libraryName = "CoolProp",
    substanceNames = {"HCM|debug=0|enable_TTSE=0"});
end Hydrocarbon_Mixture;
