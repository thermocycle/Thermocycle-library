within ThermoCycle.Examples.Simulations.Plants;
model ORC_245fa_FMU

 ThermoCycle.Components.Units.HeatExchangers.Hx1DConst hx1DConst(
    N=10,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    steadystate_T_sf=false,
    steadystate_h_wf=false,
    steadystate_T_wall=false,
    Unom_sf=335,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal)
    annotation (Placement(transformation(extent={{-92,46},{-64,70}})));

ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{-94,90},{-74,110}})));
ThermoCycle.Components.Units.PdropAndValves.DP dp_hp(
    A=(2*137*77609.9)^(-0.5),
    k=11857.8*137,
    Mdot_nom=0.2588,
    t_init=500,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    constinit=false,
    use_rho_nom=true,
    UseHomotopy=false,
    p_nom=2357000,
    T_nom=413.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150)
    annotation (Placement(transformation(extent={{-22,42},{-2,62}})));
ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Expander
                                                        expander(redeclare
      package Medium =
        ThermoCycle.Media.R245fa_CP,
    V_s=1,
    constPinit=false,
    constinit=false,
    ExpType=ThermoCycle.Functions.Enumerations.ExpTypes.Screw,
    p_su_start=2357000,
    p_ex_start=177800,
    T_su_start=413.15)
    annotation (Placement(transformation(extent={{26,20},{58,52}})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                              generatorNext(Np=1)
    annotation (Placement(transformation(extent={{70,20},{98,48}})));
 ThermoCycle.Components.Units.HeatExchangers.Hx1D    recuperator(redeclare
      package Medium1 =
        ThermoCycle.Media.R245fa_CP,
      redeclare package Medium2 =
        ThermoCycle.Media.R245fa_CP,
    N=10,
    steadystate_h_cold=true,
    steadystate_h_hot=true,
    Mdotconst_cold=true,
    Mdotconst_hot=true,
    steadystate_T_wall=true,
    redeclare model ColdSideHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    redeclare model HotSideSideHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    pstart_hot=177800)
    annotation (Placement(transformation(extent={{-16,15},{16,-15}},
        rotation=90,
        origin={-13,-6})));

ThermoCycle.Components.Units.PdropAndValves.DP dp_lp(redeclare package Medium
      = ThermoCycle.Media.R245fa_CP,
    k=38.4E3*9.5,
    A=(2*9.5*23282.7)^(-0.5),
    Mdot_nom=0.2588,
    use_rho_nom=true,
    UseHomotopy=false,
    p_nom=190000,
    T_nom=351.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150)
    annotation (Placement(transformation(extent={{32,0},{12,20}})));
ThermoCycle.Components.Units.HeatExchangers.Hx1DConst condenser(redeclare
      package Medium1 =
        ThermoCycle.Media.R245fa_CP,
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
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    pstart_wf=177800,
    Tstart_inlet_wf=316.92,
    Tstart_outlet_wf=298.15,
    Tstart_inlet_sf=293.15,
    Tstart_outlet_sf=296.36)
    annotation (Placement(transformation(extent={{62,-50},{38,-70}})));

ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot heat_sink(
    cp=4187,
    rho=1000,
    Mdot_0=4,
    T_0=293.15)
    annotation (Placement(transformation(extent={{68,-98},{50,-80}})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Pump
                                                     pump(redeclare package
      Medium =
        ThermoCycle.Media.R245fa_CP,
    PumpType=ThermoCycle.Functions.Enumerations.PumpTypes.ORCNext,
    PumpInput=ThermoCycle.Functions.Enumerations.PumpInputs.freq,
    hstart=2.27e5,
    M_dot_start=0.2588)
    annotation (Placement(transformation(extent={{-96,-54},{-72,-30}})));
ThermoCycle.Components.Units.Tanks.Tank_pL tank(redeclare package Medium =
        ThermoCycle.Media.R245fa_CP,
    Vtot=0.015,
    L_start=0.5,
    SteadyState_p=false,
    impose_pressure=true,
    pstart=135000)
    annotation (Placement(transformation(extent={{-42,-78},{-24,-60}})));
 ThermoCycle.Components.FluidFlow.Sensors.SensP sensP(redeclare package Medium
      = ThermoCycle.Media.R245fa_CP)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-104,-64})));
 ThermoCycle.Components.FluidFlow.Sensors.SensMdot sensMdot(redeclare package
      Medium = ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{-64,-34},{-44,-14}})));
 ThermoCycle.Components.HeatFlow.Sensors.SensTp sensTp( redeclare package
      Medium =
        ThermoCycle.Media.R245fa_CP)
    annotation (Placement(transformation(extent={{10,44},{30,64}})));
 ThermoCycle.Components.HeatFlow.Sensors.SensTsf sensTsf
    annotation (Placement(transformation(extent={{-64,94},{-44,114}})));
  Modelica.Blocks.Interfaces.RealOutput Ths
    annotation (Placement(transformation(extent={{-32,100},{-12,120}})));
  Modelica.Blocks.Interfaces.RealOutput Tev
    annotation (Placement(transformation(extent={{42,60},{62,80}})));
  Modelica.Blocks.Interfaces.RealOutput Pexp
    annotation (Placement(transformation(extent={{-2,64},{-22,84}})));
  Modelica.Blocks.Interfaces.RealOutput Mdot
    annotation (Placement(transformation(extent={{-40,-28},{-20,-8}})));
  Modelica.Blocks.Interfaces.RealOutput Pc annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-110,-34})));
  Modelica.Blocks.Interfaces.RealOutput Level
    annotation (Placement(transformation(extent={{-8,-76},{12,-56}})));
  Modelica.Blocks.Interfaces.RealInput Mheat
    annotation (Placement(transformation(extent={{-146,100},{-124,122}})));
  Modelica.Blocks.Interfaces.RealInput Theat
    annotation (Placement(transformation(extent={{-160,76},{-136,100}})));
  Modelica.Blocks.Interfaces.RealInput Mcool
    annotation (Placement(transformation(extent={{136,-86},{110,-60}})));
  Modelica.Blocks.Interfaces.RealInput Tcool
    annotation (Placement(transformation(extent={{140,-116},{116,-92}})));
  Modelica.Blocks.Interfaces.RealInput Up
    annotation (Placement(transformation(extent={{-144,-12},{-118,14}})));
  Modelica.Blocks.Interfaces.RealInput Uexp
    annotation (Placement(transformation(extent={{126,74},{100,100}})));
 ThermoCycle.Components.Units.ControlSystems.Blocks.Tev_SPOptim tev_SPOptim
    annotation (Placement(transformation(extent={{-148,30},{-128,50}})));
