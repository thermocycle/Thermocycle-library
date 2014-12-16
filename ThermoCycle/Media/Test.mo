within ThermoCycle.Media;
package Test "Test medium models"
  package TestMedium "Test cases for TestMedium"
    model TestStatesSat
      "Test case using TestMedium, with baseProperties and state + sat records without explicit uniqueID handling"
      replaceable package Medium = ExternalMedia.Media.TestMedium;
      Medium.BaseProperties baseProperties1;
      Medium.BaseProperties baseProperties2;
      Medium.ThermodynamicState state1;
      Medium.ThermodynamicState state2;
      Medium.SaturationProperties sat1;
      Medium.SaturationProperties sat2;
      Medium.Temperature Ts;
      Medium.AbsolutePressure ps;
      GenericModels.CompleteThermodynamicState completeState1(
        redeclare package Medium = Medium, state = state1);
      GenericModels.CompleteThermodynamicState completeState2(
        redeclare package Medium = Medium, state = state2);
      GenericModels.CompleteSaturationProperties completeSat1(
        redeclare package Medium = Medium, sat = sat1);
      GenericModels.CompleteSaturationProperties completeSat2(
        redeclare package Medium = Medium, sat = sat2);
      GenericModels.CompleteBubbleDewStates completeBubbleDewStates1(
        redeclare package Medium = Medium, sat = sat1);
      GenericModels.CompleteBubbleDewStates completeBubbleDewStates2(
        redeclare package Medium = Medium, sat = sat1);
    equation
      baseProperties1.p = 1e5+1e5*time;
      baseProperties1.h = 1e5;
      baseProperties2.p = 1e5;
      baseProperties2.h = 1e5 + 2e5*time;
      state1 = Medium.setState_ph(1e5 + 1e5*time, 1e5);
      state2 = Medium.setState_pT(1e5, 300+ 50*time);
      sat1 = Medium.setSat_p(1e5 + 1e5*time);
      sat2 = Medium.setSat_T(300 + 50 * time);
      Ts = Medium.saturationTemperature(1e5+1e5*time);
      ps = Medium.saturationPressure(300 + 50*time);
    end TestStatesSat;

    model TestBasePropertiesExplicit
      "Test case using TestMedium and BaseProperties with explicit equations"
      replaceable package Medium = ExternalMedia.Media.TestMedium;
      ThermoCycle.Media.Test.TestMedium.GenericModels.CompleteBaseProperties medium1(
          redeclare package Medium = Medium)
        "Constant pressure, varying enthalpy";
      ThermoCycle.Media.Test.TestMedium.GenericModels.CompleteBaseProperties medium2(
          redeclare package Medium = Medium)
        "Varying pressure, constant enthalpy";
    equation
      medium1.baseProperties.p = 1e5+1e5*time;
      medium1.baseProperties.h = 1e5;
      medium2.baseProperties.p = 1e5;
      medium2.baseProperties.h = 1e5 + 2e5*time;
    end TestBasePropertiesExplicit;

    model TestBasePropertiesImplicit
      "Test case using TestMedium and BaseProperties with implicit equations"
      replaceable package Medium = ExternalMedia.Media.TestMedium;
      ThermoCycle.Media.Test.TestMedium.GenericModels.CompleteBaseProperties medium1(
          redeclare package Medium = Medium, baseProperties(h(start=1e5)))
        "Constant pressure, varying enthalpy";
      ThermoCycle.Media.Test.TestMedium.GenericModels.CompleteBaseProperties medium2(
          redeclare package Medium = Medium, baseProperties(h(start=1e5)))
        "Varying pressure, constant enthalpy";
    equation
      medium1.baseProperties.p = 1e5*time;
      medium1.baseProperties.T = 300 + 25*time;
      medium2.baseProperties.p = 1e5+1e5*time;
      medium2.baseProperties.T = 300;
    end TestBasePropertiesImplicit;

    model TestBasePropertiesDynamic
      "Test case using TestMedium and dynamic equations"
      replaceable package Medium = ExternalMedia.Media.TestMedium;
      parameter Modelica.SIunits.Volume V=1 "Storage Volume";
      parameter Real p_atm = 101325 "Atmospheric pressure";
      parameter Modelica.SIunits.Temperature Tstart=300;
      parameter Real Kv0 = 1.00801e-2 "Valve flow coefficient";
      Medium.BaseProperties medium(preferredMediumStates = true);
      Modelica.SIunits.Mass M;
      Modelica.SIunits.Energy U;
      Modelica.SIunits.MassFlowRate win(start=100);
      Modelica.SIunits.MassFlowRate wout;
      Modelica.SIunits.SpecificEnthalpy hin;
      Modelica.SIunits.SpecificEnthalpy hout;
      Modelica.SIunits.Power Q;
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
      wout = Kv * sqrt(medium.d*(medium.p - p_atm));
      hout = medium.h;
      // Input variables
      Kv = if time<50 then Kv0 else Kv0*1.1;
      Q = if time < 1 then 0 else 1e7;
    initial equation
      // Initial conditions
      // Fixed initial states
      // medium.p = 2e5;
      // medium.h = 1e5;
      // Steady state equations
      der(medium.p) = 0;
      der(medium.h) = 0;
      annotation (experiment(StopTime=80, Tolerance=1e-007),experimentSetupOutput(
          equdistant=false));
    end TestBasePropertiesDynamic;

    package GenericModels
      "Contains generic models to use for thorough medium model testing"
      model CompleteFluidConstants
        "Compute all available medium fluid constants"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // Fluid constants
        Medium.Temperature Tc = Medium.fluidConstants[1].criticalTemperature;
        Medium.AbsolutePressure pc = Medium.fluidConstants[1].criticalPressure;
        Medium.MolarVolume vc = Medium.fluidConstants[1].criticalMolarVolume;
        Medium.MolarMass MM = Medium.fluidConstants[1].molarMass;
      end CompleteFluidConstants;

      model CompleteThermodynamicState
        "Compute all available two-phase medium properties from a ThermodynamicState model"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // ThermodynamicState record
        input Medium.ThermodynamicState state;
        // Medium properties
        Medium.AbsolutePressure p =                Medium.pressure(state);
        Medium.SpecificEnthalpy h =                Medium.specificEnthalpy(state);
        Medium.Temperature T =                     Medium.temperature(state);
        Medium.Density d =                         Medium.density(state);
        Medium.SpecificEntropy s =                 Medium.specificEntropy(state);
        Medium.SpecificHeatCapacity cp =           Medium.specificHeatCapacityCp(state);
        Medium.SpecificHeatCapacity cv =           Medium.specificHeatCapacityCv(state);
        Medium.IsobaricExpansionCoefficient beta = Medium.isobaricExpansionCoefficient(state);
        Modelica.SIunits.IsothermalCompressibility kappa=
            Medium.isothermalCompressibility(state);
        Medium.DerDensityByPressure d_d_dp_h =     Medium.density_derp_h(state);
        Medium.DerDensityByEnthalpy d_d_dh_p =     Medium.density_derh_p(state);
        Medium.MolarMass MM =                      Medium.molarMass(state);
      end CompleteThermodynamicState;

      model CompleteSaturationProperties
        "Compute all available saturation properties from a SaturationProperties record"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // SaturationProperties record
        input Medium.SaturationProperties sat;
        // Saturation properties
        Medium.Temperature Ts =      Medium.saturationTemperature_sat(sat);
        Medium.Density dl =          Medium.bubbleDensity(sat);
        Medium.Density dv =          Medium.dewDensity(sat);
        Medium.SpecificEnthalpy hl = Medium.bubbleEnthalpy(sat);
        Medium.SpecificEnthalpy hv = Medium.dewEnthalpy(sat);
        Real d_Ts_dp =               Medium.saturationTemperature_derp_sat(sat);
        Real d_dl_dp =               Medium.dBubbleDensity_dPressure(sat);
        Real d_dv_dp =               Medium.dDewDensity_dPressure(sat);
        Real d_hl_dp =               Medium.dBubbleEnthalpy_dPressure(sat);
        Real d_hv_dp =               Medium.dDewEnthalpy_dPressure(sat);
      end CompleteSaturationProperties;

      model CompleteBubbleDewStates
        "Compute all available properties for dewpoint and bubble point states corresponding to a sat record"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // SaturationProperties record
        input Medium.SaturationProperties sat;
        CompleteThermodynamicState dewStateOnePhase(
          state=Medium.setDewState(sat, 1), redeclare package Medium = Medium);
        CompleteThermodynamicState dewStateTwoPhase(
          state=Medium.setDewState(sat, 2), redeclare package Medium = Medium);
        CompleteThermodynamicState bubbleStateOnePhase(
          state=Medium.setBubbleState(sat, 1), redeclare package Medium = Medium);
        CompleteThermodynamicState bubbleStateTwoPhase(
          state=Medium.setBubbleState(sat, 2), redeclare package Medium = Medium);
      end CompleteBubbleDewStates;

      model CompleteBaseProperties
        "Compute all available two-phase medium properties from a BaseProperties model"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // BaseProperties object
        Medium.BaseProperties baseProperties;
        // All the complete properties
        CompleteThermodynamicState completeState(
          redeclare package Medium = Medium, state=baseProperties.state);
        CompleteSaturationProperties completeSat(
          redeclare package Medium = Medium, sat=baseProperties.sat);
        CompleteFluidConstants completeConstants(
          redeclare package Medium = Medium);
        CompleteBubbleDewStates completeBubbleDewStates(
            redeclare package Medium = Medium, sat=baseProperties.sat);
      end CompleteBaseProperties;
    end GenericModels;

  end TestMedium;

  package FluidProp "Test cases for FluidPropMedium"
    partial package GenericModels "Generic models for FluidProp media tests"
      model CompleteFluidConstants
        "Compute all available medium fluid constants"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // Fluid constants
        Medium.Temperature Tc = Medium.fluidConstants[1].criticalTemperature;
        Medium.AbsolutePressure pc = Medium.fluidConstants[1].criticalPressure;
        Medium.MolarVolume vc = Medium.fluidConstants[1].criticalMolarVolume;
        Medium.MolarMass MM = Medium.fluidConstants[1].molarMass;
      end CompleteFluidConstants;

      model CompleteThermodynamicState
        "Compute all available two-phase medium properties from a ThermodynamicState model"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // ThermodynamicState record
        input Medium.ThermodynamicState state;
        // Medium properties
        Medium.AbsolutePressure p =                Medium.pressure(state);
        Medium.SpecificEnthalpy h =                Medium.specificEnthalpy(state);
        Medium.Temperature T =                     Medium.temperature(state);
        Medium.Density d =                         Medium.density(state);
        Medium.SpecificEntropy s =                 Medium.specificEntropy(state);
        Medium.SpecificHeatCapacity cp =           Medium.specificHeatCapacityCp(state);
        Medium.SpecificHeatCapacity cv =           Medium.specificHeatCapacityCv(state);
      // Not yet implemented in FluidProp
        Medium.IsobaricExpansionCoefficient beta = Medium.isobaricExpansionCoefficient(state);
        Modelica.SIunits.IsothermalCompressibility kappa=
            Medium.isothermalCompressibility(state);
        Medium.DerDensityByPressure d_d_dp_h =     Medium.density_derp_h(state);
        Medium.DerDensityByEnthalpy d_d_dh_p =     Medium.density_derh_p(state);
        Medium.MolarMass MM =                      Medium.molarMass(state);
      end CompleteThermodynamicState;

      model CompleteSaturationProperties
        "Compute all available saturation properties from a SaturationProperties record"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // SaturationProperties record
        input Medium.SaturationProperties sat;
        // Saturation properties
        Medium.Temperature Ts =      Medium.saturationTemperature_sat(sat);
        Medium.Density dl =          Medium.bubbleDensity(sat);
        Medium.Density dv =          Medium.dewDensity(sat);
        Medium.SpecificEnthalpy hl = Medium.bubbleEnthalpy(sat);
        Medium.SpecificEnthalpy hv = Medium.dewEnthalpy(sat);
        Real d_Ts_dp =               Medium.saturationTemperature_derp_sat(sat);
        Real d_dl_dp =               Medium.dBubbleDensity_dPressure(sat);
        Real d_dv_dp =               Medium.dDewDensity_dPressure(sat);
        Real d_hl_dp =               Medium.dBubbleEnthalpy_dPressure(sat);
        Real d_hv_dp =               Medium.dDewEnthalpy_dPressure(sat);
      end CompleteSaturationProperties;

      model CompleteBubbleDewStates
        "Compute all available properties for dewpoint and bubble point states corresponding to a sat record"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        // SaturationProperties record
        input Medium.SaturationProperties sat;
        CompleteThermodynamicState dewStateOnePhase(state=
              Medium.setDewState(sat, 1), redeclare package Medium = Medium);
        CompleteThermodynamicState dewStateTwoPhase(state=
              Medium.setDewState(sat, 2), redeclare package Medium = Medium);
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
        CompleteThermodynamicState completeState(
          redeclare package Medium = Medium, state=baseProperties.state);
        CompleteSaturationProperties completeSat(
          redeclare package Medium = Medium, sat=baseProperties.sat);
        CompleteFluidConstants completeConstants(
          redeclare package Medium = Medium);
        CompleteBubbleDewStates completeBubbleDewStates(
          redeclare package Medium = Medium, sat=baseProperties.sat);
      end CompleteBaseProperties;

      partial model TestStatesSat
        "Test case with baseProperties and state + sat records"
        replaceable package Medium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        Medium.AbsolutePressure p1;
        Medium.SpecificEnthalpy h1;
        Medium.AbsolutePressure p2;
        Medium.SpecificEnthalpy h2;
        Medium.Temperature T2;
        Medium.BaseProperties baseProperties1;
        Medium.BaseProperties baseProperties2;
        Medium.ThermodynamicState state1;
        Medium.ThermodynamicState state2;
        Medium.SaturationProperties sat1;
        Medium.SaturationProperties sat2;
        Medium.Temperature Ts;
        Medium.AbsolutePressure ps;
        CompleteThermodynamicState
          completeState1(redeclare package Medium = Medium, state=state1);
        CompleteThermodynamicState
          completeState2(redeclare package Medium = Medium, state=state2);
        CompleteSaturationProperties
          completeSat1(redeclare package Medium = Medium, sat=sat1);
        CompleteSaturationProperties
          completeSat2(redeclare package Medium = Medium, sat=sat2);
        CompleteBubbleDewStates
          completeBubbleDewStates1(redeclare package Medium = Medium, sat=sat1);
        CompleteBubbleDewStates
          completeBubbleDewStates2(redeclare package Medium = Medium, sat=sat1);
      equation
        baseProperties1.p = p1;
        baseProperties1.h = h1;
        baseProperties2.p = p2;
        baseProperties2.h = h2;
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
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
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
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        parameter Medium.SpecificEnthalpy hstart
          "Start value for specific enthalpy";
        CompleteBaseProperties medium1(redeclare package Medium = Medium,
                                       baseProperties(h(start = hstart)))
          "Constant pressure, varying enthalpy";
        CompleteBaseProperties medium2(redeclare package Medium = Medium,
                                       baseProperties(h(start = hstart)))
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
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
      parameter Modelica.SIunits.Volume V=1 "Storage Volume";
      parameter Real p_atm = 101325 "Atmospheric pressure";
      parameter Modelica.SIunits.Temperature Tstart=300;
      parameter Modelica.SIunits.SpecificEnthalpy hstart;
      parameter Real Kv0 "Valve flow coefficient";
      Medium.BaseProperties medium(preferredMediumStates = true,
                                   h(start=1e5));
      Modelica.SIunits.Mass M;
      Modelica.SIunits.Energy U;
      Modelica.SIunits.MassFlowRate win(start=100);
      Modelica.SIunits.MassFlowRate wout;
      Modelica.SIunits.SpecificEnthalpy hin;
      Modelica.SIunits.SpecificEnthalpy hout;
      Modelica.SIunits.Power Q;
      Real Kv;
    equation
      // Mass & energy balance equation
      M = medium.d*V;
      U = medium.u*M;
      der(M) = win - wout;
      der(U) = win*hin - wout*hout + Q;
      // Outlet valve equation
      wout = Kv * sqrt(medium.d*(medium.p - p_atm));
      hout = medium.h;
    initial equation
      // Steady state equations
      der(medium.p) = 0;
      der(medium.h) = 0;
      annotation (experiment(StopTime=80, Tolerance=1e-007),experimentSetupOutput(
            equdistant=false));
    end TestBasePropertiesDynamic;

      partial model CompareModelicaFluidProp
        "Comparison between Modelica and FluidProp models"
        replaceable package ModelicaMedium =
            Modelica.Media.Interfaces.PartialTwoPhaseMedium;
        replaceable package FluidPropMedium =
            CoolProp2Modelica.Interfaces.FluidPropMedium;
        CompleteBaseProperties modelicaMedium(
          redeclare package Medium = ModelicaMedium) "Modelica medium model";
        CompleteBaseProperties fluidPropMedium(
          redeclare package Medium = FluidPropMedium) "FluidProp medium model";
        parameter Modelica.SIunits.Pressure pmin;
        parameter Modelica.SIunits.Pressure pmax;
        parameter Modelica.SIunits.SpecificEnthalpy hmin;
        parameter Modelica.SIunits.SpecificEnthalpy hmax;
      equation
        modelicaMedium.baseProperties.p = pmin + (pmax-pmin)*time;
        modelicaMedium.baseProperties.h = hmin + (hmax-hmin)*time;
        fluidPropMedium.baseProperties.p = pmin + (pmax-pmin)*time;
        fluidPropMedium.baseProperties.h = hmin + (hmax-hmin)*time;
      end CompareModelicaFluidProp;
    end GenericModels;

    package IF95 "Test suite for the FluidProp-Refprop IF95 medium model"
      model TestStatesSat
        "Test case with baseProperties and state + sat records"
        extends GenericModels.TestStatesSat(
          redeclare package Medium = CoolProp2Modelica.Media.WaterIF95_FP);
      equation
        p1 = 1e5 + time*1e5;
        h1 = 1e5;
        p2 = 1e5;
        h2 = 1e5 + time*2e5;
        T2 = 300 + 50*time;
      end TestStatesSat;

      model TestBasePropertiesExplicit
        "Test case using BaseProperties and explicit equations"
        extends GenericModels.TestBasePropertiesExplicit(
          redeclare package Medium = CoolProp2Modelica.Media.WaterIF95_FP);
      equation
        p1 = 1e5+1e5*time;
        h1 = 1e5;
        p2 = 1e5;
        h2 = 1e5 + 2e5*time;
      end TestBasePropertiesExplicit;

      model TestBasePropertiesImplicit
        "Test case using BaseProperties and implicit equations"
        extends GenericModels.TestBasePropertiesImplicit(
          redeclare package Medium = CoolProp2Modelica.Media.WaterIF95_FP,
          hstart = 1e5);
      equation
        p1 = 1e5+1e5*time;
        T1 = 300 + 25*time;
        p2 = 1e5+1e5*time;
        T2 = 300;
      end TestBasePropertiesImplicit;

    model TestBasePropertiesDynamic
        "Test case using BaseProperties and dynamic equations"
      extends GenericModels.TestBasePropertiesDynamic(
        redeclare package Medium = CoolProp2Modelica.Media.WaterIF95_FP,
        Tstart = 300,
        Kv0 = 1.00801e-2);
    equation
      // Inlet pump equations
      medium.p - p_atm = 2e5 - (1e5/100^2)*win^2;
      hin = 1e5;
      // Input variables
      Kv = if time<50 then Kv0 else Kv0*1.1;
      Q = if time < 1 then 0 else 1e7;
      annotation (experiment(StopTime=80, Tolerance=1e-007),experimentSetupOutput(
            equdistant=false));
    end TestBasePropertiesDynamic;

      model TestBasePropertiesExplicit_ModelicaIF97
        "Test case using FluidProp IF95 and explicit equations"
        extends TestBasePropertiesExplicit(
          redeclare package Medium = Modelica.Media.Water.StandardWater);
      end TestBasePropertiesExplicit_ModelicaIF97;

      model CompareModelicaFluidProp_liquid
        "Comparison between Modelica IF97 and FluidProp IF95 models - liquid"
        extends GenericModels.CompareModelicaFluidProp(
          redeclare package ModelicaMedium =
              Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium =
              CoolProp2Modelica.Media.WaterIF95_FP,
          pmin = 1e5,
          pmax = 1e5,
          hmin = 1e5,
          hmax = 4e5);
      end CompareModelicaFluidProp_liquid;

      model CompareModelicaFluidProp_twophase
        "Comparison between Modelica IF97 and FluidProp IF95 models - liquid"
        extends GenericModels.CompareModelicaFluidProp(
          redeclare package ModelicaMedium =
              Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium =
              CoolProp2Modelica.Media.WaterIF95_FP,
          pmin = 60e5,
          pmax = 60e5,
          hmin = 1000e3,
          hmax = 2000e3);
      end CompareModelicaFluidProp_twophase;

      model CompareModelicaFluidProp_vapour
        "Comparison between Modelica IF97 and FluidProp IF95 models - liquid"
        extends GenericModels.CompareModelicaFluidProp(
          redeclare package ModelicaMedium =
              Modelica.Media.Water.StandardWater,
          redeclare package FluidPropMedium =
              CoolProp2Modelica.Media.WaterIF95_FP,
          pmin = 60e5,
          pmax = 60e5,
          hmin = 2800e3,
          hmax = 3200e3);
      end CompareModelicaFluidProp_vapour;
    end IF95;
  end FluidProp;

  package WrongMedium "Test cases with wrong medium models"
  model TestWrongMedium
      "Test the error reporting messages for unsupported external media"
    package Medium = ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium; //CoolProp2Modelica.Interfaces.ExternalTwoPhaseMedium;
    Medium.BaseProperties medium;
  equation
    medium.p = 1e5;
    medium.h = 1e5;
  end TestWrongMedium;
  end WrongMedium;

  package benchmark "Comparison of computational speed for different libraries"
    package fluids
      package propane_CP
        "R290, computation of Propane Properties using CoolProp"
        extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
        mediumName="TestMedium",
        libraryName="CoolProp",
        substanceName="propane",
        ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
        annotation ();
      end propane_CP;

      package propane_FPST
        "Propane properties using the StanMix library of FluidProp"
        extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
        mediumName="TestMedium",
        libraryName="FluidProp.StanMix",
        substanceName="propane",
        ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
        annotation ();
      end propane_FPST;

      package propane_FPRP
        "Propane properties using Refprop through FluidProp (requires the full version of FluidProp)"
        extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
        mediumName="TestMedium",
        libraryName="FluidProp.RefProp",
        substanceName="propane",
        ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
        annotation ();
      end propane_FPRP;

      package propane_CP_TTSE
        "R290, computation of Propane Properties using CoolProp"
        extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
        mediumName="TestMedium",
        libraryName="CoolProp",
        substanceName="propane|enable_TTSE=1",
        ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
        annotation ();
      end propane_CP_TTSE;

      package propane_CP_transport
        "R290, computation of Propane Properties using CoolProp"
        extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
        mediumName="TestMedium",
        libraryName="CoolProp",
        substanceName="propane|calc_transport=0",
        ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
        annotation ();
      end propane_CP_transport;
    end fluids;

    package test
      model propane_CP_baseproperties
        replaceable package wf = benchmark.fluids.propane_CP constrainedby
          Modelica.Media.Interfaces.PartialMedium "Medium model";
        wf.BaseProperties fluid "Properties of the two-phase fluid";
        Modelica.SIunits.SpecificEnthalpy h;
        Modelica.SIunits.Pressure p;

      equation
        p = 1E5;
        h = -1E5 + time*1E5;

        fluid.p = p;
        fluid.h = h;

        annotation (experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"), __Dymola_experimentSetupOutput);
      end propane_CP_baseproperties;

      model propane_CP_ThermodynamicState
        "ThermodynamicState is faster since it does not call the saturation properties"
        replaceable package wf = benchmark.fluids.propane_CP constrainedby
          Modelica.Media.Interfaces.PartialMedium "Medium model";
        wf.ThermodynamicState fluid "Properties of the two-phase fluid";
        Modelica.SIunits.SpecificEnthalpy h;
        Modelica.SIunits.Pressure p;
      equation
        p = 1E5;
        h = -1E5 + time*1E5;
        fluid = wf.setState_ph(p=p,h=h);
        annotation (experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"), __Dymola_experimentSetupOutput);
      end propane_CP_ThermodynamicState;

      model propane_FPSM_baseproperties
        replaceable package wf =  benchmark.fluids.propane_FPST
          constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
        wf.BaseProperties fluid "Properties of the two-phase fluid";
        Modelica.SIunits.SpecificEnthalpy h;
        Modelica.SIunits.Pressure p;

      equation
        p = 1E5;
        h = -7E5 + time*1E5;

        fluid.p = p;
        fluid.h = h;

        annotation (experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"), __Dymola_experimentSetupOutput);
      end propane_FPSM_baseproperties;

      model propane_FPSM_ThermodynamicState
        "ThermodynamicState is faster since it does not call the saturation properties"
        replaceable package wf = benchmark.fluids.propane_FPST constrainedby
          Modelica.Media.Interfaces.PartialMedium "Medium model";
        wf.ThermodynamicState fluid "Properties of the two-phase fluid";
        Modelica.SIunits.SpecificEnthalpy h;
        Modelica.SIunits.Pressure p;
      equation
        p = 1E5;
        h = -7E5 + time*1E5;
        fluid = wf.setState_ph(p=p,h=h);
        annotation (experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"), __Dymola_experimentSetupOutput);
      end propane_FPSM_ThermodynamicState;

      model propane_FPRP_ThermodynamicState
        "ThermodynamicState is faster since it does not call the saturation properties"
        replaceable package wf = benchmark.fluids.propane_FPRP constrainedby
          Modelica.Media.Interfaces.PartialMedium "Medium model";
        wf.ThermodynamicState fluid "Properties of the two-phase fluid";
        Modelica.SIunits.SpecificEnthalpy h;
        Modelica.SIunits.Pressure p;
      equation
        p = 1E5;
        h = 1E5 + time*1E5;
        fluid = wf.setState_ph(p=p,h=h);
        annotation (experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"), __Dymola_experimentSetupOutput);
      end propane_FPRP_ThermodynamicState;

      model propane_FPRP_baseproperties
        replaceable package wf =  benchmark.fluids.propane_FPRP
          constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
        wf.BaseProperties fluid "Properties of the two-phase fluid";
        Modelica.SIunits.SpecificEnthalpy h;
        Modelica.SIunits.Pressure p;

      equation
        p = 1E5;
        h = -1E5 + time*1E5;

        fluid.p = p;
        fluid.h = h;

        annotation (experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"), __Dymola_experimentSetupOutput);
      end propane_FPRP_baseproperties;

      model propane_CP_TTSE
        "ThermodynamicState is faster since it does not call the saturation properties"
        replaceable package wf = benchmark.fluids.propane_CP_TTSE
          constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
        wf.ThermodynamicState fluid "Properties of the two-phase fluid";
        Modelica.SIunits.SpecificEnthalpy h;
        Modelica.SIunits.Pressure p;
      equation
        p = 1E5;
        h = -1E5 + time*1E5;
        fluid = wf.setState_ph(p=p,h=h);
        annotation (experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"), __Dymola_experimentSetupOutput);
      end propane_CP_TTSE;

      model propane_CP_transport
        "ThermodynamicState is faster since it does not call the saturation properties"
        replaceable package wf = benchmark.fluids.propane_CP_transport
          constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
        wf.ThermodynamicState fluid "Properties of the two-phase fluid";
        Modelica.SIunits.SpecificEnthalpy h;
        Modelica.SIunits.Pressure p;
      equation
        p = 1E5;
        h = -1E5 + time*1E5;
        fluid = wf.setState_ph(p=p,h=h);
        annotation (experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"), __Dymola_experimentSetupOutput);
      end propane_CP_transport;

      model propane_TILMedia

        TILMedia.Refrigerant refrigerant(
          refrigerantName="Refprop.PROPANE",
          inputChoice=TILMedia.Internals.InputChoicesRefrigerant.ph,
          computeTransportProperties=false,
          interpolateTransportProperties=false,
          computeSurfaceTension=false)
          annotation (extent=[-48,24; -28,44]);

      equation
        refrigerant.p = 1e5;
        refrigerant.h = -1E5 + time*1E5;

          annotation (                                                   Diagram,
          experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"),
          __Dymola_experimentSetupOutput);
      end propane_TILMedia;

      model propane_TILMedia_transport

        TILMedia.Refrigerant refrigerant(
          refrigerantName="Refprop.PROPANE",
          inputChoice=TILMedia.Internals.InputChoicesRefrigerant.ph,
          computeTransportProperties=true,
          interpolateTransportProperties=false,
          computeSurfaceTension=false)
          annotation (extent=[-48,24; -28,44]);

      equation
        refrigerant.p = 1e5;
        refrigerant.h = -1E5 + time*1E5;

          annotation (                                                   Diagram,
          experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"),
          __Dymola_experimentSetupOutput);
      end propane_TILMedia_transport;

      model propane_TILMedia_interptransport

        TILMedia.Refrigerant refrigerant(
          refrigerantName="Refprop.PROPANE",
          inputChoice=TILMedia.Internals.InputChoicesRefrigerant.ph,
          computeTransportProperties=false,
          interpolateTransportProperties=true,
          computeSurfaceTension=false)
          annotation (extent=[-48,24; -28,44]);

      equation
        refrigerant.p = 1e5;
        refrigerant.h = -1E5 + time*1E5;

          annotation (                                                   Diagram,
          experiment(
            StopTime=10,
            __Dymola_NumberOfIntervals=20000,
            __Dymola_Algorithm="Euler"),
          __Dymola_experimentSetupOutput);
      end propane_TILMedia_interptransport;

      model propane_TILMedia_surfacetension

        TILMedia.Refrigerant refrigerant(
          refrigerantName="Refprop.PROPANE",
          inputChoice=TILMedia.Internals.InputChoicesRefrigerant.ph,
          computeTransportProperties=false,
          interpolateTransportProperties=false,
          computeSurfaceTension=true)
          annotation (extent=[-48,24; -28,44]);

      equation
        refrigerant.p = 1e5;
        refrigerant.h = -1E5 + time*1E5;

          annotation (                                                   Diagram,
          experiment(
            StopTime=1000,
            NumberOfIntervals=2000,
            Algorithm="Euler"),
          __Dymola_experimentSetupOutput);
      end propane_TILMedia_surfacetension;
    end test;
    annotation ();
  end benchmark;

  package TestFunctions
    model TestIsentropicExpansion "Test the function for isentropic enthalpy"
      replaceable package Medium =
          ThermoCycle_BDversion.Media.R601_CP constrainedby
        Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
      Medium.SpecificEnthalpy h_in;
      Medium.AbsolutePressure p_in;
      Medium.ThermodynamicState state_in;
      Medium.SpecificEnthalpy h_out;
      Medium.AbsolutePressure p_out;
      Medium.ThermodynamicState state_out;
      Medium.SpecificEnthalpy h_out2;
      Medium.AbsolutePressure p_out2;
      Medium.ThermodynamicState state_out2;
      Medium.SpecificEntropy s_out2;
    equation
      h_in      = 300e3;
      p_in      = 10e5;
      state_in  = Medium.setState_phX(p_in,h_in);
      h_out     = Medium.isentropicEnthalpy(p_out,state_in);
      p_out     = 2e5;
      state_out = Medium.setState_phX(p_out,h_out);

      s_out2    = Medium.specificEntropy(state_in);
      h_out2    = Medium.specificEnthalpy(state_out2);
      p_out2    = p_out;
      state_out2= Medium.setState_psX(p_out2,s_out2);
    end TestIsentropicExpansion;

    model TestIsentropicExponent "Test the function for isentropic enthalpy"
      replaceable package Medium =
          ThermoCycle_BDversion.Media.R601_CP constrainedby
        Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
      Medium.SpecificEnthalpy h_in;
      //Medium.SpecificEnthalpy hA(start=h_in);
      //Medium.SpecificEnthalpy hB(start=h_in);

      Medium.AbsolutePressure p_in;
      Medium.AbsolutePressure pA(start=p_in);
      Medium.AbsolutePressure pB(start=p_in);

      Medium.ThermodynamicState state_in;
      Medium.ThermodynamicState stateA;
      Medium.ThermodynamicState stateB;

      Medium.IsentropicExponent gamma;
      Medium.IsentropicExponent gamma2;
      Medium.IsentropicExponent gamma3;

      Medium.SpecificEntropy s;
      Medium.SpecificEntropy sA(start=s);
      Medium.SpecificEntropy sB(start=s);

      Modelica.SIunits.SpecificVolume v;
      Modelica.SIunits.SpecificVolume vA;
      Modelica.SIunits.SpecificVolume vB;

      Modelica.SIunits.SpecificVolume dv=0.0001;

      Medium.Density rho;
      Real dpdv_s,dpdd_s,test1,test2;

    equation
      h_in      = 300e3+100e3*time;
      p_in      = 10e5;
      state_in  = Medium.setState_phX(p_in,h_in);
      gamma     = ExternalMedia.Media.CoolPropMedium.isentropicExponent(state_in);
      s         = Medium.specificEntropy(state_in);

      stateA  = Medium.setState_psX(pA,sA);
      stateB  = Medium.setState_psX(pB,sB);

      sA = sB;
      sB = s;

      1/v  = Medium.density(state_in);
      1/vA = Medium.density(stateA);
      1/vB = Medium.density(stateB);
      vA = v - 0.5*dv;
      vB = v + 0.5*dv;

      dpdv_s = (pA - pB) / ( vA - vB);
      gamma2 = -v / p_in * dpdv_s;

      rho    = 1/v;
      dpdd_s = (pA - pB) / ( 1/vA - 1/vB);
      gamma3 = rho / p_in * dpdd_s;

      test1 = dpdv_s;
      test2 = dpdd_s * (-1*(rho^2));

      //gamma = -v/p * (dp/dv)_s;
      //gamma = rho/p * (dp/drho)_s;

    end TestIsentropicExponent;

    model TestTwoPhaseFunctions "Test the two phase implementation"

      // Reference medium and medium models to check EXTTP
      package MediumRef =   Modelica.Media.Water.WaterIF97_ph "Medium model";
      package Medium =      ExternalMedia.Media.CoolPropMedium (substanceName="Water|calc_transport=1|debug=10|enable_TTSE=1|enable_EXTTP=0");
      package MediumEXTTP = ExternalMedia.Media.CoolPropMedium (substanceName="Water|calc_transport=1|debug=10|enable_TTSE=1|enable_EXTTP=1");

      //state to run through two-phase region, p and h as inputs
      Medium.SpecificEnthalpy h;
      Medium.AbsolutePressure p;
      Medium.ThermodynamicState      state =      Medium.setState_phX(p,h,    Medium.X_default);
      MediumRef.ThermodynamicState   stateRef =   MediumRef.setState_phX(p,h, MediumRef.X_default);
      MediumEXTTP.ThermodynamicState stateEXTTP = MediumEXTTP.setState_phX(p,h,MediumEXTTP.X_default);

      // Shortcuts to properties
      Medium.Density                d = Medium.density(state);
      Medium.Temperature            T = Medium.temperature(state);
      Medium.SpecificEntropy        s = Medium.specificEntropy(state);
      Medium.SpecificInternalEnergy u = Medium.specificInternalEnergy(state);

      //saturation props
      Medium.SaturationProperties      sat =      Medium.setSat_p(p);
      MediumRef.SaturationProperties   satRef =   MediumRef.setSat_p(p);
      MediumEXTTP.SaturationProperties satEXTTP = MediumEXTTP.setSat_p(p);

      // Other values
      Real beta,betaRef,betaEXTTP;
      Real cp,cpRef,cpEXTTP;
      Real cv,cvRef,cvEXTTP;
      Real a,aRef,aEXTTP;
      Real kappa,kappaRef,kappaEXTTP;
      Real lambda,lambdaRef,lambdaEXTTP;
      Real eta,etaRef,etaEXTTP;

    equation
      h=5e5+2.5e6*time;
      p=50e5;

      beta      = Medium.isobaricExpansionCoefficient(state);
      betaRef   = MediumRef.isobaricExpansionCoefficient(stateRef);
      betaEXTTP = MediumEXTTP.isobaricExpansionCoefficient(stateEXTTP);

      cp      = Medium.specificHeatCapacityCp(state);
      cpRef   = MediumRef.specificHeatCapacityCp(stateRef);
      cpEXTTP = MediumEXTTP.specificHeatCapacityCp(stateEXTTP);

      cv      = Medium.specificHeatCapacityCv(state);
      cvRef   = MediumRef.specificHeatCapacityCv(stateRef);
      cvEXTTP = MediumEXTTP.specificHeatCapacityCv(stateEXTTP);

      a      = Medium.velocityOfSound(state);
      aRef   = MediumRef.velocityOfSound(stateRef);
      aEXTTP = MediumEXTTP.velocityOfSound(stateEXTTP);

      kappa      = Medium.isothermalCompressibility(state);
      kappaRef   = MediumRef.isothermalCompressibility(stateRef);
      kappaEXTTP = MediumEXTTP.isothermalCompressibility(stateEXTTP);

      lambda      = Medium.thermalConductivity(state);
      lambdaRef   = MediumRef.thermalConductivity(stateRef);
      lambdaEXTTP = MediumEXTTP.thermalConductivity(stateEXTTP);

      eta      = Medium.dynamicViscosity(state);
      etaRef   = MediumRef.dynamicViscosity(stateRef);
      etaEXTTP = MediumEXTTP.dynamicViscosity(stateEXTTP);

    end TestTwoPhaseFunctions;
  end TestFunctions;

  model test_propane_coolprop
    replaceable package wf = CoolProp2Modelica.Media.R290_CP constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";
    wf.BaseProperties fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";
  equation
    p = 1E5;
    h = 0 + time*1E6;
    fluid.p = p;
    fluid.h = h;
    drdp = wf.density_derp_h(fluid.state);
    drdh = wf.density_derh_p(fluid.state);
  end test_propane_coolprop;

  model test_propane_fluidprop
    replaceable package wf = CoolProp2Modelica.Media.R290_FPST constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";
    wf.BaseProperties fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";
  equation
    p = 1E5;
    h = -7e5 + time*1E6;
    fluid.p = p;
    fluid.h = h;
    drdp = wf.density_derp_h(fluid.state);
    drdh = wf.density_derh_p(fluid.state);
  end test_propane_fluidprop;

  model test_propane_refprop
    replaceable package wf = CoolProp2Modelica.Media.R290_FPRP constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";
    wf.BaseProperties fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";
  equation
    p = 1E5;
    h = 0 + time*1E6;
    fluid.p = p;
    fluid.h = h;
    drdp = wf.density_derp_h(fluid.state);
    drdh = wf.density_derh_p(fluid.state);
  end test_propane_refprop;

  model test_solkatherm
    replaceable package wf = CoolProp2Modelica.Media.SES36_CP
                                                           constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";
    wf.BaseProperties fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";
  equation
    p = 1E5;
    h = 0 + time*1E5;
    fluid.p = p;
    fluid.h = h;
    drdp = wf.density_derp_h(fluid.state);
    drdh = wf.density_derh_p(fluid.state);
    annotation (experiment(StopTime=10, Algorithm="Dassl"),
        __Dymola_experimentSetupOutput);
  end test_solkatherm;

  model test_solkatherm_debug "Please note that the debug information appears in the DOS window only. Run 'dymosim >> log.txt' from the cmd to log the 
  debug information in a file"
    replaceable package wf = CoolProp2Modelica.Media.Solkatherm_debug
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
    wf.BaseProperties fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";
  equation
    p = 1E5;
    h = 0 + time*3e5;
    fluid.p = p;
    fluid.h = h;
    drdp = wf.density_derp_h(fluid.state);
    drdh = wf.density_derh_p(fluid.state);
    annotation (experiment(Algorithm="Dassl"), __Dymola_experimentSetupOutput);
  end test_solkatherm_debug;

  model test_pentane_coolprop
    replaceable package wf = ThermoCycle_BDversion.Media.R601_CP
      constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
    wf.BaseProperties fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";
  equation
    p = 1E5;
    h = 0 + time*1E6;
    fluid.p = p;
    fluid.h = h;
    drdp = wf.density_derp_h(fluid.state);
    drdh = wf.density_derh_p(fluid.state);
  end test_pentane_coolprop;

  model test_R245fa_baseproperties
    replaceable package wf = CoolProp2Modelica.Media.R245fa_CP constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";
    wf.BaseProperties fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";
  equation
    p = 1E5;
    h = 2 + time*1E5;
    fluid.p = p;
    fluid.h = h;
    drdp = wf.density_derp_h(fluid.state);
    drdh = wf.density_derh_p(fluid.state);
  end test_R245fa_baseproperties;

  model test_R245fa_ThermodynamicState
    "ThermodynamicState is faster since it does not call the saturation properties"
    replaceable package wf = CoolProp2Modelica.Media.R245fa_CP constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";
    wf.ThermodynamicState fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";
  equation
    p = 1E5;
    h = 2 + time*1E5;
    fluid = wf.setState_ph(p=p,h=h);
    drdp = wf.density_derp_h(fluid);
    drdh = wf.density_derh_p(fluid);
  end test_R245fa_ThermodynamicState;

  model test_InputChoices
    "Some test cases for the different Inputchoices from the enumeration"

    constant String fluidIdentifier = "n-Pentane";

    replaceable package ph = ExternalMedia.Media.CoolPropMedium (
    mediumName=fluidIdentifier,
    substanceNames={fluidIdentifier},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph) constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";

    replaceable package dT = ExternalMedia.Media.CoolPropMedium (
    mediumName=fluidIdentifier,
    substanceNames={fluidIdentifier},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.dT) constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";

    replaceable package ps = ExternalMedia.Media.CoolPropMedium (
    mediumName=fluidIdentifier,
    substanceNames={fluidIdentifier},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ps) constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model";

       replaceable package hs = ExternalMedia.Media.CoolPropMedium (
         mediumName=fluidIdentifier,
         substanceNames={fluidIdentifier},
         ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.hs)
       constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";

    ph.ThermodynamicState fluid "Properties of the two-phase fluid";
    Modelica.SIunits.SpecificEnthalpy h;
    Modelica.SIunits.Pressure p;
    Modelica.SIunits.DerDensityByEnthalpy drdh
      "Derivative of average density by enthalpy";
    Modelica.SIunits.DerDensityByPressure drdp
      "Derivative of average density by pressure";

    dT.ThermodynamicState fluid_dT "Properties of the two-phase fluid";
    ps.ThermodynamicState fluid_ps "Properties of the two-phase fluid";
    hs.ThermodynamicState fluid_hs "Properties of the two-phase fluid";

  equation
    p = 1E5;
    h = -1.5e5 + 2*time*1E5;
    fluid = ph.setState_ph(p=p,h=h);
    drdp = ph.density_derp_h(fluid);
    drdh = ph.density_derh_p(fluid);

    fluid_dT = dT.setState_dT(d=fluid.d,T=fluid.T);
    fluid_ps = ps.setState_ps(p=fluid.p,s=fluid.s);
    fluid_hs = hs.setState_hs(h=fluid_ps.h,s=fluid.s);
  end test_InputChoices;

  model R600_TestModel "Test Butane"

  extends Modelica.Media.Examples.Tests.Components.PartialTestModel(
  redeclare package Medium = CoolProp2Modelica.Media.R600_CP);

  end R600_TestModel;

  model test_incompressibleCoolPropMedium
    replaceable package Solution =
    CoolProp2Modelica.Media.LiBr_CP(substanceNames={"LiBr|calc_transport=1|debug=10","dummyToMakeBasePropertiesWork"})
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
    Solution.ThermodynamicState state_var;
    Solution.ThermodynamicState state_con;
    Solution.Temperature T;
    Solution.AbsolutePressure p;
    Solution.MassFraction[1] X_var;
    Solution.MassFraction[1] X_con;
    Solution.BaseProperties varProps;
    replaceable package Liquid =
    CoolProp2Modelica.Media.DowQ_CP(substanceNames={"DowQ|calc_transport=1|debug=10"})
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
    Liquid.ThermodynamicState state_liq;
    Liquid.BaseProperties liqProps;
  equation
    p         = 10E5;
    T         = 273.15 + 15.0 + time * 50.0;
    X_var[1]  =   0.00 +  0.1 + time *  0.5;
    X_con[1]  =   0.00 +  0.1;
    state_var = Solution.setState_pTX(p,T,X_var);
    state_con = Solution.setState_pTX(p,T,X_con);
    state_liq = Liquid.setState_pT(p,T);
    // And now we do some testing with the BaseProperties
    varProps.T = T;
    varProps.p = p;
    varProps.Xi = X_var;
    liqProps.T = T;
    liqProps.p = p;
  end test_incompressibleCoolPropMedium;

  model Test_XiToName

  constant String inString = "LiBr|TTSE=0|EXTTP=1";
  constant Real[:] Xi = {0.33435};
  constant String name = ExternalMedia.Common.XtoName(inString,Xi,debug=true);
  Real dummy;
  algorithm
    dummy := 1;
    assert(false, name, level=AssertionLevel.warning);
  end Test_XiToName;

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
  end CheckOptions;
end Test;
