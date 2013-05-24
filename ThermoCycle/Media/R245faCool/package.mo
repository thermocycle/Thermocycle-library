within ThermoCycle.Media;
package R245faCool 
//  extends Modelica.Media.Water.StandardWater;

  extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
    mediumName = "R245fa",
    libraryName = "CoolProp",
    substanceNames = {"R245fa"});
end R245faCool;