ThermoCycle.Components.Units.ControlSystems.Blocks.DELTAT dELTAT
    annotation (Placement(transformation(extent={{44,96},{64,116}})));
  Modelica.Blocks.Interfaces.RealOutput Tevopt
    annotation (Placement(transformation(extent={{-120,32},{-100,52}})));
  Modelica.Blocks.Interfaces.RealOutput deltaT
    annotation (Placement(transformation(extent={{84,112},{104,132}})));
  Modelica.Blocks.Interfaces.RealOutput Tsat
    annotation (Placement(transformation(extent={{100,104},{120,124}})));
equation
  connect(hx1DConst.outletWf, dp_hp.InFlow)
                                         annotation (Line(
      points={{-64,52},{-21,52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.flange_elc,generatorNext. shaft) annotation (Line(
      points={{52.6667,37.3333},{62.4,37.3333},{62.4,34},{71.96,34}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(expander.OutFlow, dp_lp.InFlow) annotation (Line(
      points={{54,28},{54,10},{31,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heat_sink.flange,condenser. inletSf) annotation (Line(
      points={{51.62,-89.09},{24,-89.09},{24,-65},{38,-65}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tank.InFlow, condenser.outletWf) annotation (Line(
      points={{-33,-61.44},{-33,-55},{38,-55}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl1, hx1DConst.inletWf) annotation (Line(
      points={{-18,4.66667},{-18,12},{-98,12},{-98,52},{-92,52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl2, dp_lp.OutFlow) annotation (Line(
      points={{-7,4.45333},{-7,10},{13,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl2, condenser.inletWf) annotation (Line(
      points={{-7.2,-16.4533},{-7.2,-36},{70,-36},{70,-55},{62,-55}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensP.OutFlow, pump.InFlow) annotation (Line(
      points={{-100,-58},{-100,-41.4},{-92.64,-41.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensP.InFlow, tank.OutFlow) annotation (Line(
      points={{-100.1,-70},{-56,-70},{-56,-76.92},{-33,-76.92}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump.OutFlow, sensMdot.InFlow) annotation (Line(
      points={{-77.28,-33.12},{-66.64,-33.12},{-66.64,-28},{-58,-28}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensMdot.OutFlow, recuperator.inlet_fl1) annotation (Line(
      points={{-50,-28},{-18,-28},{-18,-16.6667}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dp_hp.OutFlow, sensTp.InFlow) annotation (Line(
      points={{-3,52},{6,52},{6,49.2},{13,49.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.OutFlow, expander.InFlow) annotation (Line(
      points={{27,49.2},{27,46.6},{32.9333,46.6},{32.9333,42.1333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_Cdot.flange, sensTsf.inlet) annotation (Line(
      points={{-75.8,99.9},{-65.9,99.9},{-65.9,100},{-60,100}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hx1DConst.inletSf, sensTsf.outlet) annotation (Line(
      points={{-64,64},{-48,64},{-48,78},{-30,78},{-30,100},{-48,100}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sensTsf.T, Ths) annotation (Line(
      points={{-46,110},{-22,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sensTp.T, Tev) annotation (Line(
      points={{28,60},{38,60},{38,70},{52,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Pexp, sensTp.p) annotation (Line(
      points={{-12,74},{4,74},{4,60},{12,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sensMdot.Mdot, Mdot) annotation (Line(
      points={{-46,-18},{-30,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sensP.p, Pc) annotation (Line(
      points={{-110,-56},{-110,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tank.level, Level) annotation (Line(
      points={{-25.62,-65.76},{-13.81,-65.76},{-13.81,-66},{2,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Up, pump.flow_in) annotation (Line(
      points={{-131,1},{-131,-17.5},{-87.84,-17.5},{-87.84,-32.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Uexp, generatorNext.f) annotation (Line(
      points={{113,87},{84.56,87},{84.56,47.16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dELTAT.T, sensTp.T) annotation (Line(
      points={{44,101.8},{46,101.8},{46,102},{36,102},{36,60},{28,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dELTAT.P, sensTp.p) annotation (Line(
      points={{44.2,112.6},{12,112.6},{12,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tev_SPOptim.p_cd, sensP.p) annotation (Line(
      points={{-148,46.6},{-156,46.6},{-156,-56},{-110,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tev_SPOptim.T_hf_su, sensTsf.T) annotation (Line(
      points={{-148,41.2},{-150,41.2},{-150,50},{-164,50},{-164,146},{-46,146},
          {-46,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tev_SPOptim.Mdot, sensMdot.Mdot) annotation (Line(
      points={{-148,35.8},{-170,35.8},{-170,-14},{-46,-14},{-46,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tev_SPOptim.Tev, Tevopt) annotation (Line(
      points={{-127.4,41.2},{-120.7,41.2},{-120.7,42},{-110,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dELTAT.DELTAT, deltaT) annotation (Line(
      points={{64.4,109},{75.2,109},{75.2,122},{94,122}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dELTAT.Tsat, Tsat) annotation (Line(
      points={{64.4,105},{84.2,105},{84.2,114},{110,114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Mheat, source_Cdot.M_dot_source) annotation (Line(
      points={{-135,111},{-114,111},{-114,101.8},{-91,101.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Theat, source_Cdot.T_source) annotation (Line(
      points={{-148,88},{-114,88},{-114,97.9},{-91.3,97.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Mcool, heat_sink.M_dot_source) annotation (Line(
      points={{123,-73},{90,-73},{90,-87.38},{65.3,-87.38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tcool, heat_sink.T_source) annotation (Line(
      points={{128,-104},{80,-104},{80,-90.89},{65.57,-90.89}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-160,-140},{140,140}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-160,-140},
            {140,140}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end ORC_245fa_FMU;
