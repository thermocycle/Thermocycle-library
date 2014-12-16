within ThermoCycle.Examples.TestComponents;
model Test_Compressor_EN12900

  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare
      package Medium = ThermoCycle.Media.R407c_CP, p0=2000000)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    h_0=503925,
    UseT=true,
    Mdot_0=0.05,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    T_0=323.15)
    annotation (Placement(transformation(extent={{-96,38},{-76,58}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor_EN12900
                                                        compressor(redeclare
      package Medium = ThermoCycle.Media.R407c_CP, redeclare function CPmodel
      = ThermoCycle.Functions.Compressors_EN12900.ZRD42KCE_TFD)
    annotation (Placement(transformation(extent={{-46,4},{-4,44}})));
equation
  connect(sourceWF.flangeB, compressor.InFlow) annotation (Line(
      points={{-77,48},{-36.9,48},{-36.9,37}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(compressor.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{-9.95,17.3333},{-2,17.3333},{-2,0},{9.6,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{80,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-120,-100},
            {80,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_Compressor_EN12900;
