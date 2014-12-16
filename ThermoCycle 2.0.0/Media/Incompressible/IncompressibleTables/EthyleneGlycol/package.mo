within ThermoCycle.Media.Incompressible.IncompressibleTables;
package EthyleneGlycol "Ethylene glycol Incompressible - TableBased"
  extends TableBased(
  mediumName="EthyleneGlycol",
  T_min = Modelica.SIunits.Conversions.from_degC(0),
   T_max = Modelica.SIunits.Conversions.from_degC(185),
   TinK = false,
   T0=273.15,
   tableDensity=[0, 1148.3; 20, 1134.7; 40, 1120.9; 60, 1107.0; 80, 1093.0; 100, 1078.7; 120, 1064.4; 140, 1049.8; 160, 1035.1; 180, 1020.2; 185, 1016.5],
   tableHeatCapacity = [0, 2329.1; 20, 2425.5; 40, 2521.9; 60, 2618.3; 80, 2714.6; 100, 2811.0; 120, 2907.4; 140, 3003.8; 160, 3100.2; 180, 3196.6; 185, 3220.7],
   tableConductivity= [0, 0.305; 20, 0.289; 40, 0.274; 60, 0.259; 80, 0.243; 100, 0.228; 120, 0.212; 140, 0.197; 160, 0.182; 180, 0.166; 185, 0.162],
   tableViscosity = [0, 0.04000; 20, 0.01800; 40, 0.00865; 60, 0.00525; 80, 0.00349; 100, 0.00243; 120, 0.00171; 140, 0.00119; 160, 0.00080; 180, 0.00050; 185, 0.00043],
   tableVaporPressure = fill(0,0,2));
   // Density ---->  [kg/m3]
   // HeatCapacity ----> [J/kg/K]
   // Conuctivity  ----> [W/m/K]
   // Viscosity  ---->    [Pa.s]
   // Vapor pressure ---->  [Pa]                                                     // Use ~ boiling point of propylene glycol since Eckerd uses propylene"


  annotation ();
end EthyleneGlycol;
