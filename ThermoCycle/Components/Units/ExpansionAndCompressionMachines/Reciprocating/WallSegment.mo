within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model WallSegment "Heat capacity representing the wall of the cylinder"
  extends Modelica.Thermal.HeatTransfer.Components.HeatCapacitor(final C=c*m);
  parameter Modelica.SIunits.SpecificHeatCapacity c = 900 "FE=460, AL=900";
  parameter Modelica.SIunits.Mass m = 1 "Mass";
end WallSegment;
