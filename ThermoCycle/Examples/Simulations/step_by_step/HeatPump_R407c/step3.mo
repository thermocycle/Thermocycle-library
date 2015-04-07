within ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c;
model step3

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    Mdot_0=0.044,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    p=1600000,
    T_0=345.15)
    annotation (Placement(transformation(extent={{68,14},{48,34}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = ThermoCycle.Media.R407c_CP,
    h=4E5,
    p0=1650000)
    annotation (Placement(transformation(extent={{-50,-42},{-70,-22}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc(
    redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
    redeclare package Medium2 = ThermoCycle.Media.Water,
    N=10,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    M_wall=10,
    Mdotnom_sf=0.52,
    Mdotnom_wf=0.044,
    A_sf=4,
    A_wf=4,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    V_sf=0.002,
    V_wf=0.002,
    pstart_wf=1650000,
    Tstart_inlet_wf=345.15,
    Tstart_outlet_wf=308.15,
    Tstart_inlet_sf=303.15,
    Tstart_outlet_sf=308.15)
    annotation (Placement(transformation(extent={{10,16},{-16,42}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
    redeclare package Medium = ThermoCycle.Media.Water,
    Mdot_0=0.52,
    T_0=298.15)
    annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
      Medium = ThermoCycle.Media.Water)
    annotation (Placement(transformation(extent={{36,44},{56,64}})));
  ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    Vtot=0.004,
    pstart=1650000)
    annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
equation
  connect(sourceMdot.flangeB, hx1DInc.inlet_fl1) annotation (Line(
      points={{49,24},{7,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, hx1DInc.inlet_fl2) annotation (Line(
      points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hx1DInc.outlet_fl2, sinkP1.flangeB) annotation (Line(
      points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hx1DInc.outlet_fl1, tank_pL.InFlow) annotation (Line(
      points={{-13,24},{-40,24},{-40,14.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinkP.flangeB, tank_pL.OutFlow) annotation (Line(
      points={{-51.6,-32},{-40,-32},{-40,-2.8}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),      graphics),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end step3;
