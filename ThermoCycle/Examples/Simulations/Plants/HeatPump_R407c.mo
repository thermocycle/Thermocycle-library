within ThermoCycle.Examples.Simulations.Plants;
model HeatPump_R407c

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
    steadystate_h_wf=true,
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
    Xopen=0.45,
    p_nom=1650000,
    T_nom=308.15,
    DELTAp_nom=1200000)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-26})));
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
    steadystate_h_wf=true,
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
    annotation (Placement(transformation(extent={{48,-90},{28,-70}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP3(redeclare package
      Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{-30,-86},{-50,-66}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor
                                                            compressor(
    epsilon_v=0.9,
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    V_s=85e-6,
    p_su_start=380000,
    p_ex_start=1650000,
    T_su_start=278.15) annotation (Placement(transformation(
        extent={{-19,-18},{19,18}},
        rotation=180,
        origin={59,-16})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                               electricDrive
    annotation (Placement(transformation(extent={{28,-26},{8,-6}})));
  ThermoCycle.Components.Units.PdropAndValves.DP dp_ev(
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    UseNom=true,
    Mdot_nom=0.044,
    p_nom=380000,
    T_nom=283.15,
    DELTAp_quad_nom=20000)
    annotation (Placement(transformation(extent={{18,-62},{38,-42}})));
  ThermoCycle.Components.Units.PdropAndValves.DP dp_cd(
    redeclare package Medium = ThermoCycle.Media.R407c_CP,
    UseNom=true,
    Mdot_nom=0.044,
    p_nom=1650000,
    T_nom=345.15,
    DELTAp_quad_nom=20000)
    annotation (Placement(transformation(extent={{38,14},{18,34}})));
  Modelica.Blocks.Sources.Ramp ramp(offset=50,
    height=10,
    duration=2,
    startTime=50)
    annotation (Placement(transformation(extent={{-12,0},{-2,10}})));
  Components.HeatFlow.Sensors.SensTp             sensTp(redeclare package
      Medium = ThermoCycle.Media.R407c_CP)
    annotation (Placement(transformation(extent={{46,-56},{62,-40}})));
  Components.Units.ControlSystems.SH_block sH_block(redeclare package Medium =
        ThermoCycle.Media.R407c_CP)
    annotation (Placement(transformation(extent={{70,24},{80,34}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=0.1,
    duration=0,
    offset=0.45,
    startTime=75)
    annotation (Placement(transformation(extent={{-86,-52},{-76,-42}})));
  Modelica.Blocks.Sources.Constant DELTAT_SP(k=5)
    annotation (Placement(transformation(extent={{74,12},{80,18}})));
  Components.Units.ControlSystems.PID             PID_valve(
    CSmax=1,
    PVmax=25,
    PVmin=-5,
    CSmin=0,
    CSstart=0.45,
    PVstart=2,
    steadyStateInit=false,
    Kp=-0.9,
    Ti=1)
    annotation (Placement(transformation(extent={{90,26},{108,12}})));
equation
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
  connect(electricDrive.shaft, compressor.flange_elc) annotation (Line(
      points={{26.6,-16},{36.4667,-16},{36.4667,-16},{46.3333,-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(evaporator.outlet_fl1, dp_ev.InFlow) annotation (Line(
      points={{11,-52},{19,-52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(compressor.OutFlow, dp_cd.InFlow) annotation (Line(
      points={{45.3833,-10},{44,-10},{44,24},{37,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dp_cd.OutFlow, condenser.inlet_fl1) annotation (Line(
      points={{19,24},{7,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ramp.y, electricDrive.f) annotation (Line(
      points={{-1.5,5},{17.6,5},{17.6,-6.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp_ev.OutFlow, sensTp.InFlow) annotation (Line(
      points={{37,-52},{42,-52},{42,-51.84},{48.4,-51.84}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.OutFlow, compressor.InFlow) annotation (Line(
      points={{59.6,-51.84},{69.7667,-51.84},{69.7667,-27.7}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.T, sH_block.T_measured) annotation (Line(
      points={{60.4,-43.2},{82,-43.2},{82,4},{62,4},{62,31.5},{69.7,31.5}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(sensTp.p, sH_block.p_measured) annotation (Line(
      points={{47.6,-43.2},{44,-43.2},{44,-36},{84,-36},{84,6},{64,6},{64,27},{
          69.9,27}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(DELTAT_SP.y,PID_valve. SP) annotation (Line(
      points={{80.3,15},{85.15,15},{85.15,16.2},{90,16.2}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(sH_block.DeltaT, PID_valve.PV) annotation (Line(
      points={{80.55,29.25},{85.275,29.25},{85.275,21.8},{90,21.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_valve.CS, valve.cmd) annotation (Line(
      points={{108.54,19},{118,19},{118,82},{-82,82},{-82,-26},{-48,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}),      graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{140,100}})));
end HeatPump_R407c;
