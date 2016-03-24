within ThermoCycle.Components.Units.HeatExchangers.MB_HX;
package Constants 
  extends Modelica.Icons.Package;
import ThermoCycle.Components.Units.HeatExchangers.MB_HX.Records;
constant Integer ON = 1;
constant Integer OFF= 0;

constant Records.Mode ModeBasic(ka=ON, kb=OFF);
constant Records.Mode ModeCompound(ka=OFF, kb=ON);

end Constants;
