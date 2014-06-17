within ThermoCycle.Examples.TestFluid;
model TestTIL
parameter String fluid = "Refprop.propane";
  TILMedia.Refrigerant refrigerant( refrigerantName = fluid)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
equation
  refrigerant.p = 2.5e6;
  refrigerant.h = 0 + time*200000;
  annotation (experiment(Algorithm="Euler"),
      __Dymola_experimentSetupOutput);
end TestTIL;
