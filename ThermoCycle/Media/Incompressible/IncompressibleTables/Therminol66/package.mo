within ThermoCycle.Media.Incompressible.IncompressibleTables;
package Therminol66 "Therminol66 Incompressible - TableBased"
  extends TableBased(
  mediumName="Therminol66",
  T_min = Modelica.SIunits.Conversions.from_degC(0),
   T_max = Modelica.SIunits.Conversions.from_degC(380),
   TinK = false,
   T0=273.15,
   tableDensity=
   [0, 1021.5; 20, 1008.4; 40, 995.2; 60, 981.9; 80, 968.5; 100, 948.2; 120, 941.4; 140, 927.6;
    160, 913.6; 180, 899.5; 200, 885.1; 250,847.9; 300,  808.5; 350, 765.9; 380, 738.2],
   tableHeatCapacity=
   [0, 1495; 20, 1008.4; 40, 1630; 60, 1699; 80, 1768; 100, 1837; 120, 1908; 140, 1978; 160, 2050; 180, 2122; 200, 2195; 250, 2379; 300, 2569; 350, 2766; 380, 2889],
   tableConductivity=
   [0, 0.118; 20, 0.118; 40, 0.117; 60, 0.116; 80, 0.115; 100, 0.114; 120, 0.112; 140, 0.111; 160, 0.109; 180, 0.107; 200, 0.106; 250, 0.100; 300, 0.095; 350, 0.088; 380, 0.084],
   tableViscosity=
   [0, 1.32487; 20, 0.12347; 40, 0.02950; 60, 0.01153; 80, 0.00593; 100, 0.00360; 120, 0.00242; 140, 0.00175; 160, 0.00134; 180, 0.00106; 200, 0.00086; 250, 0.00057; 300, 0.00041; 350, 0.00032; 380, 0.00028],
   tableVaporPressure=
   [70, 10; 80, 20; 100, 50; 120, 120; 140, 270; 160, 580; 180, 1170; 200, 2230; 250, 9250; 300, 30730; 350, 85740; 380, 148130]);
   // Density ---->  [kg/m3]
   // HeatCapacity ----> [J/kg/K]
   // Conuctivity  ----> [W/m/K]
   // Viscosity  ---->    [Pa.s]
   // Vapor pressure ---->  [Pa]
end Therminol66;
