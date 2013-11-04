within ThermoCycle.Media;
package R245faCoolSmooth
//  extends Modelica.Media.Water.StandardWater;

  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName = "R245fa",
    libraryName = "CoolProp",
    substanceNames = {"R245fa|calc_transport=0|debug=1|rho_smoothing_xend=0.15|enable_TTSE=1"});
end R245faCoolSmooth;
