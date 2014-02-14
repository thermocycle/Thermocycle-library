within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model WallSegment "Heat capacity representing the wall of the cylinder"
  extends Modelica.Thermal.HeatTransfer.Components.HeatCapacitor;
  parameter Modelica.SIunits.SpecificHeatCapacity c(displayUnit='kj/kg.K') = 460
    "Heat capacity";
end WallSegment;
