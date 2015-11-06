within ThermoCycle.Obsolete;
model ORC_DetailedExpander
  "Non-regenerative ORC with double-PID control system and variable Tev, detailed expander model"

ThermoCycle.Components.Units.Tanks.Tank tank(
    level_start=0.5,
    hstart=2.32e5,
    impose_pressure=true,
    Vtot=0.015,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    pstart=148400,
    impose_level=true)
    annotation (Placement(transformation(extent={{-44,-32},{-24,-12}})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Pump
                                                     Pump(
    X_pp0=0.5539,
    hstart=1.76e5,
    eta_em=0.7,
    M_dot_start=0.3707,
    V_dot_max=6.5e-4,
    PumpInput=ThermoCycle.Functions.Enumerations.PumpInputs.FF,
    PumpType=ThermoCycle.Functions.Enumerations.PumpTypes.SQThesis,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{-66,10},{-86,30}})));
ThermoCycle.Components.FluidFlow.Reservoirs.Source_Cdot Heat_source(cp=4232)
    annotation (Placement(transformation(extent={{-38,64},{-22,80}})));
 ThermoCycle.Components.Units.HeatExchangers.Hx1DConst Evaporator(
    N=20,
    V_sf=0.003324,
    M_wall=13,
    Mdotnom_sf=0.15,
    Unom_l=1072,
    Unom_tp=3323,
    Unom_v=1359,
    Unom_sf=3855,
    steadystate_T_sf=true,
    V_wf=0.003324,
    A_sf=3.078,
    A_wf=3.078,
    Mdotnom_wf=0.3706,
    max_drhodt_wf=80,
    max_der_wf=true,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    steadystate_h_wf=false,
    pstart_wf=1251000,
    Tstart_inlet_wf=299.96,
    Tstart_outlet_wf=382.55,
    Tstart_inlet_sf=473.15,
    Tstart_outlet_sf=325.41,
    steadystate_T_wall=false)
    annotation (Placement(transformation(extent={{-42,36},{-22,56}})));

ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                             generator(Np=1)
    annotation (Placement(transformation(extent={{82,4},{104,26}})));
ThermoCycle.Components.Units.HeatExchangers.Hx1DConst Condenser(
    N=20,
    V_sf=0.009562,
    M_wall=30,
    Mdotnom_sf=2,
    Unom_l=425.8,
    Unom_tp=1453,
    Unom_v=477.5,
    Unom_sf=5159,
    V_wf=0.009562,
    A_sf=7.626,
    A_wf=7.626,
    Mdotnom_wf=0.37,
    steadystate_h_wf=true,
    TT_wf=11,
    max_drhodt_wf=40,
    filter_dMdt_wf=true,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    pstart_wf=148400,
    Tstart_inlet_wf=337.91,
    Tstart_outlet_wf=298.25,
    Tstart_inlet_sf=283.15,
    Tstart_outlet_sf=293.25,
    steadystate_T_sf=false,
    steadystate_T_wall=false)
    annotation (Placement(transformation(extent={{6,-12},{-14,8}})));

ThermoCycle.Components.FluidFlow.Reservoirs.Source_Cdot Heat_sink(rho=1000, cp=4188)
    annotation (Placement(transformation(extent={{-46,-6},{-26,14}})));
ThermoCycle.Components.FluidFlow.Sensors.SensP sensP(redeclare package Medium
      = ThermoCycle.Media.R245fa_CP)
                                  annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={-80,-11})));
ThermoCycle.Components.HeatFlow.Sensors.SensTp sensTp(redeclare package Medium
      = ThermoCycle.Media.R245fa_CP)
                                    annotation (Placement(transformation(extent={{16,40},
            {26,50}})));
ThermoCycle.Components.FluidFlow.Sensors.SensMdot sensMdot(redeclare package
      Medium = ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{-70,38},{-58,50}})));
ThermoCycle.Components.HeatFlow.Sensors.SensTsf sensTsf
    annotation (Placement(transformation(extent={{-8,70},{2,78}})));
ThermoCycle.Components.Units.ControlSystems.SQThesisController
                                              control_unit1(
    PVmin_freq=-70,
    PVmax_freq=70,
    CSmin_freq=5,
    CSmax_freq=100,
    PVmin_Xpp=0,
    PVmax_Xpp=70,
    CSmin_Xpp=0.01,
    CSstart_Xpp=0.6,
    Kp_freq=-2,
    Kp_Xpp=-1,
    Ti_freq=0.6,
    Ti_Xpp=0.4,
    CSmax_Xpp=1,
    PVstart_Xpp=0.3)
    annotation (Placement(transformation(extent={{36,54},{60,78}})));
ThermoCycle.Components.FluidFlow.Sources.inputs data
    annotation (Placement(transformation(extent={{-86,66},{-66,78}})));
