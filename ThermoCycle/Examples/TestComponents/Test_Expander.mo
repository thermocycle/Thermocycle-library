within ThermoCycle.Examples.TestComponents;
model Test_Expander

  Modelica.Blocks.Sources.Ramp N_rot(
    duration=100,
    startTime=400,
    offset=48.25,
    height=0)      annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-13,77})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Expander
                                                         expander(redeclare
      package Medium = ThermoCycle.Media.R245fa_CP,
                                         V_s=1)
    annotation (Placement(transformation(extent={{-32,16},{-12,36}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare
      package Medium = ThermoCycle.Media.R245fa_CP, p0=153400)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=0.2588,
    UseT=false,
    h_0=503925,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{-62,40},{-42,60}})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                          generator
    annotation (Placement(transformation(extent={{16,28},{36,48}})));
equation
  connect(sourceWF.flangeB, expander.InFlow) annotation (Line(
      points={{-43,50},{-32,50},{-32,29.8333},{-27.6667,29.8333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{-14.5,21},{-6,21},{-6,0},{9.6,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.flange_elc, generator.shaft) annotation (Line(
      points={{-15.3333,26.8333},{8,26.8333},{8,38},{17.4,38}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(N_rot.y, generator.f) annotation (Line(
      points={{-7.5,77},{26.4,77},{26.4,47.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-80,-40},{80,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-80,-40},{80,
            100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_Expander;
