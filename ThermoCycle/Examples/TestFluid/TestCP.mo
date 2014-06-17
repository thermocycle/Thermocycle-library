within ThermoCycle.Examples.TestFluid;
model TestCP
  replaceable package Medium2 = ThermoCycle.Media.Propane_CP;
  CoolProp2Modelica.Test.TestMedium.GenericModels.CompleteBaseProperties
    mediumRP(                 redeclare package Medium = Medium2)
    "Varying pressure, constant enthalpy";
equation
  mediumRP.baseProperties.p = 2.5e6;
  mediumRP.baseProperties.h = 0+time*200000;
  annotation (experiment(Algorithm="Dassl"),
      __Dymola_experimentSetupOutput);
end TestCP;
