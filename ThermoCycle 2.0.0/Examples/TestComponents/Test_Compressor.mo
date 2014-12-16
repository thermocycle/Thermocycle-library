within ThermoCycle.Examples.TestComponents;
model Test_Compressor

  Modelica.Blocks.Sources.Ramp N_rot(
    duration=100,
    startTime=400,
    offset=48.25,
    height=0)      annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-13,77})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare
      package Medium = ThermoCycle.Media.Propane_CP, p0=2000000)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    h_0=503925,
    UseT=true,
    Mdot_0=0.01,
    redeclare package Medium = ThermoCycle.Media.Propane_CP,
    T_0=323.15)
    annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                          generator
    annotation (Placement(transformation(extent={{16,28},{36,48}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor
                                                compressor(redeclare package
      Medium = ThermoCycle.Media.Propane_CP, T_su_start=373.15)
    annotation (Placement(transformation(extent={{-46,4},{-4,44}})));
equation
  connect(N_rot.y, generator.f) annotation (Line(
      points={{-7.5,77},{26.4,77},{26.4,47.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceWF.flangeB, compressor.InFlow) annotation (Line(
      points={{-73,50},{-54,50},{-54,48},{-36.9,48},{-36.9,37}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(compressor.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{-9.95,17.3333},{-2,17.3333},{-2,0},{9.6,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(generator.shaft, compressor.flange_elc) annotation (Line(
      points={{17.4,38},{6,38},{6,24},{-11,24}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{80,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-120,-100},
            {80,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_Compressor;
