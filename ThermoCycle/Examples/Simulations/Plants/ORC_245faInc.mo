within ThermoCycle.Examples.Simulations.Plants;
model ORC_245faInc

ThermoCycle.Components.Units.HeatExchangers.Hx1DInc     evaporator(
    N=10,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    Unom_sf=335,
    redeclare package Medium2 =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal)
    annotation (Placement(transformation(extent={{-62,44},{-34,68}})));

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
    UseHomotopy=true)
    annotation (Placement(transformation(extent={{0,42},{20,62}})));
 ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Expander
                                                         expander(
    V_s=1,
    constPinit=false,
    constinit=false,
    ExpType=ThermoCycle.Functions.Enumerations.ExpTypes.Screw,
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
 ThermoCycle.Components.Units.HeatExchangers.Hx1D    recuperator(
    N=10,
    steadystate_h_cold=true,
    steadystate_h_hot=true,
    Mdotconst_cold=true,
    Mdotconst_hot=true,
    steadystate_T_wall=true,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    redeclare package Medium2 = ThermoCycle.Media.R245fa_CP,
    redeclare model ColdSideHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    redeclare model HotSideSideHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    pstart_hot=177800,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal)
    annotation (Placement(transformation(extent={{-16,15},{16,-15}},
        rotation=90,
        origin={-13,-8})));

ThermoCycle.Components.Units.PdropAndValves.DP dp_lp(
    k=38.4E3*9.5,
    A=(2*9.5*23282.7)^(-0.5),
    Mdot_nom=0.2588,
    use_rho_nom=true,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p_nom=190000,
    T_nom=351.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150,
    UseHomotopy=true)
    annotation (Placement(transformation(extent={{32,0},{12,20}})));
 ThermoCycle.Components.Units.HeatExchangers.Hx1DInc     condenser(
    Unom_l=500,
    Unom_tp=1500,
    Unom_v=750,
    Mdotnom_sf=4,
    steadystate_T_wall=false,
    N=10,
    filter_dMdt_wf=false,
    max_drhodt_wf=50,
    steadystate_h_wf=true,
    Unom_sf=335,
    redeclare package Medium2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    max_der_wf=true,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    pstart_wf=177800,
    Tstart_inlet_wf=316.92,
    Tstart_outlet_wf=298.15,
    Tstart_inlet_sf=293.15,
    Tstart_outlet_sf=296.36)
    annotation (Placement(transformation(extent={{30,-50},{6,-70}})));

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
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot source_htf(
    redeclare package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66,
    Mdot_0=3,
    T_0=418.15) annotation (Placement(transformation(extent={{2,66},{-18,86}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sink_htf(redeclare package
      Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66)
    annotation (Placement(transformation(extent={{-84,68},{-96,80}})));
ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot source_cf(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    Mdot_0=4,
    T_0=293.15) annotation (Placement(transformation(extent={{-24,-88},{-10,
            -74}})));
ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sink_htf1(redeclare package
      Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, p0=300000)
    annotation (Placement(transformation(extent={{50,-80},{62,-68}})));
equation
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
  connect(tank.OutFlow, pump.InFlow) annotation (Line(
      points={{-33,-76.92},{-33,-80},{-78,-80},{-78,-41.4},{-70.64,-41.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(f_pp.y, pump.flow_in) annotation (Line(
      points={{-77.4,-6},{-65.84,-6},{-65.84,-32.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl1, pump.OutFlow) annotation (Line(
      points={{-18,-18.6667},{-18,-33.12},{-55.28,-33.12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl2, dp_lp.OutFlow) annotation (Line(
      points={{-7,2.45333},{-7,10},{13,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl2, condenser.inlet_fl1) annotation (Line(
      points={{-7.2,-18.4533},{-7.2,-36},{38,-36},{38,-56.1538},{27.2308,
          -56.1538}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condenser.outlet_fl1, tank.InFlow) annotation (Line(
      points={{8.76923,-56.1538},{-14,-56.1538},{-14,-56},{-33,-56},{-33,-61.44}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_cf.flangeB, condenser.inlet_fl2) annotation (Line(
      points={{-10.7,-81},{0,-81},{0,-64.6154},{8.95385,-64.6154}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condenser.outlet_fl2, sink_htf1.flangeB) annotation (Line(
      points={{27.0462,-64.4615},{42,-64.4615},{42,-74},{50.96,-74}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl1, evaporator.inlet_fl1) annotation (Line(
      points={{-18,2.66667},{-18,26},{-84,26},{-84,51.3846},{-58.7692,51.3846}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaporator.outlet_fl1, dp_hp.InFlow) annotation (Line(
      points={{-37.2308,51.3846},{-18.1154,51.3846},{-18.1154,52},{1,52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaporator.inlet_fl2, source_htf.flangeB) annotation (Line(
      points={{-37.4462,61.5385},{-26,61.5385},{-26,76},{-17,76}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaporator.outlet_fl2, sink_htf.flangeB) annotation (Line(
      points={{-58.5538,61.3538},{-74,61.3538},{-74,74},{-84.96,74}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Dynamic model of an Organic Rankine Cycle with recuperator and R245fa as working fluid.</p>
<p><h4><font color=\"#008000\">Modeling assumptions</font></h4></p>
<p><ul>
<li> The pressure drops are lumped into two punctual pressure drop components in the vapor lines</li>
<li> No control of the cycle is implemented</li>
<li> The properties of R245fa are calculated using CoolProp</li>
<li> The centrifugal pump and the screw expander are modeled using efficiency curves derived from experimental data</li>
</ul></p>
<p><br/>NB: A second version of this model is also provided, in which the properties of R245fa are computed in CoolProp with the TTSE method, which dramatically increases the simulation speed.</p>
</html>"));
end ORC_245faInc;
