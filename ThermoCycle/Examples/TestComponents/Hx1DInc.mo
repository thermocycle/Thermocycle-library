within ThermoCycle.Examples.TestComponents;
model Hx1DInc
ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare package
      Medium =
        Media.Therminol66,
      p0=100000)
    annotation (Placement(transformation(extent={{-50,64},{-30,84}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=0.2588,
    h_0=281455,
    UseT=true,
    p=2357000,
    T_0=353.15)
    annotation (Placement(transformation(extent={{-74,-18},{-54,2}})));
 ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc(
    redeclare package Medium1 = Media.R245faCool,
    redeclare package Medium2 = Media.Therminol66,
    steadystate_h_sf=true,
    Tstart_inlet_wf=300,
    Tstart_outlet_wf=300)
    annotation (Placement(transformation(extent={{-28,2},{4,40}})));
ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF1(
    redeclare package Medium = Media.Therminol66,
    h_0=281455,
    UseT=true,
    Mdot_0=3,
    p=100000,
    T_0=418.15)
    annotation (Placement(transformation(extent={{10,72},{30,92}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkP     sinkPFluid1(p0=2357000)
    annotation (Placement(transformation(extent={{40,-8},{60,12}})));
equation
  connect(hx1DInc.outlet_fl1, sinkPFluid1.flangeB) annotation (Line(
      points={{0.307692,13.6923},{16,13.6923},{16,12},{28,12},{28,1.8},{
          41.6,1.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hx1DInc.inlet_fl2, sourceWF1.flangeB) annotation (Line(
      points={{0.0615385,29.7692},{29,29.7692},{29,82}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hx1DInc.outlet_fl2, sinkPFluid.flangeB) annotation (Line(
      points={{-24.0615,29.4769},{-62,29.4769},{-62,73.8},{-48.4,73.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceWF.flangeB, hx1DInc.inlet_fl1) annotation (Line(
      points={{-55,-8},{-44,-8},{-44,13.6923},{-24.3077,13.6923}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Hx1DInc;
