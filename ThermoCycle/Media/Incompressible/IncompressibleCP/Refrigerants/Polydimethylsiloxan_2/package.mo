within ThermoCycle.Media.Incompressible.IncompressibleCP.Refrigerants;
package Polydimethylsiloxan_2 "Polydimethylsiloxan 2 Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "PMS2",
    libraryName = "CoolProp",
    substanceNames = {"PMS2|debug=0|enable_TTSE=0"});
end Polydimethylsiloxan_2;
