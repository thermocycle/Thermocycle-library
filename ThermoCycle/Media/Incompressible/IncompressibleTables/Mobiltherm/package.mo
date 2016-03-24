within ThermoCycle.Media.Incompressible.IncompressibleTables;
package Mobiltherm "Mobiltherm Incompressible - TableBased"
  extends TableBased(
  mediumName="Mobiltherm",
  T_min = Modelica.SIunits.Conversions.from_degC(0),
   T_max = Modelica.SIunits.Conversions.from_degC(240),
   TinK = false,
   T0=273.15,
   tableDensity=
   [0, 899; 10, 893; 20, 886.9; 40, 874.2; 60, 861.5; 80, 848.7; 100, 835.8; 120, 822.8; 140, 809.8;
    160, 796.8; 180, 783.7; 200, 770.5; 220, 757.4; 240, 744.2],
   tableHeatCapacity=
  [0, 1784.2; 10, 1820.1; 20, 1856.1; 40, 1928; 60, 1999.9; 80, 2071.8; 100, 2143.7; 120, 2215.6; 140, 2287.5;
    160, 2359.4; 180, 2431.3; 200, 2503.2; 220, 2575.1; 240, 2646.9],
    tableConductivity=
   [0, 0.1316; 10, 0.1313; 20, 0.1302; 40, 0.1288; 60,0.1274; 80, 0.1260; 100, 0.1246; 120, 0.1232; 140, 0.1218;
    160, 0.1204],
   tableViscosity=
[0, 1.85254; 10, 1.14913; 20, 0.33773; 40, 0.09616; 60,0.03716; 80, 0.01776; 100, 0.00986; 120, 0.00611; 140, 0.0041;
    160, 0.00292],
   tableVaporPressure=fill(0,0,2));

   // Finish viscosity and vapor pressure
   // Density ---->  [kg/m3]
   // HeatCapacity ----> [J/kg/K]
   // Conuctivity  ----> [W/m/K]
   // Viscosity  ---->    [Pa.s]
   // Vapor pressure ---->  [Pa]
end Mobiltherm;
