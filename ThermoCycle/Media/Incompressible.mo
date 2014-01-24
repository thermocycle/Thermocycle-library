within ThermoCycle.Media;
package Incompressible
  extends Modelica.Icons.MaterialPropertiesPackage;
  package IncompressibleCP
  extends Modelica.Icons.MaterialPropertiesPackage;
    package HighTemperature
    extends Modelica.Icons.MaterialPropertiesPackage;
      package Therminol_VP1 "Therminol VP1 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "TVP1",
          libraryName = "CoolProp",
          substanceNames = {"TVP1"});
      end Therminol_VP1;

      package Therminol_66 "Therminol 66 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "T66",
          libraryName = "CoolProp",
          substanceNames = {"T66"});
      end Therminol_66;

      package Therminol_D12 "Therminol D12 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "TD12",
          libraryName = "CoolProp",
          substanceNames = {"TD12|debug=0|enable_TTSE=0"});
      end Therminol_D12;

      package Therminol_72 "Therminol 72 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "T72",
          libraryName = "CoolProp",
          substanceNames = {"T72|debug=0|enable_TTSE=0"});
      end Therminol_72;

      package Dowtherm_J "Dowtherm J Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "DowJ",
          libraryName = "CoolProp",
          substanceNames = {"DowJ|debug=0|enable_TTSE=0"});
      end Dowtherm_J;

      package Dowtherm_Q "Dowtherm Q Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "DowQ",
          libraryName = "CoolProp",
          substanceNames = {"DowQ|debug=0|enable_TTSE=0"});
      end Dowtherm_Q;

      package Syltherm_XLT "Syltherm XLT Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "XLT",
          libraryName = "CoolProp",
          substanceNames = {"XLT|debug=0|enable_TTSE=0"});
      end Syltherm_XLT;

      package Dynalene_HC_10 "Dynalene HC 10 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "HC10",
          libraryName = "CoolProp",
          substanceNames = {"HC10|debug=0|enable_TTSE=0"});
      end Dynalene_HC_10;

      package Dynalene_HC_20 "Dynalene HC 20 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "HC20",
          libraryName = "CoolProp",
          substanceNames = {"HC20|debug=0|enable_TTSE=0"});
      end Dynalene_HC_20;

      package Dynalene_HC_30 "Dynalene HC 30 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "HC30",
          libraryName = "CoolProp",
          substanceNames = {"HC30|debug=0|enable_TTSE=0"});
      end Dynalene_HC_30;

      package Dynalene_HC_40 "Dynalene HC 40 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "HC40",
          libraryName = "CoolProp",
          substanceNames = {"HC40|debug=0|enable_TTSE=0"});
      end Dynalene_HC_40;

      package Dynalene_HC_50 "Dynalene HC 50 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "HC50",
          libraryName = "CoolProp",
          substanceNames = {"HC50|debug=0|enable_TTSE=0"});
      end Dynalene_HC_50;
    end HighTemperature;

    package Refrigerants
    extends Modelica.Icons.Package;
      package DiethylBenzene "DiethylBenzene Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "DEB",
          libraryName = "CoolProp",
          substanceNames = {"DEB|debug=0|enable_TTSE=0"});
      end DiethylBenzene;

      package Hydrocarbon_Mixture
        "Hydrocarbon_Mixture Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "HCM",
          libraryName = "CoolProp",
          substanceNames = {"HCM|debug=0|enable_TTSE=0"});
      end Hydrocarbon_Mixture;

      package Hydrofluoroether_HFE_7100
        "Hydrofluoroether HFE 7100 Incompressible - CoolProp"

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "HFE",
          libraryName = "CoolProp",
          substanceNames = {"HFE|debug=0|enable_TTSE=0"});
      end Hydrofluoroether_HFE_7100;

      package Polydimethylsiloxan_1
        "Polydimethylsiloxan 1 Incompressible - CoolProp"

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "PMS1",
          libraryName = "CoolProp",
          substanceNames = {"PMS1|debug=0|enable_TTSE=0"});
      end Polydimethylsiloxan_1;

      package Polydimethylsiloxan_2
        "Polydimethylsiloxan 2 Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "PMS2",
          libraryName = "CoolProp",
          substanceNames = {"PMS2|debug=0|enable_TTSE=0"});
      end Polydimethylsiloxan_2;

      package SyntheticAlkylBenzene
        "Synthetic Alkyl Benzene Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "SAB",
          libraryName = "CoolProp",
          substanceNames = {"SAB|debug=0|enable_TTSE=0"});
      end SyntheticAlkylBenzene;

      package HydrocarbonBlend "Hydrocarbon Blend Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "HCB",
          libraryName = "CoolProp",
          substanceNames = {"HCB|debug=0|enable_TTSE=0"});
      end HydrocarbonBlend;

      package TerpeneFromCitrusOils
        "Terpene From Citrus Oils Incompressible - CoolProp"
      //  extends Modelica.Media.Water.StandardWater;

        extends CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium(
          mediumName = "TCO",
          libraryName = "CoolProp",
          substanceNames = {"TCO|debug=0|enable_TTSE=0"});
      end TerpeneFromCitrusOils;
    end Refrigerants;
  end IncompressibleCP;

  package IncompressibleTables
   extends Modelica.Icons.MaterialPropertiesPackage;
    package EthyleneGlycol "Ethylene glycol Incompressible - TableBased"
      extends CoolProp2Modelica.Media.Incompressible.TableBased(
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

    package Therminol66 "Therminol66 Incompressible - TableBased"
      extends CoolProp2Modelica.Media.Incompressible.TableBased(
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
  end IncompressibleTables;
end Incompressible;
