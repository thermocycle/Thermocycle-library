within ExternalMedia;
package Test "Test models for the different solvers"
  extends Modelica.Icons.ExamplesPackage;
  package TestMedium "Test cases for TestMedium"
    extends Modelica.Icons.ExamplesPackage;
    model TestConstants "Test case using TestMedium with package constants"
      extends Modelica.Icons.Example;
      replaceable package Medium = Media.TestMedium;
      Medium.Temperature Tc=Medium.fluidConstants[1].criticalTemperature;
    end TestConstants;

    model TestState "Test case using TestMedium with a single state record"
      extends Modelica.Icons.Example;
      replaceable package Medium = Media.TestMedium;
      Medium.ThermodynamicState state;
    equation
      state = Medium.setState_ph(1e5, 1e5 + 1e5*time);
    end TestState;

    model TestSat
      "Test case using TestMedium with a single saturation properties record"
      extends Modelica.Icons.Example;
      replaceable package Medium = Media.TestMedium;
      Medium.SaturationProperties sat;
    equation
      sat = Medium.setSat_p(1e5 + 1e5*time);
    end TestSat;

    model TestStatesSat "Test case using TestMedium with state + sat records"
      extends Modelica.Icons.Example;
      replaceable package Medium = Media.TestMedium;
      Medium.BaseProperties baseProperties1;
      Medium.BaseProperties baseProperties2;
      Medium.ThermodynamicState state1;
      Medium.ThermodynamicState state2;
      Medium.SaturationProperties sat1;
      Medium.SaturationProperties sat2;
      Medium.Temperature Ts;
      Medium.AbsolutePressure ps;
      GenericModels.CompleteThermodynamicState completeState1(redeclare package
          Medium = Medium, state=state1);
      GenericModels.CompleteThermodynamicState completeState2(redeclare package
          Medium = Medium, state=state2);
      GenericModels.CompleteSaturationProperties completeSat1(redeclare package
          Medium = Medium, sat=sat1);
      GenericModels.CompleteSaturationProperties completeSat2(redeclare package
          Medium = Medium, sat=sat2);
      GenericModels.CompleteBubbleDewStates completeBubbleDewStates1(redeclare
          package Medium = Medium, sat=sat1);
      GenericModels.CompleteBubbleDewStates completeBubbleDewStates2(redeclare
          package Medium = Medium, sat=sat1);
    equation
      baseProperties1.p = 1e5 + 1e5*time;
      baseProperties1.h = 1e5;
      baseProperties2.p = 1e5;
      baseProperties2.h = 1e5 + 2e5*time;
      state1 = Medium.setState_ph(1e5 + 1e5*time, 1e5);
      state2 = Medium.setState_pT(1e5, 300 + 50*time);
      sat1 = Medium.setSat_p(1e5 + 1e5*time);
      sat2 = Medium.setSat_T(300 + 50*time);
      Ts = Medium.saturationTemperature(1e5 + 1e5*time);
      ps = Medium.saturationPressure(300 + 50*time);
    end TestStatesSat;

    model TestBasePropertiesExplicit
      "Test case using TestMedium and BaseProperties with explicit equations"
      extends Modelica.Icons.Example;
      replaceable package Medium = Media.TestMedium;
      ExternalMedia.Test.TestMedium.GenericModels.CompleteBaseProperties
        medium1(redeclare package Medium = Medium)
        "Constant pressure, varying enthalpy";
      ExternalMedia.Test.TestMedium.GenericModels.CompleteBaseProperties
        medium2(redeclare package Medium = Medium)
        "Varying pressure, constant enthalpy";
    equation
      medium1.baseProperties.p = 1e5 + 1e5*time;
      medium1.baseProperties.h = 1e5;
      medium2.baseProperties.p = 1e5;
      medium2.baseProperties.h = 1e5 + 2e5*time;
    end TestBasePropertiesExplicit;

    model TestBasePropertiesImplicit
      "Test case using TestMedium and BaseProperties with implicit equations"
      replaceable package Medium = Media.TestMedium;
      extends Modelica.Icons.Example;
      ExternalMedia.Test.TestMedium.GenericModels.CompleteBaseProperties
        medium1(redeclare package Medium = Medium, baseProperties(h(start=1e5)))
        "Constant pressure, varying enthalpy";
      ExternalMedia.Test.TestMedium.GenericModels.CompleteBaseProperties
        medium2(redeclare package Medium = Medium, baseProperties(h(start=1e5)))
        "Varying pressure, constant enthalpy";
    equation
      medium1.baseProperties.p = 1e5*time;
      medium1.baseProperties.T = 300 + 25*time;
      medium2.baseProperties.p = 1e5 + 1e5*time;
      medium2.baseProperties.T = 300;
    end TestBasePropertiesImplicit;

    model TestBasePropertiesDynamic
      "Test case using TestMedium and dynamic equations"
      extends Modelica.Icons.Example;
      replaceable package Medium = Media.TestMedium;
      parameter SI.Volume V=1 "Storage Volume";
      parameter Real p_atm=101325 "Atmospheric pressure";
      parameter SI.Temperature Tstart=300;
      parameter Real Kv0=1.00801e-2 "Valve flow coefficient";
      Medium.BaseProperties medium(preferredMediumStates=true);
      SI.Mass M;
      SI.Energy U;
      SI.MassFlowRate win(start=100);
      SI.MassFlowRate wout;
      SI.SpecificEnthalpy hin;
      SI.SpecificEnthalpy hout;
      SI.Power Q;
      Real Kv;
    equation
      // Mass & energy balance equation
      M = medium.d*V;
      U = medium.u*M;
      der(M) = win - wout;
      der(U) = win*hin - wout*hout + Q;
      // Inlet pump equations
      medium.p - p_atm = 2e5 - (1e5/100^2)*win^2;
      hin = 1e5;
      // Outlet valve equation
      wout = Kv*sqrt(medium.d*(medium.p - p_atm));
      hout = medium.h;
      // Input variables
      Kv = if time < 50 then Kv0 else Kv0*1.1;
      Q = if time < 1 then 0 else 1e7;
    initial equation
      // Initial conditions
      // Fixed initial states
      // medium.p = 2e5;
      // medium.h = 1e5;
      // Steady state equations
      der(medium.p) = 0;
      der(medium.h) = 0;
      annotation (experiment(StopTime=80, Tolerance=1e-007),
          experimentSetupOutput(equdistant=false));
    end TestBasePropertiesDynamic;

    package GenericModels
      "Contains generic models to use for thorough medium model testing"
      extends Modelica.Icons.BasesPackage;
      model CompleteFluidConstants
        "Compute all available medium fluid constants"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // Fluid constants
        Medium.Temperature Tc=Medium.fluidConstants[1].criticalTemperature;
        Medium.AbsolutePressure pc=Medium.fluidConstants[1].criticalPressure;
        Medium.MolarVolume vc=Medium.fluidConstants[1].criticalMolarVolume;
        Medium.MolarMass MM=Medium.fluidConstants[1].molarMass;
      end CompleteFluidConstants;

      model CompleteThermodynamicState
        "Compute all available two-phase medium properties from a ThermodynamicState model"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // ThermodynamicState record
        input Medium.ThermodynamicState state;
        // Medium properties
        Medium.AbsolutePressure p=Medium.pressure(state);
        Medium.SpecificEnthalpy h=Medium.specificEnthalpy(state);
        Medium.Temperature T=Medium.temperature(state);
        Medium.Density d=Medium.density(state);
        Medium.SpecificEntropy s=Medium.specificEntropy(state);
        Medium.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(state);
        Medium.SpecificHeatCapacity cv=Medium.specificHeatCapacityCv(state);
        Medium.IsobaricExpansionCoefficient beta=
            Medium.isobaricExpansionCoefficient(state);
        SI.IsothermalCompressibility kappa=Medium.isothermalCompressibility(
            state);
        Medium.DerDensityByPressure d_d_dp_h=Medium.density_derp_h(state);
        Medium.DerDensityByEnthalpy d_d_dh_p=Medium.density_derh_p(state);
        Medium.MolarMass MM=Medium.molarMass(state);
      end CompleteThermodynamicState;

      model CompleteSaturationProperties
        "Compute all available saturation properties from a SaturationProperties record"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // SaturationProperties record
        input Medium.SaturationProperties sat;
        // Saturation properties
        Medium.Temperature Ts=Medium.saturationTemperature_sat(sat);
        Medium.Density dl=Medium.bubbleDensity(sat);
        Medium.Density dv=Medium.dewDensity(sat);
        Medium.SpecificEnthalpy hl=Medium.bubbleEnthalpy(sat);
        Medium.SpecificEnthalpy hv=Medium.dewEnthalpy(sat);
        Real d_Ts_dp=Medium.saturationTemperature_derp_sat(sat);
        Real d_dl_dp=Medium.dBubbleDensity_dPressure(sat);
        Real d_dv_dp=Medium.dDewDensity_dPressure(sat);
        Real d_hl_dp=Medium.dBubbleEnthalpy_dPressure(sat);
        Real d_hv_dp=Medium.dDewEnthalpy_dPressure(sat);
      end CompleteSaturationProperties;

      model CompleteBubbleDewStates
        "Compute all available properties for dewpoint and bubble point states corresponding to a sat record"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // SaturationProperties record
        input Medium.SaturationProperties sat;
        CompleteThermodynamicState dewStateOnePhase(state=Medium.setDewState(
              sat, 1), redeclare package Medium = Medium);
        CompleteThermodynamicState dewStateTwoPhase(state=Medium.setDewState(
              sat, 2), redeclare package Medium = Medium);
        CompleteThermodynamicState bubbleStateOnePhase(state=
              Medium.setBubbleState(sat, 1), redeclare package Medium = Medium);
        CompleteThermodynamicState bubbleStateTwoPhase(state=
              Medium.setBubbleState(sat, 2), redeclare package Medium = Medium);
      end CompleteBubbleDewStates;

      model CompleteBaseProperties
        "Compute all available two-phase medium properties from a BaseProperties model"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // BaseProperties object
        Medium.BaseProperties baseProperties;
        // All the complete properties
        CompleteThermodynamicState completeState(redeclare package Medium =
              Medium, state=baseProperties.state);
        CompleteSaturationProperties completeSat(redeclare package Medium =
              Medium, sat=baseProperties.sat);
        CompleteFluidConstants completeConstants(redeclare package Medium =
              Medium);
        CompleteBubbleDewStates completeBubbleDewStates(redeclare package
            Medium = Medium, sat=baseProperties.sat);
      end CompleteBaseProperties;
    end GenericModels;

    model TestRunner "A model to collect generaic test cases"
      import ExternalMedia;
      extends Modelica.Icons.Example;
      ExternalMedia.Test.GenericModels.CompleteFluidConstants
        completeFluidConstants(redeclare package Medium =
            ExternalMedia.Media.TestMedium)
        annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    equation

    end TestRunner;
  end TestMedium;

  package FluidProp "Test cases for FluidPropMedium"
    extends Modelica.Icons.ExamplesPackage;

    package WaterIF95 "Test suite for the FluidProp-Refprop IF95 medium model"
      extends Modelica.Icons.ExamplesPackage;
       model TestStates "Test case with state records"
        import ExternalMedia;
         extends Modelica.Icons.Example;
         extends ExternalMedia.Test.GenericModels.TestStates(
                                          redeclare package Medium =
              ExternalMedia.Examples.WaterIF95);
       equation
        p1 = 1e5;
        h1 = 1e5 + 2e5*time;
        p2 = 1e5;
        T2 = 300 + 50*time;
       end TestStates;

      model TestStatesSat "Test case with state + sat records"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStatesSat(
                                            redeclare package Medium =
              ExternalMedia.Examples.WaterIF95);
      equation
        p1 = 1e5;
        h1 = 1e5 + 2e5*time;
        p2 = 1e5;
        T2 = 300 + 50*time;
      end TestStatesSat;

      model TestBasePropertiesExplicit
        "Test case using BaseProperties and explicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesExplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.WaterIF95);
      equation
        p1 = 1e5 + 1e5*time;
        h1 = 1e5;
        p2 = 1e5;
        h2 = 1e5 + 2e5*time;
      end TestBasePropertiesExplicit;

      model TestBasePropertiesImplicit
        "Test case using BaseProperties and implicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesImplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.WaterIF95, hstart=1e5);
      equation
        p1 = 1e5 + 1e5*time;
        T1 = 300 + 25*time;
        p2 = 1e5 + 1e5*time;
        T2 = 300;
      end TestBasePropertiesImplicit;

      model TestBasePropertiesDynamic
        "Test case using BaseProperties and dynamic equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesDynamic(
          redeclare package Medium = ExternalMedia.Examples.WaterIF95,
          Tstart=300,
          Kv0=1.00801e-2);
      equation
        // Inlet pump equations
        medium.p - p_atm = 2e5 - (1e5/100^2)*win^2;
        hin = 1e5;
        // Input variables
        Kv = if time < 50 then Kv0 else Kv0*1.1;
        Q = if time < 1 then 0 else 1e7;
        annotation (experiment(StopTime=80, Tolerance=1e-007),
            experimentSetupOutput(equdistant=false));
      end TestBasePropertiesDynamic;

      model CompareModelicaFluidProp_liquid
        "Comparison between Modelica IF97 and FluidProp IF95 models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterIF95,
          pmin=1e5,
          pmax=1e5,
          hmin=1e5,
          hmax=4e5);
      end CompareModelicaFluidProp_liquid;

      model CompareModelicaFluidProp_twophase
        "Comparison between Modelica IF97 and FluidProp IF95 models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterIF95,
          pmin=60e5,
          pmax=60e5,
          hmin=1000e3,
          hmax=2000e3);
      end CompareModelicaFluidProp_twophase;

      model CompareModelicaFluidProp_vapour
        "Comparison between Modelica IF97 and FluidProp IF95 models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterIF95,
          pmin=60e5,
          pmax=60e5,
          hmin=2800e3,
          hmax=3200e3);
      end CompareModelicaFluidProp_vapour;
    end WaterIF95;

    package WaterIF97 "Test suite for the FluidProp IF97 medium model"
      extends Modelica.Icons.ExamplesPackage;
      model TestStates "Test case with state records"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStates(
                                         redeclare package Medium =
              ExternalMedia.Examples.WaterIF97);
      equation
        p1 = 1e5;
        h1 = 1e5 + 2e5*time;
        p2 = 1e5;
        T2 = 300 + 50*time;
      end TestStates;

      model TestStatesSat "Test case with state + sat records"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStatesSat(
                                            redeclare package Medium =
              ExternalMedia.Examples.WaterIF97);
      equation
        p1 = 1e5;
        h1 = 1e5 + 2e5*time;
        p2 = 1e5;
        T2 = 300 + 50*time;
      end TestStatesSat;

      model TestBasePropertiesExplicit
        "Test case using BaseProperties and explicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesExplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.WaterIF97);
      equation
        p1 = 1e5 + 1e5*time;
        h1 = 1e5;
        p2 = 1e5;
        h2 = 1e5 + 2e5*time;
      end TestBasePropertiesExplicit;

      model TestBasePropertiesImplicit
        "Test case using BaseProperties and implicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesImplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.WaterIF97, hstart=1e5);
      equation
        p1 = 1e5 + 1e5*time;
        T1 = 300 + 25*time;
        p2 = 1e5 + 1e5*time;
        T2 = 300;
      end TestBasePropertiesImplicit;

      model TestBasePropertiesDynamic
        "Test case using BaseProperties and dynamic equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesDynamic(
          redeclare package Medium = ExternalMedia.Examples.WaterIF97,
          Tstart=300,
          Kv0=1.00801e-2);
      equation
        // Inlet pump equations
        medium.p - p_atm = 2e5 - (1e5/100^2)*win^2;
        hin = 1e5;
        // Input variables
        Kv = if time < 50 then Kv0 else Kv0*1.1;
        Q = if time < 1 then 0 else 1e7;
        annotation (experiment(StopTime=80, Tolerance=1e-007),
            experimentSetupOutput(equdistant=false));
      end TestBasePropertiesDynamic;

      model CompareModelicaFluidProp_liquid
        "Comparison between Modelica IF97 and FluidProp IF97 models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterIF97,
          pmin=1e5,
          pmax=1e5,
          hmin=1e5,
          hmax=4e5);
      end CompareModelicaFluidProp_liquid;

      model CompareModelicaFluidProp_twophase
        "Comparison between Modelica IF97 and FluidProp IF97 models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterIF97,
          pmin=60e5,
          pmax=60e5,
          hmin=1000e3,
          hmax=2000e3);
      end CompareModelicaFluidProp_twophase;

      model CompareModelicaFluidProp_vapour
        "Comparison between Modelica IF97 and FluidProp IF97 models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterIF97,
          pmin=60e5,
          pmax=60e5,
          hmin=2800e3,
          hmax=3200e3);
      end CompareModelicaFluidProp_vapour;
    end WaterIF97;

    package WaterTPSI "Test suite for the FluidProp TPSI water medium model"
      extends Modelica.Icons.ExamplesPackage;
      model TestStates "Test case with state records"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStates(
                                         redeclare package Medium =
              ExternalMedia.Examples.WaterTPSI);
      equation
        p1 = 1e5;
        h1 = 1e5 + 2e5*time;
        p2 = 1e5;
        T2 = 300 + 50*time;
      end TestStates;

      model TestStatesSat "Test case with state + sat records"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStatesSat(
                                            redeclare package Medium =
              ExternalMedia.Examples.WaterTPSI);
      equation
        p1 = 1e5;
        h1 = 1e5 + 2e5*time;
        p2 = 1e5;
        T2 = 300 + 50*time;
      end TestStatesSat;

      model TestBasePropertiesExplicit
        "Test case using BaseProperties and explicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesExplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.WaterTPSI);
      equation
        p1 = 1e5 + 1e5*time;
        h1 = 1e5;
        p2 = 1e5;
        h2 = 1e5 + 2e5*time;
      end TestBasePropertiesExplicit;

      model TestBasePropertiesImplicit
        "Test case using BaseProperties and implicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesImplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.WaterTPSI, hstart=1e5);
      equation
        p1 = 1e5 + 1e5*time;
        T1 = 300 + 25*time;
        p2 = 1e5 + 1e5*time;
        T2 = 300;
      end TestBasePropertiesImplicit;

      model TestBasePropertiesDynamic
        "Test case using BaseProperties and dynamic equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesDynamic(
          redeclare package Medium = ExternalMedia.Examples.WaterTPSI,
          Tstart=300,
          Kv0=1.00801e-2);
      equation
        // Inlet pump equations
        medium.p - p_atm = 2e5 - (1e5/100^2)*win^2;
        hin = 1e5;
        // Input variables
        Kv = if time < 50 then Kv0 else Kv0*1.1;
        Q = if time < 1 then 0 else 1e7;
        annotation (experiment(StopTime=80, Tolerance=1e-007),
            experimentSetupOutput(equdistant=false));
      end TestBasePropertiesDynamic;

      model CompareModelicaFluidProp_liquid
        "Comparison between Modelica IF97 and FluidProp TPSI models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterTPSI,
          pmin=1e5,
          pmax=1e5,
          hmin=1e5,
          hmax=4e5);
      end CompareModelicaFluidProp_liquid;

      model CompareModelicaFluidProp_twophase
        "Comparison between Modelica IF97 and FluidProp TPSI models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterTPSI,
          pmin=60e5,
          pmax=60e5,
          hmin=1000e3,
          hmax=2000e3);
      end CompareModelicaFluidProp_twophase;

      model CompareModelicaFluidProp_vapour
        "Comparison between Modelica IF97 and FluidProp TPSI models - liquid"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.CompareModelicaTestMedium(
          redeclare package ModelicaMedium = Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium = ExternalMedia.Examples.WaterTPSI,
          pmin=60e5,
          pmax=60e5,
          hmin=2800e3,
          hmax=3200e3);
      end CompareModelicaFluidProp_vapour;
    end WaterTPSI;

    package CO2StanMix "Test suite for the StanMix CO2 medium model"
      extends Modelica.Icons.ExamplesPackage;
      model TestStatesSupercritical
        "Test case with state records, supercritical conditions"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStates(
                                         redeclare package Medium =
              ExternalMedia.Examples.CO2StanMix);
      equation
        p1 = 8e6;
        h1 = -4.2e5 + 6e5*time;
        p2 = 8e6;
        T2 = 280 + 50*time;
      end TestStatesSupercritical;

      model TestStatesTranscritical
        "Test case with state records, transcritical conditions"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStates(
                                         redeclare package Medium =
              ExternalMedia.Examples.CO2StanMix);
      equation
        p1 = 1e6 + time*10e6;
        h1 = -4.2e5 + 0*time;
        p2 = 1e6 + time*10e6;
        T2 = 330;
      end TestStatesTranscritical;

      model TestStatesSatSubcritical
        "Test case with state + sat records, subcritical conditions"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStatesSat(
                                            redeclare package Medium =
              ExternalMedia.Examples.CO2StanMix);
      equation
        p1 = 1e6;
        h1 = -4.2e5 + 6e5*time;
        p2 = 1e6;
        T2 = 250 + 50*time;
      end TestStatesSatSubcritical;

      model TestBasePropertiesExplicit
        "Test case using BaseProperties and explicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesExplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.CO2StanMix);
      equation
        p1 = 8e6;
        h1 = -4.2e5 + 6e5*time;
        p2 = 1e6;
        h2 = -4.2e5 + 6e5*time;
      end TestBasePropertiesExplicit;

      model TestBasePropertiesImplicit
        "Test case using BaseProperties and implicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesImplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.CO2StanMix, hstart=0);
      equation
        p1 = 8e6;
        T1 = 280 + 20*time;
        p2 = 1e6;
        T2 = 280 + 20*time;
      end TestBasePropertiesImplicit;

      model TestBasePropertiesDynamic
        "Test case using BaseProperties and dynamic equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesDynamic(
          redeclare package Medium = ExternalMedia.Examples.CO2StanMix,
          Tstart=300,
          hstart=0,
          pstart=1e6,
          Kv0=1.00801e-4,
          V=0.1);
      equation
        // Inlet equations
        win = 1;
        hin = 0;
        // Input variables
        Kv = if time < 50 then Kv0 else Kv0*1.1;
        Q = if time < 1 then 0 else 1e4;
        annotation (experiment(StopTime=80, Tolerance=1e-007),
            experimentSetupOutput(equdistant=false));
      end TestBasePropertiesDynamic;

      model TestBasePropertiesTranscritical
        "Test case using BaseProperties and explicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesExplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.CO2StanMix);
      equation
        p1 = 1e6 + time*10e6;
        h1 = -4.2e5 + 0*time;
        p2 = 1e6 + time*10e6;
        h2 = 2.0e5;
      end TestBasePropertiesTranscritical;
    end CO2StanMix;

    package CO2RefProp "Test suite for the REFPROP CO2 medium model"
      extends Modelica.Icons.ExamplesPackage;
      model TestStatesSupercritical
        "Test case with state records, supercritical conditions"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStates(
                                         redeclare package Medium =
              ExternalMedia.Examples.CO2RefProp);
      equation
        p1 = 8e6;
        h1 = 1.0e5 + 6e5*time;
        p2 = 8e6;
        T2 = 280 + 50*time;
      end TestStatesSupercritical;

      model TestStatesTranscritical
        "Test case with state records, transcritical conditions"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStates(
                                         redeclare package Medium =
              ExternalMedia.Examples.CO2RefProp);
      equation
        p1 = 1e6 + time*10e6;
        h1 = 1.0e5;
        p2 = 1e6 + time*10e6;
        T2 = 330;
      end TestStatesTranscritical;

      model TestStatesSatSubcritical
        "Test case state + sat records, subcritical conditions"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestStatesSat(
                                            redeclare package Medium =
              ExternalMedia.Examples.CO2RefProp);
      equation
        p1 = 1e6;
        h1 = 1.0e5 + 6e5*time;
        p2 = 1e6;
        T2 = 250 + 50*time;
      end TestStatesSatSubcritical;

      model TestBasePropertiesExplicit
        "Test case using BaseProperties and explicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesExplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.CO2RefProp);
      equation
        p1 = 8e6;
        h1 = 1.0e5 + 6e5*time;
        p2 = 1e6;
        h2 = 1.0e5 + 6e5*time;
      end TestBasePropertiesExplicit;

      model TestBasePropertiesImplicit
        "Test case using BaseProperties and implicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesImplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.CO2RefProp, hstart=1e5);
      equation
        p1 = 8e6;
        T1 = 280 + 50*time;
        p2 = 1e6;
        T2 = 280 + 50*time;
      end TestBasePropertiesImplicit;

      model TestBasePropertiesDynamic
        "Test case using BaseProperties and dynamic equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesDynamic(
          redeclare package Medium = ExternalMedia.Examples.CO2RefProp,
          Tstart=300,
          hstart=4e5,
          pstart=1e6,
          Kv0=1.00801e-4,
          V=0.1);
      equation
        // Inlet equations
        win = 1;
        hin = 5e5;
        // Input variables
        Kv = if time < 50 then Kv0 else Kv0*1.1;
        Q = if time < 1 then 0 else 1e4;
        annotation (experiment(StopTime=80, Tolerance=1e-007),
            experimentSetupOutput(equdistant=false));
      end TestBasePropertiesDynamic;

      model TestBasePropertiesTranscritical
        "Test case using BaseProperties and explicit equations"
        import ExternalMedia;
        extends Modelica.Icons.Example;
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesExplicit(
                                                         redeclare package
            Medium = ExternalMedia.Examples.CO2RefProp);
      equation
        p1 = 1e6 + time*10e6;
        h1 = 1.0e5;
        p2 = 1e6 + time*10e6;
        h2 = 7.0e5;
      end TestBasePropertiesTranscritical;
    end CO2RefProp;
  end FluidProp;

  package CoolProp "Test cases for CoolProp"
    extends Modelica.Icons.ExamplesPackage;
    package CO2 "Test suite for the CoolProp CO2 medium model"
       extends Modelica.Icons.ExamplesPackage;
      model TestStatesSupercritical
        "Test case with state records, supercritical conditions"
        extends Modelica.Icons.Example;
        extends GenericModels.TestStates(          redeclare package Medium =
              ExternalMedia.Examples.CO2CoolProp);
      equation
        p1 = 8e6;
        h1 = 1.0e5 + 6e5*time;
        p2 = 8e6;
        T2 = 280 + 50*time;
      end TestStatesSupercritical;

      model TestStatesTranscritical
        "Test case with state records, transcritical conditions"
        extends Modelica.Icons.Example;
        extends GenericModels.TestStates(          redeclare package Medium =
              ExternalMedia.Examples.CO2CoolProp);
      equation
        p1 = 1e6 + time*10e6;
        h1 = 1.0e5;
        p2 = 1e6 + time*10e6;
        T2 = 330;
      end TestStatesTranscritical;

      model TestStatesSatSubcritical
        "Test case state + sat records, subcritical conditions"
        extends Modelica.Icons.Example;
        extends GenericModels.TestStatesSat(          redeclare package Medium
            = ExternalMedia.Examples.CO2CoolProp);
      equation
        p1 = 1e6;
        h1 = 1.0e5 + 6e5*time;
        p2 = 1e6;
        T2 = 250 + 50*time;
      end TestStatesSatSubcritical;

      model TestBasePropertiesExplicit
        "Test case using BaseProperties and explicit equations"
        extends Modelica.Icons.Example;
        extends GenericModels.TestBasePropertiesExplicit(          redeclare
            package Medium = ExternalMedia.Examples.CO2CoolProp);
      equation
        p1 = 8e6;
        h1 = 1.0e5 + 6e5*time;
        p2 = 1e6;
        h2 = 1.0e5 + 6e5*time;
      end TestBasePropertiesExplicit;

      model TestBasePropertiesImplicit
        "Test case using BaseProperties and implicit equations"
        extends Modelica.Icons.Example;
        extends GenericModels.TestBasePropertiesImplicit(          redeclare
            package Medium = ExternalMedia.Examples.CO2CoolProp, hstart=1e5);
      equation
        p1 = 8e6;
        T1 = 280 + 50*time;
        p2 = 1e6;
        T2 = 280 + 50*time;
      end TestBasePropertiesImplicit;

      model TestBasePropertiesDynamic
        "Test case using BaseProperties and dynamic equations"
        extends Modelica.Icons.Example;
        extends GenericModels.TestBasePropertiesDynamic(
          redeclare package Medium = ExternalMedia.Examples.CO2CoolProp,
          Tstart=300,
          hstart=4e5,
          pstart=1e6,
          Kv0=1.00801e-4,
          V=0.1);
      equation
        // Inlet equations
        win = 1;
        hin = 5e5;
        // Input variables
        Kv = if time < 50 then Kv0 else Kv0*1.1;
        Q = if time < 1 then 0 else 1e4;
        annotation (experiment(StopTime=80, Tolerance=1e-007),
            experimentSetupOutput(equdistant=false));
      end TestBasePropertiesDynamic;

      model TestBasePropertiesTranscritical
        "Test case using BaseProperties and explicit equations"
        extends Modelica.Icons.Example;
        extends GenericModels.TestBasePropertiesExplicit(          redeclare
            package Medium = ExternalMedia.Examples.CO2CoolProp);
      equation
        p1 = 1e6 + time*10e6;
        h1 = 1.0e5;
        p2 = 1e6 + time*10e6;
        h2 = 7.0e5;
      end TestBasePropertiesTranscritical;

    end CO2;

    model Pentane_hs
    package wf
      extends ExternalMedia.Media.CoolPropMedium(
        mediumName = "Pentane",
        substanceNames = {"n-Pentane"},
        inputChoice=ExternalMedia.Common.InputChoice.hs);
    end wf;
      wf.BaseProperties fluid "Properties of the two-phase fluid";
      Modelica.SIunits.SpecificEnthalpy h;
      Modelica.SIunits.Pressure p;
      Modelica.SIunits.SpecificEntropy s;
      Modelica.SIunits.DerDensityByEnthalpy drdh
        "Derivative of average density by enthalpy";
      Modelica.SIunits.DerDensityByPressure drdp
        "Derivative of average density by pressure";
    equation
      //p = 1E5;
      h = 0 + time*1E6;
      s = 1500;  //600 + time*2000;
      fluid.p = p;
      fluid.s = s;
      fluid.h = h;
      drdp = wf.density_derp_h(fluid.state);
      drdh = wf.density_derh_p(fluid.state);
    end Pentane_hs;

    model Pentane_hs_state
    package wf
      extends ExternalMedia.Media.CoolPropMedium(
        mediumName = "Pentane",
        substanceNames = {"n-Pentane"},
        inputChoice=ExternalMedia.Common.InputChoice.hs);
    end wf;
      wf.ThermodynamicState fluid "Properties of the two-phase fluid";
      Modelica.SIunits.SpecificEnthalpy h;
      Modelica.SIunits.Pressure p;
      Modelica.SIunits.SpecificEntropy s;
      Modelica.SIunits.DerDensityByEnthalpy drdh
        "Derivative of average density by enthalpy";
      Modelica.SIunits.DerDensityByPressure drdp
        "Derivative of average density by pressure";
    equation
      //p = 1E5;
      h = 0 + time*1E6;
      s = 600 + time*2000;
      fluid = wf.setState_hs(h,s);
      fluid.p = p;
      drdp = wf.density_derp_h(fluid);
      drdh = wf.density_derh_p(fluid);
    end Pentane_hs_state;

    model MSL_Models
      import ExternalMedia;
      extends Modelica.Icons.Example;

      ExternalMedia.Test.MSL_Models.BranchingDynamicPipes branchingDynamicPipes(
          redeclare package NewMedium = ExternalMedia.Examples.WaterCoolProp)
        annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
    end MSL_Models;

    model CheckOptions
      extends Modelica.Icons.Example;
      String test;
    algorithm
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_TTSE");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_TTSE=0");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_TTSE=1");
      //
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_BICUBIC");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_BICUBIC=0");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_BICUBIC=1");
      //
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_EXTTP");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_EXTTP=0");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_EXTTP=1");
      //
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|twophase_derivsmoothing_xend");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|twophase_derivsmoothing_xend=0.0");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|twophase_derivsmoothing_xend=0.1");
      //
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|rho_smoothing_xend");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|rho_smoothing_xend=0.0");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|rho_smoothing_xend=0.1");
      //
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|debug");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|debug=0");
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|debug=100");
      //
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_TTSE=1|debug=0|enable_EXTTP",debug=true);
      test := ExternalMedia.Common.CheckCoolPropOptions("LiBr|enable_TTSE=1|debug=0|enableEXTTP=1");
    end CheckOptions;

    package Incompressible
                           extends Modelica.Icons.ExamplesPackage;
      model incompressibleCoolPropMedium
                                         extends Modelica.Icons.Example;

      package DowQ_CP "DowthermQ properties from CoolProp"
        extends ExternalMedia.Media.IncompressibleCoolPropMedium(
        mediumName="DowQ",
        substanceNames={"DowQ|calc_transport=1|debug=1000"},
        ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.pT);
      end DowQ_CP;

      //replaceable package Fluid = ExternalMedia.Examples.WaterCoolProp (
      //  ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pTX) constrainedby
      //    Modelica.Media.Interfaces.PartialMedium "Medium model";

      replaceable package Fluid =  DowQ_CP constrainedby
          Modelica.Media.Interfaces.PartialMedium "Medium model";
        Fluid.ThermodynamicState state;
        Fluid.Temperature T;
        Fluid.AbsolutePressure p;
        Fluid.BaseProperties props;

      equation
        p     = 10E5;
        T     = 273.15 + 15.0 + time * 50.0;
        state = Fluid.setState_pT(p,T);
        // And now we do some testing with the BaseProperties
        props.T = T;
        props.p = p;
      end incompressibleCoolPropMedium;

      model incompressibleCoolPropMixture
                                         extends Modelica.Icons.Example;

      package LiBr_CP "Lithium bromide solution properties from CoolProp"
        extends ExternalMedia.Media.IncompressibleCoolPropMedium(
        mediumName="LiBr",
        substanceNames={"LiBr|calc_transport=1|debug=1000","dummyToMakeBasePropertiesWork"},
        ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.pTX);
      end LiBr_CP;

      replaceable package Fluid = LiBr_CP constrainedby
          Modelica.Media.Interfaces.PartialMedium "Medium model";
        Fluid.ThermodynamicState state_var;
        Fluid.ThermodynamicState state_con;
        Fluid.Temperature T;
        Fluid.AbsolutePressure p;
        Fluid.MassFraction[1] X_var;
        Fluid.MassFraction[1] X_con;
        Fluid.BaseProperties varProps;

      equation
        p         = 10E5;
        T         = 273.15 + 15.0 + time * 50.0;
        X_var[1]  =   0.00 +  0.1 + time *  0.5;
        X_con[1]  =   0.00 +  0.1;
        state_var = Fluid.setState_pTX(p,T,X_var);
        state_con = Fluid.setState_pTX(p,T,X_con);
        // And now we do some testing with the BaseProperties
        varProps.T = T;
        varProps.p = p;
        varProps.Xi = X_var;
      end incompressibleCoolPropMixture;
    end Incompressible;
  end CoolProp;

  package WrongMedium "Test cases with wrong medium models"
    extends Modelica.Icons.ExamplesPackage;
    model TestWrongMedium
      "Test the error reporting messages for unsupported external media"
      extends Modelica.Icons.Example;
      package Medium = Media.BaseClasses.ExternalTwoPhaseMedium;
      Medium.BaseProperties medium;
    equation
      medium.p = 1e5;
      medium.h = 1e5;
    end TestWrongMedium;
  end WrongMedium;

  package TestOMC "Test cases for OpenModelica implementation"
    extends Modelica.Icons.ExamplesPackage;
    package TestHelium
      "Test for NIST Helium model using ExternalMedia and FluidProp"
      extends Modelica.Icons.ExamplesPackage;
      package Helium "Helium model from NIST RefProp database"
        extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
          mediumName="Helium",
          libraryName="FluidProp.RefProp",
          substanceNames={"He"},
          ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
          AbsolutePressure(
            min=500,
            max=44e5,
            nominal=1e5,
            start=1e5),
          Density(
            min=0.1,
            max=200,
            nominal=100,
            start=100),
          SpecificEnthalpy(
            min=-6000,
            max=1.7e6,
            nominal=1000,
            start=0),
          SpecificEntropy(
            min=-4000,
            max=30e3,
            nominal=1000,
            start=0),
          Temperature(
            min=2.17,
            max=310,
            nominal=10,
            start=5,
            displayUnit="K"));
      end Helium;

      model TestSupercriticalHelium
        extends Modelica.Icons.Example;
        package Medium = Helium;
        Medium.ThermodynamicState state;
        Medium.Temperature T;
        Medium.Temperature Tcrit=Medium.fluidConstants[1].criticalTemperature;
        Medium.AbsolutePressure p;
        Modelica.SIunits.Density d;
        Medium.AbsolutePressure pcrit=Medium.fluidConstants[1].criticalPressure;
      equation
        T = 300 - 297.5*time;
        p = 4e5 + 0*time;
        state = Medium.setState_pT(p, T);
        d = Medium.density(state);
      end TestSupercriticalHelium;

      model TestSaturatedHelium
        extends Modelica.Icons.Example;
        package Medium = Helium;
        Medium.SaturationProperties sat;
        Medium.Temperature T;
        Medium.AbsolutePressure p;
        Modelica.SIunits.Density dl;
        Modelica.SIunits.Density dv;
      equation
        p = 1e5 + 1.27e5*time;
        sat = Medium.setSat_p(p);
        dv = Medium.dewDensity(sat);
        dl = Medium.bubbleDensity(sat);
        T = Medium.saturationTemperature_sat(sat);
      end TestSaturatedHelium;

      model TypicalHeliumProperties
        extends Modelica.Icons.Example;
        package Medium = Helium;
        Medium.ThermodynamicState state;
        Medium.Temperature T;
        Medium.Temperature Tcrit=Medium.fluidConstants[1].criticalTemperature;
        Medium.AbsolutePressure p;
        Modelica.SIunits.Density d;
        Medium.AbsolutePressure pcrit=Medium.fluidConstants[1].criticalPressure;
        Modelica.SIunits.SpecificHeatCapacity cv=Medium.specificHeatCapacityCv(
            state);
      equation
        T = 5;
        p = 5e5;
        state = Medium.setState_pT(p, T);
        d = Medium.density(state);
      end TypicalHeliumProperties;
    end TestHelium;

    package TestHeliumHardCodedProperties
      "Test for NIST Helium model using ExternalMedia and FluidProp, hard-coded fluid properties package constants"
      extends Modelica.Icons.ExamplesPackage;
      package Helium "Helium model from NIST RefProp database"
        extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
          mediumName="Helium",
          libraryName="FluidProp.RefProp",
          substanceNames={"He"},
          externalFluidConstants=FluidConstants(
                    iupacName="unknown",
                    casRegistryNumber="unknown",
                    chemicalFormula="unknown",
                    structureFormula="unknown",
                    molarMass=4.0026e-3,
                    criticalTemperature=5.1953,
                    criticalPressure=2.2746e5,
                    criticalMolarVolume=1/69.641*4.0026e-3,
                    acentricFactor=0,
                    triplePointTemperature=280.0,
                    triplePointPressure=500.0,
                    meltingPoint=280,
                    normalBoilingPoint=380.0,
                    dipoleMoment=2.0),
          ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
          AbsolutePressure(
            min=500,
            max=44e5,
            nominal=1e5,
            start=1e5),
          Density(
            min=0.1,
            max=200,
            nominal=100,
            start=100),
          SpecificEnthalpy(
            min=-6000,
            max=1.7e6,
            nominal=1000,
            start=0),
          SpecificEntropy(
            min=-4000,
            max=30e3,
            nominal=1000,
            start=0),
          Temperature(
            min=2.17,
            max=310,
            nominal=10,
            start=5,
            displayUnit="K"));
      end Helium;

      model TestSupercriticalHelium
        extends Modelica.Icons.Example;
        package Medium = Helium;
        Medium.ThermodynamicState state;
        Medium.Temperature T;
        Medium.Temperature Tcrit=Medium.fluidConstants[1].criticalTemperature;
        Medium.AbsolutePressure p;
        Modelica.SIunits.Density d;
        Medium.AbsolutePressure pcrit=Medium.fluidConstants[1].criticalPressure;
      equation
        T = 300 - 297.5*time;
        p = 4e5 + 0*time;
        state = Medium.setState_pT(p, T);
        d = Medium.density(state);
      end TestSupercriticalHelium;

      model TestSaturatedHelium
        extends Modelica.Icons.Example;
        package Medium = Helium;
        Medium.SaturationProperties sat;
        Medium.Temperature T;
        Medium.AbsolutePressure p;
        Modelica.SIunits.Density dl;
        Modelica.SIunits.Density dv;
      equation
        p = 1e5 + 1.27e5*time;
        sat = Medium.setSat_p(p);
        dv = Medium.dewDensity(sat);
        dl = Medium.bubbleDensity(sat);
        T = Medium.saturationTemperature_sat(sat);
      end TestSaturatedHelium;

      model TypicalHeliumProperties
        extends Modelica.Icons.Example;
        package Medium = Helium;
        Medium.ThermodynamicState state;
        Medium.Temperature T;
        Medium.Temperature Tcrit=Medium.fluidConstants[1].criticalTemperature;
        Medium.AbsolutePressure p;
        Modelica.SIunits.Density d;
        Medium.AbsolutePressure pcrit=Medium.fluidConstants[1].criticalPressure;
        Modelica.SIunits.SpecificHeatCapacity cv=Medium.specificHeatCapacityCv(
            state);
      equation
        T = 5;
        p = 5e5;
        state = Medium.setState_pT(p, T);
        d = Medium.density(state);
      end TypicalHeliumProperties;
    end TestHeliumHardCodedProperties;
  end TestOMC;

  package GenericModels "Generic models for FluidProp media tests"
    extends Modelica.Icons.BasesPackage;
    package DummyTwoPhaseMedium "A dummy to allow for pedantic checking"
      extends Modelica.Media.Water.WaterIF97_ph;
    end DummyTwoPhaseMedium;

    model CompleteFluidConstants "Compute all available medium fluid constants"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      // Fluid constants
      Medium.Temperature Tc=Medium.fluidConstants[1].criticalTemperature;
      Medium.AbsolutePressure pc=Medium.fluidConstants[1].criticalPressure;
      Medium.MolarVolume vc=Medium.fluidConstants[1].criticalMolarVolume;
      Medium.MolarMass MM=Medium.fluidConstants[1].molarMass;
    end CompleteFluidConstants;

    model CompleteThermodynamicState
      "Compute all available two-phase medium properties from a ThermodynamicState model"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      // ThermodynamicState record
      input Medium.ThermodynamicState state;
      // Medium properties
      Medium.AbsolutePressure p=Medium.pressure(state);
      Medium.SpecificEnthalpy h=Medium.specificEnthalpy(state);
      Medium.Temperature T=Medium.temperature(state);
      Medium.Density d=Medium.density(state);
      Medium.SpecificEntropy s=Medium.specificEntropy(state);
      Medium.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(state);
      Medium.SpecificHeatCapacity cv=Medium.specificHeatCapacityCv(state);
      Medium.IsobaricExpansionCoefficient beta=Medium.isobaricExpansionCoefficient(state);
      SI.IsothermalCompressibility kappa=Medium.isothermalCompressibility(state);
      Medium.DerDensityByPressure d_d_dp_h=Medium.density_derp_h(state);
      Medium.DerDensityByEnthalpy d_d_dh_p=Medium.density_derh_p(state);
      Medium.MolarMass MM=Medium.molarMass(state);
    end CompleteThermodynamicState;

    model CompleteSaturationProperties
      "Compute all available saturation properties from a SaturationProperties record"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      // SaturationProperties record
      input Medium.SaturationProperties sat;
      // Saturation properties
      Medium.Temperature Ts=Medium.saturationTemperature_sat(sat);
      Medium.Density dl=Medium.bubbleDensity(sat);
      Medium.Density dv=Medium.dewDensity(sat);
      Medium.SpecificEnthalpy hl=Medium.bubbleEnthalpy(sat);
      Medium.SpecificEnthalpy hv=Medium.dewEnthalpy(sat);
      Real d_Ts_dp=Medium.saturationTemperature_derp_sat(sat);
      Real d_dl_dp=Medium.dBubbleDensity_dPressure(sat);
      Real d_dv_dp=Medium.dDewDensity_dPressure(sat);
      Real d_hl_dp=Medium.dBubbleEnthalpy_dPressure(sat);
      Real d_hv_dp=Medium.dDewEnthalpy_dPressure(sat);
    end CompleteSaturationProperties;

    model CompleteBubbleDewStates
      "Compute all available properties for dewpoint and bubble point states corresponding to a sat record"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      // SaturationProperties record
      input Medium.SaturationProperties sat;
      // and the rest based on sat
      CompleteThermodynamicState dewStateOnePhase(state=Medium.setDewState(sat, 1),
          redeclare package Medium = Medium);
      CompleteThermodynamicState dewStateTwoPhase(state=Medium.setDewState(sat, 2),
          redeclare package Medium = Medium);
      CompleteThermodynamicState bubbleStateOnePhase(state=Medium.setBubbleState(
            sat, 1), redeclare package Medium = Medium);
      CompleteThermodynamicState bubbleStateTwoPhase(state=Medium.setBubbleState(
            sat, 2), redeclare package Medium = Medium);
    end CompleteBubbleDewStates;

    model CompleteBaseProperties
      "Compute all available two-phase medium properties from a BaseProperties model"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      // BaseProperties object
      Medium.BaseProperties baseProperties;
      // All the complete properties
      CompleteThermodynamicState completeState(redeclare package Medium = Medium,
          state=baseProperties.state);
      CompleteSaturationProperties completeSat(redeclare package Medium = Medium,
          sat=baseProperties.sat);
      CompleteFluidConstants completeConstants(redeclare package Medium = Medium);
    end CompleteBaseProperties;

    partial model TestStates "Test case with state"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      Medium.AbsolutePressure p1;
      Medium.SpecificEnthalpy h1;
      Medium.AbsolutePressure p2;
      Medium.Temperature T2;
      Medium.ThermodynamicState state1;
      Medium.ThermodynamicState state2;
      CompleteThermodynamicState completeState1(redeclare package Medium = Medium,
          state=state1);
      CompleteThermodynamicState completeState2(redeclare package Medium = Medium,
          state=state2);
    equation
      state1 = Medium.setState_ph(p1, h1);
      state2 = Medium.setState_pT(p2, T2);
    end TestStates;

    partial model TestStatesSat "Test case with state + sat records"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      Medium.AbsolutePressure p1;
      Medium.SpecificEnthalpy h1;
      Medium.AbsolutePressure p2;
      Medium.Temperature T2;
      Medium.ThermodynamicState state1;
      Medium.ThermodynamicState state2;
      Medium.SaturationProperties sat1;
      Medium.SaturationProperties sat2;
      Medium.Temperature Ts;
      Medium.AbsolutePressure ps;
      CompleteThermodynamicState completeState1(redeclare package Medium = Medium,
          state=state1);
      CompleteThermodynamicState completeState2(redeclare package Medium = Medium,
          state=state2);
      CompleteSaturationProperties completeSat1(redeclare package Medium = Medium,
          sat=sat1);
      CompleteSaturationProperties completeSat2(redeclare package Medium = Medium,
          sat=sat2);
      CompleteBubbleDewStates completeBubbleDewStates1(redeclare package Medium
          = Medium, sat=sat1);
      CompleteBubbleDewStates completeBubbleDewStates2(redeclare package Medium
          = Medium, sat=sat2);
    equation
      state1 = Medium.setState_ph(p1, h1);
      state2 = Medium.setState_pT(p2, T2);
      sat1 = Medium.setSat_p(p1);
      sat2 = Medium.setSat_T(T2);
      Ts = Medium.saturationTemperature(p1);
      ps = Medium.saturationPressure(T2);
    end TestStatesSat;

    partial model TestBasePropertiesExplicit
      "Test case using BaseProperties and explicit equations"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      CompleteBaseProperties medium1(redeclare package Medium = Medium)
        "Constant pressure, varying enthalpy";
      CompleteBaseProperties medium2(redeclare package Medium = Medium)
        "Varying pressure, constant enthalpy";
      Medium.AbsolutePressure p1;
      Medium.AbsolutePressure p2;
      Medium.SpecificEnthalpy h1;
      Medium.SpecificEnthalpy h2;
    equation
      medium1.baseProperties.p = p1;
      medium1.baseProperties.h = h1;
      medium2.baseProperties.p = p2;
      medium2.baseProperties.h = h2;
    end TestBasePropertiesExplicit;

    partial model TestBasePropertiesImplicit
      "Test case using BaseProperties and implicit equations"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      parameter Medium.SpecificEnthalpy hstart
        "Start value for specific enthalpy";
      CompleteBaseProperties medium1(redeclare package Medium = Medium,
          baseProperties(h(start=hstart)))
        "Constant pressure, varying enthalpy";
      CompleteBaseProperties medium2(redeclare package Medium = Medium,
          baseProperties(h(start=hstart)))
        "Varying pressure, constant enthalpy";
      Medium.AbsolutePressure p1;
      Medium.AbsolutePressure p2;
      Medium.Temperature T1;
      Medium.Temperature T2;
    equation
      medium1.baseProperties.p = p1;
      medium1.baseProperties.T = T1;
      medium2.baseProperties.p = p2;
      medium2.baseProperties.T = T2;
    end TestBasePropertiesImplicit;

    partial model TestBasePropertiesDynamic
      "Test case using BaseProperties and dynamic equations"
      replaceable package Medium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);
      parameter SI.Volume V=1 "Storage Volume";
      parameter Real p_atm=101325 "Atmospheric pressure";
      parameter SI.Temperature Tstart=300;
      parameter SI.SpecificEnthalpy hstart=1e5;
      parameter SI.Pressure pstart=p_atm;
      parameter Real Kv0 "Valve flow coefficient";
      Medium.BaseProperties medium(
        preferredMediumStates=true,
        h(start=hstart),
        p(start=pstart));
      SI.Mass M;
      SI.Energy U;
      SI.MassFlowRate win(start=100);
      SI.MassFlowRate wout;
      SI.SpecificEnthalpy hin;
      SI.SpecificEnthalpy hout;
      SI.Power Q;
      Real Kv;
    equation
      // Mass & energy balance equation
      M = medium.d*V;
      U = medium.u*M;
      der(M) = win - wout;
      der(U) = win*hin - wout*hout + Q;
      // Outlet valve equation
      wout = Kv*sqrt(medium.d*(medium.p - p_atm));
      hout = medium.h;
    initial equation
      // Steady state equations
      der(medium.p) = 0;
      der(medium.h) = 0;
      annotation (experiment(StopTime=80, Tolerance=1e-007));
    end TestBasePropertiesDynamic;

    partial model CompareModelicaTestMedium
      "Comparison between Modelica and TestMedium models"
      replaceable package ModelicaMedium =
          Modelica.Media.Water.WaterIF97_ph
        constrainedby Modelica.Media.Interfaces.PartialMedium
        annotation(choicesAllMatching=true);
      replaceable package TestMedium =
          ExternalMedia.Test.GenericModels.DummyTwoPhaseMedium
        constrainedby Modelica.Media.Interfaces.PartialMedium
        annotation(choicesAllMatching=true);
      CompleteBaseProperties modelicaMedium(redeclare package Medium =
            ModelicaMedium) "Modelica medium model";
      CompleteBaseProperties testMedium(redeclare package Medium = TestMedium)
        "TestMedium medium model";
      parameter Modelica.SIunits.Pressure pmin;
      parameter Modelica.SIunits.Pressure pmax;
      parameter Modelica.SIunits.SpecificEnthalpy hmin;
      parameter Modelica.SIunits.SpecificEnthalpy hmax;
    equation
      modelicaMedium.baseProperties.p = pmin + (pmax - pmin)*time;
      modelicaMedium.baseProperties.h = hmin + (hmax - hmin)*time;
      testMedium.baseProperties.p = pmin + (pmax - pmin)*time;
      testMedium.baseProperties.h = hmin + (hmax - hmin)*time;
    end CompareModelicaTestMedium;

    partial model TestRunner
      "A collection of models to test the states and base properties"
      extends Modelica.Icons.Example;

      replaceable package Medium = Modelica.Media.Water.StandardWater
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);

      Medium.AbsolutePressure p_in;
      Medium.SpecificEnthalpy h_in;
      Medium.Temperature T_in;
      Medium.SaturationProperties sat_in;
      parameter Medium.SpecificEnthalpy hstart = 2e5
        "Start value for specific enthalpy";

      model TestStates_Impl
        extends ExternalMedia.Test.GenericModels.TestStates;
        input Medium.AbsolutePressure _p1;
        input Medium.SpecificEnthalpy _h1;
        input Medium.AbsolutePressure _p2;
        input Medium.Temperature _T2;
      equation
        p1 = _p1;
        h1 = _h1;
        p2 = _p2;
        T2 = _T2;
      end TestStates_Impl;

      TestStates_Impl testStates(
        redeclare package Medium = Medium,
        _p1=p_in,
        _h1=h_in,
        _p2=p_in*1.15,
        _T2=T_in) annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

      model TestStatesSat_Impl
        extends ExternalMedia.Test.GenericModels.TestStatesSat;
        input Medium.AbsolutePressure _p1;
        input Medium.SpecificEnthalpy _h1;
        input Medium.AbsolutePressure _p2;
        input Medium.Temperature _T2;
      equation
        p1 = _p1;
        h1 = _h1;
        p2 = _p2;
        T2 = _T2;
      end TestStatesSat_Impl;

      TestStatesSat_Impl testStatesSat(
        redeclare package Medium = Medium,
        _p1=p_in,
        _h1=h_in,
        _p2=p_in*1.15,
        _T2=T_in) annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

      model TestBasePropertiesExplicit_Impl
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesExplicit;
        input Medium.AbsolutePressure _p1;
        input Medium.SpecificEnthalpy _h1;
        input Medium.AbsolutePressure _p2;
        input Medium.SpecificEnthalpy _h2;
      equation
        p1 = _p1;
        h1 = _h1;
        p2 = _p2;
        h2 = _h2;
      end TestBasePropertiesExplicit_Impl;

      TestBasePropertiesExplicit_Impl testBasePropertiesExplicit(
        redeclare package Medium = Medium,
        _p1=p_in,
        _h1=h_in,
        _p2=p_in*1.15,
        _h2=h_in) annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

      model TestBasePropertiesImplicit_Impl
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesImplicit;
        input Medium.AbsolutePressure _p1;
        input Medium.Temperature _T1;
        input Medium.AbsolutePressure _p2;
        input Medium.Temperature _T2;
      equation
        p1 = _p1;
        T1 = _T1;
        p2 = _p2;
        T2 = _T2;
      end TestBasePropertiesImplicit_Impl;

      TestBasePropertiesImplicit_Impl testBasePropertiesImplicit(
        redeclare package Medium = Medium,
        _p1=p_in,
        _T1=T_in,
        _p2=p_in*1.15,
        _T2=T_in,
        hstart=hstart)
                  annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

      model TestBasePropertiesDynamic_Impl
        extends ExternalMedia.Test.GenericModels.TestBasePropertiesDynamic;
        input Medium.SpecificEnthalpy _h1;
      equation
        // Inlet equations
        win = 1;
        hin = _h1;
        // Input variables
        Kv = if time < 50 then Kv0 else Kv0*1.1;
        Q = if time < 1 then 0 else 1e4;
      end TestBasePropertiesDynamic_Impl;

      TestBasePropertiesDynamic_Impl testBasePropertiesDynamic(Tstart=300,
        hstart=4e5,
        pstart=1e6,
        Kv0=1.00801e-4,
        V=0.1,
        redeclare package Medium = Medium,_h1=h_in)
        annotation (Placement(transformation(extent={{0,20},{20,40}})));
      annotation (experiment(StopTime=80, Tolerance=1e-007));
    end TestRunner;

    model TestRunnerTwoPhase
      "A collection of models to test the saturation states"
      extends Modelica.Icons.Example;
      extends ExternalMedia.Test.GenericModels.TestRunner(        redeclare
          package Medium =
            TwoPhaseMedium);

      replaceable package TwoPhaseMedium = Modelica.Media.Water.StandardWater
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);

      parameter Medium.AbsolutePressure p_start = 1e5;
    algorithm
      assert(Medium.fluidConstants[1].criticalPressure>p_start, "You have to start below the critical pressure.");
    equation
      p_in = p_start+0.5*(Medium.fluidConstants[1].criticalPressure-p_start)*time;
      sat_in = Medium.setSat_p(p=p_in);
      h_in = Medium.bubbleEnthalpy(sat_in);
      T_in = Medium.saturationTemperature_sat(sat_in);
    end TestRunnerTwoPhase;

    model TestRunnerTranscritical
      "A collection of models to test the transcritical states"
      extends Modelica.Icons.Example;
      extends ExternalMedia.Test.GenericModels.TestRunner(        redeclare
          package Medium =
            TwoPhaseMedium);

      replaceable package TwoPhaseMedium = Modelica.Media.Water.StandardWater
        constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
        annotation(choicesAllMatching=true);

      parameter Medium.AbsolutePressure p_start = 1e5;
    algorithm
      assert(Medium.fluidConstants[1].criticalPressure>p_start, "You have to start below the critical pressure.");
    equation
      p_in = p_start+1.5*(Medium.fluidConstants[1].criticalPressure-p_start)*time;
      sat_in = Medium.setSat_p(p=p_in);
      h_in = Medium.bubbleEnthalpy(sat_in);
      T_in = Medium.saturationTemperature_sat(sat_in);
    end TestRunnerTranscritical;
  end GenericModels;

  package MSL_Models
    "Test cases taken from the Modelica Standard Library, medium redefinition needed."
    extends Modelica.Icons.BasesPackage;

    model BranchingDynamicPipes "From Fluid library, needs medium definition"
      extends Modelica.Fluid.Examples.BranchingDynamicPipes(
        redeclare package Medium=NewMedium);

      replaceable package NewMedium=Modelica.Media.Water.StandardWater constrainedby
        Modelica.Media.Interfaces.PartialMedium
        annotation(choicesAllMatching=true);

      //replaceable package NewMedium=ExternalMedia.Examples.WaterCoolProp;
      //replaceable package NewMedium=Modelica.Media.Water.StandardWater;
      //replaceable package NewMedium=ExternalMedia.Examples.WaterIF97;
    end BranchingDynamicPipes;

    model IncompressibleFluidNetwork
      "From Fluid library, needs medium definition"
      extends Modelica.Fluid.Examples.IncompressibleFluidNetwork(
        redeclare package Medium=NewMedium);
      replaceable package NewMedium=Modelica.Media.Water.StandardWater constrainedby
        Modelica.Media.Interfaces.PartialMedium
        annotation(choicesAllMatching=true);
    end IncompressibleFluidNetwork;
  end MSL_Models;

  model WaterComparison "Compares different implementations of water"
    extends Modelica.Icons.Example;

    GenericModels.TestRunnerTwoPhase      testRunnerTwoPhaseWater1(
      hstart=4e5,
      redeclare package TwoPhaseMedium = ExternalMedia.Examples.WaterCoolProp,
      p_start=100000)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  end WaterComparison;
end Test;
