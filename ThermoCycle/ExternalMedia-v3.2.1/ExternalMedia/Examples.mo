within ExternalMedia;
package Examples "Examples of external medium models"
  extends Modelica.Icons.Package;
  package WaterIF95 "RefProp water model"
    extends ExternalMedia.Media.FluidPropMedium(
      mediumName = "Water",
      libraryName = "FluidProp.RefProp",
      substanceNames = {"H2O"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph);
  end WaterIF95;

  package WaterTPSI "TPSI Water model"
    extends ExternalMedia.Media.FluidPropMedium(
      mediumName = "Water",
      libraryName = "FluidProp.TPSI",
      substanceNames = {"H2O"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph);
  end WaterTPSI;

  package WaterIF97 "IF97 Water model"
    extends ExternalMedia.Media.FluidPropMedium(
      mediumName = "Water",
      libraryName = "FluidProp.IF97",
      substanceNames = {"H2O"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph);
  end WaterIF97;

  package CO2StanMix "StanMix model of CO2"
    extends ExternalMedia.Media.FluidPropMedium(
      mediumName = "Carbon Dioxide",
      libraryName = "FluidProp.StanMix",
      substanceNames = {"CO2"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph);
  end CO2StanMix;

  package CO2RefProp "RefProp model of CO2"
    extends ExternalMedia.Media.FluidPropMedium(
      mediumName = "Carbon Dioxide",
      libraryName = "FluidProp.RefProp",
      substanceNames = {"CO2"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
      SpecificEnthalpy(start = 2e5));
  end CO2RefProp;

  package CO2CoolProp "CoolProp model of CO2"
    extends ExternalMedia.Media.CoolPropMedium(
      mediumName = "CarbonDioxide",
      substanceNames = {"CO2"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
      SpecificEnthalpy(start=2e5));
  end CO2CoolProp;

  package WaterCoolProp "CoolProp model of water"
    extends ExternalMedia.Media.CoolPropMedium(
      mediumName = "Water",
      substanceNames = {"water"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
      AbsolutePressure(start=10e5),
      SpecificEnthalpy(start=2e5));
  end WaterCoolProp;

  package DowQCoolProp "DowthermQ properties from CoolProp"
    extends ExternalMedia.Media.IncompressibleCoolPropMedium(
      mediumName="DowQ",
      substanceNames={"DowQ|calc_transport=1"},
      ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pT);
  end DowQCoolProp;

  package LiBrAQCoolProp "Lithium bromide solution properties from CoolProp"
    extends ExternalMedia.Media.IncompressibleCoolPropMedium(
      mediumName="LiBr",
      substanceNames={"LiBr|calc_transport=1","dummyToMakeBasePropertiesWork"},
      ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pTX);
  end LiBrAQCoolProp;

end Examples;
