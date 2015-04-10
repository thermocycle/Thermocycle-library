within ThermoCycle.Examples.Simulations.step_by_step.ORC_245fa;
model step9

ThermoCycle.Components.Units.HeatExchangers.Hx1DConst    hx1DConst(
    N=10,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    steadystate_T_sf=false,
    Unom_sf=335,
    steadystate_h_wf=true,
    steadystate_T_wall=true,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare model Medium2HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence_IdealFluid,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance)
    annotation (Placement(transformation(extent={{-62,46},{-34,70}})));

ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{-26,72},{-6,92}})));
 ThermoCycle.Components.Units.PdropAndValves.DP dp_hp(
    A=(2*137*77609.9)^(-0.5),
    k=11857.8*137,
    Mdot_nom=0.2588,
    t_init=500,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    constinit=false,
    use_rho_nom=true,
    p_nom=2357000,
    T_nom=413.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150,
    UseHomotopy=false)
    annotation (Placement(transformation(extent={{0,42},{20,62}})));
ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Expander
                                                        expander(
    ExpType=ThermoCycle.Functions.Enumerations.ExpTypes.ORCNext,
    V_s=1,
    constPinit=false,
    constinit=false,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p_su_start=2357000,
    p_ex_start=177800,
    T_su_start=413.15)
    annotation (Placement(transformation(extent={{24,20},{56,52}})));
  Modelica.Blocks.Sources.Ramp N_rot(
    startTime=50,
    duration=0,
    height=0,
    offset=48.25)  annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={65,67})));
ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                             generatorNext(Np=1)
    annotation (Placement(transformation(extent={{70,20},{98,48}})));
ThermoCycle.Components.Units.HeatExchangers.Hx1D       recuperator(
    N=10,
    steadystate_h_cold=true,
    steadystate_h_hot=true,
    steadystate_T_wall=true,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare model ColdSideHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    redeclare model HotSideSideHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    redeclare package Medium2 = ThermoCycle.Media.R245fa_CP,
    pstart_hot=177800)
    annotation (Placement(transformation(extent={{-16,15},{16,-15}},
        rotation=90,
        origin={-13,-6})));

ThermoCycle.Components.Units.PdropAndValves.DP  dp_lp(
    k=38.4E3*9.5,
    A=(2*9.5*23282.7)^(-0.5),
    Mdot_nom=0.2588,
    use_rho_nom=true,
    UseHomotopy=false,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p_nom=190000,
    T_nom=351.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150)
    annotation (Placement(transformation(extent={{32,0},{12,20}})));
ThermoCycle.Components.Units.HeatExchangers.Hx1DConst    condenser(
    Unom_l=500,
    Unom_tp=1500,
    Unom_v=750,
    Mdotnom_sf=4,
    N=10,
    max_der_wf=true,
    filter_dMdt_wf=false,
    max_drhodt_wf=50,
    steadystate_h_wf=true,
    Unom_sf=335,
    steadystate_T_sf=true,
    steadystate_T_wall=true,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare model Medium2HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence_IdealFluid,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    pstart_wf=177800,
    Tstart_inlet_wf=316.92,
    Tstart_outlet_wf=298.15,
    Tstart_inlet_sf=293.15,
    Tstart_outlet_sf=296.36)
    annotation (Placement(transformation(extent={{32,-50},{8,-70}})));

ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot heat_sink(
    cp=4187,
    rho=1000,
    Mdot_0=4,
    T_0=293.15)
    annotation (Placement(transformation(extent={{34,-82},{20,-68}})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Pump
                                                     pump(
    PumpType=ThermoCycle.Functions.Enumerations.PumpTypes.ORCNext,
    PumpInput=ThermoCycle.Functions.Enumerations.PumpInputs.freq,
    hstart=2.27e5,
    M_dot_start=0.2588,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{-74,-54},{-50,-30}})));
  Modelica.Blocks.Sources.Ramp f_pp(
    offset=30,
    startTime=50,
    duration=0,
    height=0)      annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-84,-6})));
 ThermoCycle.Components.Units.Tanks.Tank_pL tank(
    Vtot=0.015,
    L_start=0.5,
    SteadyState_p=false,
    impose_pressure=true,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    pstart=135000)
    annotation (Placement(transformation(extent={{-42,-78},{-24,-60}})));
equation
  connect(source_Cdot.flange, hx1DConst.inletSf)
                                               annotation (Line(
      points={{-7.8,81.9},{12,81.9},{12,64},{-34,64}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hx1DConst.outletWf, dp_hp.InFlow)
                                         annotation (Line(
      points={{-34,52},{1,52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.flange_elc,generatorNext. shaft) annotation (Line(
      points={{50.6667,37.3333},{62.4,37.3333},{62.4,34},{71.96,34}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(N_rot.y,generatorNext. f) annotation (Line(
      points={{70.5,67},{84.56,67},{84.56,47.16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp_hp.OutFlow, expander.InFlow) annotation (Line(
      points={{19,52},{30.9333,52},{30.9333,42.1333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, dp_lp.InFlow) annotation (Line(
      points={{52,28},{52,10},{31,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heat_sink.flange,condenser. inletSf) annotation (Line(
      points={{21.26,-75.07},{-10,-75.07},{-10,-65},{8,-65}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tank.OutFlow, pump.InFlow) annotation (Line(
      points={{-33,-76.92},{-33,-80},{-78,-80},{-78,-41.4},{-70.64,-41.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(f_pp.y, pump.flow_in) annotation (Line(
      points={{-77.4,-6},{-65.84,-6},{-65.84,-32.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tank.InFlow, condenser.outletWf) annotation (Line(
      points={{-33,-61.44},{-33,-55},{8,-55}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl1, pump.OutFlow) annotation (Line(
      points={{-18,-16.6667},{-18,-33.12},{-55.28,-33.12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl1, hx1DConst.inletWf) annotation (Line(
      points={{-18,4.66667},{-18,16},{-76,16},{-76,52},{-62,52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl2, dp_lp.OutFlow) annotation (Line(
      points={{-7,4.45333},{-7,10},{13,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl2, condenser.inletWf) annotation (Line(
      points={{-7.2,-16.4533},{-7.2,-36},{44,-36},{44,-55},{32,-55}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end step9;
