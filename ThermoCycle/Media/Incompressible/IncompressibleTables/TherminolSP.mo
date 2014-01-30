within ThermoCycle.Media.Incompressible.IncompressibleTables;
package TherminolSP "TherminolSP Incompressible - TableBased"
  extends CoolProp2Modelica.Media.Incompressible.TableBased(
  mediumName="TherminolSP",
  T_min = Modelica.SIunits.Conversions.from_degC(-10),
   T_max = Modelica.SIunits.Conversions.from_degC(315),
   TinK = false,
   T0=273.15,
   tableDensity=
   [-10, 892; 0, 885; 20, 872; 40, 858; 60, 845; 80, 831; 100, 818; 120, 804; 140, 790;
    160, 777; 180, 762; 200, 748; 220, 734; 240, 719; 260, 704; 280, 688; 300,  672; 320, 655; 335, 642],
   tableHeatCapacity=
  [-10, 1.798; 0, 1.834; 20, 1.906; 40, 1.978; 60, 2.049; 80, 2.120; 100, 2.191; 120, 2.262; 140, 2.333;
    160, 2.403; 180, 2.474; 200, 2.544; 220, 2.614; 240, 2.684; 260, 2.755; 280, 2.825; 300,  2.896; 320, 2.967; 335, 3.022],
    tableConductivity=
   [-10, 0.132; 0, 0.131; 20, 0.128; 40, 0.126; 60,0.124; 80, 0.122; 100, 0.119; 120, 0.117; 140, 0.115;
    160, 0.112; 180, 0.110; 200, 0.107; 220, 0.105; 240, 0.103; 260, 0.100; 280, 0.098; 300,  0.096; 320, 0.093; 335, 0.091],
   tableViscosity=
[-10, 0.3086; 0, 0.1433; 20, 0.0416; 40, 0.0163; 60,0.0079; 80, 0.0045; 100, 0.00288; 120, 0.002; 140, 0.00148;
    160, 0.00140; 180, 0.00091; 200, 0.00075; 220, 0.00063; 240, 0.00053; 260, 0.00045; 280, 0.00039; 300,  0.00033; 320, 0.00029; 335, 0.00026],
   tableVaporPressure=
   [130, 100; 140, 200; 160, 500; 180, 1100; 200, 2200; 220, 4100; 240, 7400; 260, 12800; 280, 21300; 300,  34400; 320, 53700; 335, 73600]);
   // Finish viscosity and vapor pressure
   // Density ---->  [kg/m3]
   // HeatCapacity ----> [J/kg/K]
   // Conuctivity  ----> [W/m/K]
   // Viscosity  ---->    [Pa.s]
   // Vapor pressure ---->  [Pa]
end TherminolSP;