ThermoCycle.Components.Units.PdropAndValves.DP DP_cd(
    A=564.1e-6,
    Mdot_nom=0.37,
    UseNom=false,
    use_rho_nom=true,
    UseHomotopy=false,
    constinit=false,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    DELTAp_0=1000,
    p_nom=177845,
    T_nom=339.15,
    DELTAp_quad_nom=29400)
    annotation (Placement(transformation(extent={{46,-16},{30,0}})));
 ThermoCycle.Components.Units.PdropAndValves.DP DP_ev(
    A=307.9e-6,
    Mdot_nom=0.37,
    use_rho_nom=true,
    UseHomotopy=false,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p_nom=1251000,
    T_nom=382.15,
    DELTAp_quad_nom=10814)
    annotation (Placement(transformation(extent={{-16,34},{-2,48}})));
ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ExpanderOpendriveDetailed
                                                                         expanderOpendriveDetailed(
    HeatCapacity=true,
    V_s=1.1e-4,
    d_su=1.15e-2,
    AU_amb=9.8,
    A_leak=2.6e-6,
    U_dot_w(start=66.7),
    M_dot_n=0.37,
    M_dot_start=0.37,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p_su_start=1240000,
    T_su_start=382.55,
    p_su1_start=1100000,
    p_ex_start=178000)
    annotation (Placement(transformation(extent={{50,4},{70,24}})));
equation
  connect(sensP.p, control_unit1.p_cd) annotation (Line(
      points={{-83.6,-7},{-83.6,-4},{-86,-4},{-86,84},{16,84},{16,73.32},{36.84,
          73.32}},
      color={0,0,127},
      pattern=LinePattern.Dot,
      smooth=Smooth.None));
  connect(sensTsf.T, control_unit1.T_hf_su) annotation (Line(
      points={{1,76.4},{10,76.4},{10,70.44},{36.84,70.44}},
      color={0,0,127},
      pattern=LinePattern.Dot,
      smooth=Smooth.None));
  connect(sensMdot.Mdot, control_unit1.Mdot) annotation (Line(
      points={{-59.2,47.6},{-50,47.6},{-50,62},{10,62},{10,67.56},{36.84,67.56}},
      color={0,0,127},
      pattern=LinePattern.Dot,
      smooth=Smooth.None));
  connect(sensTp.T, control_unit1.T_su_exp) annotation (Line(
      points={{25,48},{30,48},{30,56},{22,56},{22,64.68},{36.84,64.68}},
      color={0,0,127},
      pattern=LinePattern.Dot,
      smooth=Smooth.None));
  connect(sensTp.p, control_unit1.p_su_exp) annotation (Line(
      points={{17,48},{14,48},{14,61.8},{36.84,61.8}},
      color={0,0,127},
      pattern=LinePattern.Dot,
      smooth=Smooth.None));
  connect(control_unit1.CS_freq, generator.f) annotation (Line(
      points={{59.28,70.32},{93.44,70.32},{93.44,25.34}},
      color={0,0,127},
      pattern=LinePattern.Dot,
      smooth=Smooth.None));
  connect(control_unit1.CS_Xpp, Pump.flow_in) annotation (Line(
      points={{59.28,63.6},{70,63.6},{70,32},{-72.8,32},{-72.8,28}},
      color={0,0,127},
      pattern=LinePattern.Dot,
      smooth=Smooth.None));
  connect(data.y[1:2], Heat_source.source) annotation (Line(
      points={{-67.2,71.82},{-50.64,71.82},{-50.64,71.92},{-35.68,71.92}},
      color={0,128,255},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(data.y[3:4], Heat_sink.source) annotation (Line(
      points={{-67.2,72.54},{-52,72.54},{-52,3.9},{-43.1,3.9}},
      color={0,128,255},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(Heat_sink.flange, Condenser.inletSf) annotation (Line(
      points={{-27.8,3.9},{-20.9,3.9},{-20.9,3},{-14,3}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Pump.OutFlow, sensMdot.InFlow) annotation (Line(
      points={{-81.6,27.4},{-81.6,41.6},{-66.4,41.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensMdot.OutFlow, Evaporator.inletWf) annotation (Line(
      points={{-61.6,41.6},{-51.8,41.6},{-51.8,41},{-42,41}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Evaporator.outletWf, DP_ev.InFlow) annotation (Line(
      points={{-22,41},{-15.3,41}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(DP_ev.OutFlow, sensTp.InFlow) annotation (Line(
      points={{-2.7,41},{7.65,41},{7.65,42.6},{17.5,42.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(DP_cd.OutFlow, Condenser.inletWf) annotation (Line(
      points={{30.8,-8},{18,-8},{18,-7},{6,-7}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Condenser.outletWf, tank.InFlow) annotation (Line(
      points={{-14,-7},{-24,-7},{-24,-8},{-34,-8},{-34,-13.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank.OutFlow, sensP.InFlow) annotation (Line(
      points={{-34,-30.8},{-34,-38},{-77.66,-38},{-77.66,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensP.OutFlow, Pump.InFlow) annotation (Line(
      points={{-77.6,-8},{-78,-8},{-78,0},{-58,0},{-58,20.5},{-68.8,20.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Heat_source.flange, sensTsf.inlet) annotation (Line(
      points={{-23.44,71.92},{-14.72,71.92},{-14.72,72.4},{-6,72.4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sensTsf.outlet, Evaporator.inletSf) annotation (Line(
      points={{0,72.4},{4,72.4},{4,72},{6,72},{6,51},{-22,51}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(expanderOpendriveDetailed.flange_elc, generator.shaft) annotation (
      Line(
      points={{68,15},{83.54,15}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(expanderOpendriveDetailed.flangeB, DP_cd.InFlow) annotation (Line(
      points={{68.6,8},{70,8},{70,-8},{45.2,-8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.OutFlow, expanderOpendriveDetailed.flangeA) annotation (Line(
      points={{24.5,42.6},{53.4,42.6},{53.4,18.8}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=1669),
    __Dymola_experimentSetupOutput(equdistant=false));
end ORC_DetailedExpander;
