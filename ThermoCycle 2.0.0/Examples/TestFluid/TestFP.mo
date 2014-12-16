within ThermoCycle.Examples.TestFluid;
model TestFP
  replaceable package Medium2 = ThermoCycle.Media.Propane_FPRP;
  CoolProp2Modelica.Test.TestMedium.GenericModels.CompleteBaseProperties
    mediumRP(                 redeclare package Medium = Medium2)
    "Varying pressure, constant enthalpy";
equation
  mediumRP.baseProperties.p = 2.5e6;
  mediumRP.baseProperties.h = 0+time*200000;
  annotation (experiment(Algorithm="Euler"),
      __Dymola_experimentSetupOutput);
end TestFP;
