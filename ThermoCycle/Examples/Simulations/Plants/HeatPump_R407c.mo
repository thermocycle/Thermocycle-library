within ThermoCycle.Examples.Simulations.Plants;
model HeatPump_R407c
  "Heat pump model using R407c and a basic PI controller for the valve"

  ThermoCycle.Components.Units.HeatExchangers.Hx1DInc condenser(
    redeclare package Medium2 = ThermoCycle.Media.StandardWater,
    N=10,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
    M_wall=10,
    Mdotnom_sf=0.52,
    Mdotnom_wf=0.044,
    A_sf=4,
    A_wf=4,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    V_sf=0.002,
    V_wf=0.002,
    steadystate_h_wf=true,
    redeclare package Medium1 = ThermoCycle.Media.R407c,
    pstart_wf=1650000,
    Tstart_inlet_wf=345.15,
    Tstart_outlet_wf=308.15,
    Tstart_inlet_sf=303.15,
    Tstart_outlet_sf=303.15)
    annotation (Placement(transformation(extent={{10,16},{-16,42}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
    redeclare package Medium = ThermoCycle.Media.StandardWater,
    Mdot_0=0.52,
    T_0=298.15)
    annotation (Placement(transformation(extent={{-40,28},{-20,48}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
      Medium = ThermoCycle.Media.StandardWater)
    annotation (Placement(transformation(extent={{34,32},{52,48}})));
  ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
    Vtot=0.004,
    redeclare package Medium = ThermoCycle.Media.R407c,
    pstart=1650000)
    annotation (Placement(transformation(extent={{-40,-4},{-20,16}})));
  ThermoCycle.Components.Units.PdropAndValves.Valve valve(
    Mdot_nom=0.044,
    UseNom=false,
    Afull=15e-7,
    Xopen=0.45,
    redeclare package Medium = ThermoCycle.Media.R407c,
    p_nom=1650000,
    T_nom=308.15,
    DELTAp_nom=1200000)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-30,-26})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DInc evaporator(
    N=10,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
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
    steadystate_h_wf=true,
    redeclare package Medium1 = ThermoCycle.Media.R407c,
    pstart_wf=500000,
    Tstart_inlet_wf=263.15,
    Tstart_outlet_wf=277.15,
    Tstart_inlet_sf=280.15,
    Tstart_outlet_sf=273.15)
    annotation (Placement(transformation(extent={{-12,-44},{14,-70}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    Mdot_0=1.76,
    T_0=273.15)
    annotation (Placement(transformation(extent={{44,-78},{28,-62}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP3(redeclare package
      Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{-24,-78},{-38,-64}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor compressor(
    epsilon_v=0.9,
    V_s=85e-6,
    redeclare package Medium = ThermoCycle.Media.R407c,
    p_su_start=380000,
    p_ex_start=1650000,
    T_su_start=278.15) annotation (Placement(transformation(
        extent={{-19,-18},{19,18}},
        rotation=180,
        origin={59,-10})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive electricDrive
    annotation (Placement(transformation(extent={{28,-22},{4,2}})));
  ThermoCycle.Components.Units.PdropAndValves.DP dp_ev(
    UseNom=true,
    Mdot_nom=0.044,
    redeclare package Medium = ThermoCycle.Media.R407c,
    p_nom=380000,
    T_nom=283.15,
    DELTAp_quad_nom=20000)
    annotation (Placement(transformation(extent={{30,-62},{50,-42}})));
  ThermoCycle.Components.Units.PdropAndValves.DP dp_cd(
    UseNom=true,
    Mdot_nom=0.044,
    redeclare package Medium = ThermoCycle.Media.R407c,
    p_nom=1650000,
    T_nom=345.15,
    DELTAp_quad_nom=20000)
    annotation (Placement(transformation(extent={{34,14},{14,34}})));
  Modelica.Blocks.Sources.Ramp ramp(offset=50,
    height=10,
    startTime=50,
    duration=0)
    annotation (Placement(transformation(extent={{-12,0},{-2,10}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensTp(redeclare package
      Medium = ThermoCycle.Media.R407c)
    annotation (Placement(transformation(extent={{56,-56},{72,-40}})));
  ThermoCycle.Components.Units.ControlSystems.PID PID_valve(
    CSmax=1,
    PVmax=25,
    PVmin=-5,
    CSmin=0,
    CSstart=0.45,
    steadyStateInit=false,
    PVstart=2,
    Ti=1000,
    Kp=-0.001)
    annotation (Placement(transformation(extent={{60,32},{78,18}})));
  Modelica.Blocks.Sources.Constant DELTAT_SP(k=5)
    annotation (Placement(transformation(extent={{48,16},{54,22}})));
  Components.Units.ControlSystems.SH_block sH_block(redeclare package Medium =
        ThermoCycle.Media.R407c)
    annotation (Placement(transformation(extent={{44,-38},{54,-28}})));
equation
  connect(sourceMdot1.flangeB, condenser.inlet_fl2)
                                                  annotation (Line(
      points={{-21,38},{-16,38},{-16,35},{-12.8,35}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condenser.outlet_fl2, sinkP1.flangeB)
                                              annotation (Line(
      points={{6.8,34.8},{24,34.8},{24,40},{35.44,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condenser.outlet_fl1, tank_pL.InFlow)
                                              annotation (Line(
      points={{-13,24},{-30,24},{-30,14.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank_pL.OutFlow, valve.InFlow) annotation (Line(
      points={{-30,-2.8},{-30,-17}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaporator.inlet_fl1, valve.OutFlow) annotation (Line(
      points={{-9,-52},{-30,-52},{-30,-35}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot2.flangeB, evaporator.inlet_fl2) annotation (Line(
      points={{28.8,-70},{20,-70},{20,-63},{10.8,-63}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaporator.outlet_fl2, sinkP3.flangeB) annotation (Line(
      points={{-8.8,-62.8},{-20,-62.8},{-20,-71},{-25.12,-71}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(electricDrive.shaft, compressor.flange_elc) annotation (Line(
      points={{26.32,-10},{36.3267,-10},{36.3267,-10},{46.3333,-10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(evaporator.outlet_fl1, dp_ev.InFlow) annotation (Line(
      points={{11,-52},{31,-52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(compressor.OutFlow, dp_cd.InFlow) annotation (Line(
      points={{45.3833,-4},{40,-4},{40,24},{33,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dp_cd.OutFlow, condenser.inlet_fl1) annotation (Line(
      points={{15,24},{7,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, electricDrive.f) annotation (Line(
      points={{-1.5,5},{15.52,5},{15.52,1.28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp_ev.OutFlow, sensTp.InFlow) annotation (Line(
      points={{49,-52},{54,-52},{54,-51.84},{58.4,-51.84}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.OutFlow, compressor.InFlow) annotation (Line(
      points={{69.6,-51.84},{82,-51.84},{82,-21.7},{69.7667,-21.7}},
      color={0,0,255},
      smooth=Smooth.None));


  connect(DELTAT_SP.y, PID_valve.SP) annotation (Line(
      points={{54.3,19},{57.15,19},{57.15,22.2},{60,22.2}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(PID_valve.CS, valve.cmd) annotation (Line(
      points={{78.54,25},{84,25},{84,52},{-46,52},{-46,-26},{-38,-26}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(sensTp.p, sH_block.p_measured) annotation (Line(
      points={{57.6,-43.2},{40,-43.2},{40,-35},{43.9,-35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sensTp.T, sH_block.T_measured) annotation (Line(
      points={{70.4,-43.2},{74,-43.2},{74,-32},{60,-32},{60,-22},{36,-22},{36,
          -30.5},{43.7,-30.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sH_block.DeltaT, PID_valve.PV) annotation (Line(
      points={{54.55,-32.75},{96,-32.75},{96,6},{44,6},{44,27.8},{60,27.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),      graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end HeatPump_R407c;
