within ThermoCycle.Examples.Simulations.step_by_step.ORC_245fa;
model step8

 ThermoCycle.Components.Units.HeatExchangers.Hx1DConst    hx1DConst(
    N=10,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    steadystate_T_sf=false,
    steadystate_h_wf=false,
    steadystate_T_wall=false,
    Unom_sf=335,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare model Medium2HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence_IdealFluid,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance)
    annotation (Placement(transformation(extent={{-46,28},{-12,60}})));

ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{-30,78},{-10,98}})));
ThermoCycle.Components.Units.PdropAndValves.DP  dp_hp(
    A=(2*137*77609.9)^(-0.5),
    k=11857.8*137,
    Mdot_nom=0.2588,
    t_init=500,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    constinit=false,
    UseHomotopy=false,
    use_rho_nom=true,
    p_nom=2357000,
    T_nom=413.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150)
    annotation (Placement(transformation(extent={{14,26},{34,46}})));
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
    annotation (Placement(transformation(extent={{40,0},{72,32}})));
  Modelica.Blocks.Sources.Ramp N_rot(
    startTime=50,
    duration=0,
    height=0,
    offset=48.25)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={72,64})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                              generatorNext(Np=1)
    annotation (Placement(transformation(extent={{94,10},{114,30}})));
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
        origin={1,-22})));

ThermoCycle.Components.Units.PdropAndValves.DP dp_lp(
    k=38.4E3*9.5,
    A=(2*9.5*23282.7)^(-0.5),
    Mdot_nom=0.2588,
    use_rho_nom=true,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p_nom=190000,
    T_nom=351.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150)
    annotation (Placement(transformation(extent={{46,-14},{26,6}})));
 ThermoCycle.Components.Units.HeatExchangers.Hx1DConst    condenser(
    Unom_l=500,
    Unom_tp=1500,
    Unom_v=750,
    Mdotnom_sf=4,
    steadystate_T_wall=false,
    N=10,
    max_der_wf=true,
    filter_dMdt_wf=false,
    max_drhodt_wf=50,
    steadystate_T_sf=false,
    steadystate_h_wf=true,
    Unom_sf=335,
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
    annotation (Placement(transformation(extent={{44,-66},{20,-86}})));

 ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot heat_sink(
    cp=4187,
    rho=1000,
    Mdot_0=4,
    T_0=293.15)
    annotation (Placement(transformation(extent={{48,-98},{34,-84}})));
ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Pump
                                                      pump(
    PumpType=ThermoCycle.Functions.Enumerations.PumpTypes.ORCNext,
    PumpInput=ThermoCycle.Functions.Enumerations.PumpInputs.freq,
    hstart=2.27e5,
    M_dot_start=0.2588,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{-60,-70},{-36,-46}})));
  Modelica.Blocks.Sources.Ramp f_pp(
    offset=30,
    startTime=50,
    duration=0,
    height=0)      annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-74,-26})));
 ThermoCycle.Components.Units.Tanks.Tank_pL tank(
    Vtot=0.015,
    L_start=0.5,
    SteadyState_p=false,
    impose_pressure=true,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    pstart=135000)
    annotation (Placement(transformation(extent={{-28,-92},{-10,-74}})));
equation
  connect(source_Cdot.flange, hx1DConst.inletSf)
                                               annotation (Line(
      points={{-11.8,87.9},{26,87.9},{26,52},{-12,52}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hx1DConst.outletWf, dp_hp.InFlow)
                                         annotation (Line(
      points={{-12,36},{15,36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.flange_elc,generatorNext. shaft) annotation (Line(
      points={{66.6667,17.3333},{76.4,17.3333},{76.4,20},{95.4,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(N_rot.y,generatorNext. f) annotation (Line(
      points={{83,64},{104.4,64},{104.4,29.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp_hp.OutFlow, expander.InFlow) annotation (Line(
      points={{33,36},{46.9333,36},{46.9333,22.1333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, dp_lp.InFlow) annotation (Line(
      points={{68,8},{68,-4},{45,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heat_sink.flange,condenser. inletSf) annotation (Line(
      points={{35.26,-91.07},{4,-91.07},{4,-81},{20,-81}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(condenser.outletWf, tank.InFlow) annotation (Line(
      points={{20,-71},{-20,-71},{-20,-75.44},{-19,-75.44}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank.OutFlow, pump.InFlow) annotation (Line(
      points={{-19,-90.92},{-19,-96},{-64,-96},{-64,-57.4},{-56.64,-57.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(f_pp.y, pump.flow_in) annotation (Line(
      points={{-67.4,-26},{-51.84,-26},{-51.84,-48.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl2, dp_lp.OutFlow) annotation (Line(
      points={{7,-11.5467},{7,-4},{27,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl1, hx1DConst.inletWf) annotation (Line(
      points={{-4,-11.3333},{-4,4},{-68,4},{-68,36},{-46,36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl2, condenser.inletWf) annotation (Line(
      points={{6.8,-32.4533},{6.8,-44},{62,-44},{62,-71},{44,-71}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl1, pump.OutFlow) annotation (Line(
      points={{-4,-32.6667},{-4,-49.12},{-41.28,-49.12}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=4000),
    __Dymola_experimentSetupOutput);
end step8;
