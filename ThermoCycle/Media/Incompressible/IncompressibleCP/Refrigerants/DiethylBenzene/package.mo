within ThermoCycle.Media.Incompressible.IncompressibleCP.Refrigerants;
package DiethylBenzene "DiethylBenzene Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends CoolProp2Modelica.Interfaces.IncompressibleCoolPropMedium(
    mediumName = "DEB",
    libraryName = "CoolProp",
    substanceNames = {"DEB|debug=0|enable_TTSE=0"});
end DiethylBenzene;
