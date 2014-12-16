within ThermoCycle.Media.Incompressible.IncompressibleCP.Refrigerants;
package HydrocarbonBlend "Hydrocarbon Blend Incompressible - CoolProp"
//  extends Modelica.Media.Water.StandardWater;


  extends ExternalMedia.Media.IncompressibleCoolPropMedium(
    mediumName = "HCB",
    libraryName = "CoolProp",
    substanceNames = {"HCB|debug=0|enable_TTSE=0"});
end HydrocarbonBlend;
