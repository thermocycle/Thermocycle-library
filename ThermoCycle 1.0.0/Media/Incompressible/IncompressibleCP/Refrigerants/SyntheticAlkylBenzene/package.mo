within ThermoCycle.Media.Incompressible.IncompressibleCP.Refrigerants;
package SyntheticAlkylBenzene "Synthetic Alkyl Benzene Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName = "SAB",
    libraryName = "CoolProp",
    substanceNames = {"SAB|debug=0|enable_TTSE=0"});
end SyntheticAlkylBenzene;
