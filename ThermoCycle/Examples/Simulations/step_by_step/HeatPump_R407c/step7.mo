within ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c;
model step7

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    Mdot_0=0.044,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    p=1600000,
    T_0=345.15)
    annotation (Placement(transformation(extent={{68,14},{48,34}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DInc condenser(
    redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
    redeclare package Medium2 = ThermoCycle.Media.StandardWater,
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
    redeclare package Medium = ThermoCycle.Media.StandardWater,
    Mdot_0=0.52,
    T_0=298.15)
    annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
      Medium = ThermoCycle.Media.StandardWater)
    annotation (Placement(transformation(extent={{36,44},{56,64}})));
  ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    Vtot=0.004,
    pstart=1650000)
    annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    Mdot_nom=0.044,
    UseNom=false,
    Afull=15e-7,
    Xopen=0.55,
    p_nom=1650000,
    T_nom=308.15,
    DELTAp_nom=1200000)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-26})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP2(redeclare package
      Medium = ThermoCycle.Media.R407c_CP,
                                        p0=1650000)
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DInc evaporator(
    redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
    N=10,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    M_wall=10,
    Mdotnom_wf=0.044,
    A_wf=4,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    V_sf=0.002,
    V_wf=0.002,
    redeclare package Medium2 = Modelica.Media.Air.DryAirNasa,
    A_sf=20,
    Unom_sf=100,
    Mdotnom_sf=0.76,
    pstart_wf=460000,
    Tstart_inlet_wf=263.15,
    Tstart_outlet_wf=277.15,
    Tstart_inlet_sf=280.15,
    Tstart_outlet_sf=273.15)
    annotation (Placement(transformation(extent={{-12,-44},{14,-70}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    Mdot_0=1.76,
    T_0=273.15)
    annotation (Placement(transformation(extent={{48,-90},{28,-70}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP3(redeclare package
      Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{-30,-86},{-50,-66}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor
                                                            compressor(
    epsilon_v=0.9,
    V_s=50e-6,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    p_su_start=380000,
    p_ex_start=1650000,
    T_su_start=278.15) annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=180,
        origin={52,-22})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                               electricDrive
    annotation (Placement(transformation(extent={{28,-32},{8,-12}})));
  Modelica.Blocks.Sources.Ramp ramp(offset=50)
    annotation (Placement(transformation(extent={{-14,-10},{-4,0}})));
equation
  connect(sourceMdot.flangeB, condenser.inlet_fl1)
                                                 annotation (Line(
      points={{49,24},{7,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, condenser.inlet_fl2)
                                                  annotation (Line(
      points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condenser.outlet_fl2, sinkP1.flangeB)
                                              annotation (Line(
      points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condenser.outlet_fl1, tank_pL.InFlow)
                                              annotation (Line(
      points={{-13,24},{-40,24},{-40,14.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank_pL.OutFlow, valve.InFlow) annotation (Line(
      points={{-40,-2.8},{-40,-17}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaporator.inlet_fl1, valve.OutFlow) annotation (Line(
      points={{-9,-52},{-40,-52},{-40,-35}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot2.flangeB, evaporator.inlet_fl2) annotation (Line(
      points={{29,-80},{20,-80},{20,-63},{10.8,-63}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaporator.outlet_fl2, sinkP3.flangeB) annotation (Line(
      points={{-8.8,-62.8},{-20,-62.8},{-20,-76},{-31.6,-76}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(compressor.OutFlow, sinkP2.flangeB) annotation (Line(
      points={{43.4,-18},{42,-18},{42,0},{67.6,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaporator.outlet_fl1, compressor.InFlow) annotation (Line(
      points={{11,-52},{74,-52},{74,-29.8},{58.8,-29.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(electricDrive.shaft, compressor.flange_elc) annotation (Line(
      points={{26.6,-22},{44,-22}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ramp.y, electricDrive.f) annotation (Line(
      points={{-3.5,-5},{17.6,-5},{17.6,-12.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end step7;
