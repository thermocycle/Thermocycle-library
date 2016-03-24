within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36;
model Step_8_OldStyle
replaceable package Medium =
     ThermoCycle.Media.SES36_CP_Smooth;
parameter Real k_Vol_rec = 1;
parameter Real k_Mass_rec = 1;

  MovingBoundaryLibrary.Components.Evaporator.Incompressible.Unit.EvaGwInc evaGw(
    redeclare package Medium = Medium,
    Ltotal=66.6,
    AA=0.0007,
    YY=0.243,
    cpw=500,
    Mw=69,
    epsNTU_sf=true,
    Mdotnom=0.3061,
    UnomSC=3000,
    UnomTP=8000,
    UnomSH=3000,
    Unomsf=1000,
    hstartSC=6.7e4,
    hstartTP=1.8e5,
    hstartSH=2.4e5,
    lstartSC=4,
    lstartTP=16.6,
    lstartSH=46,
    h_pf_out=256022,
    SteadyStatePF=false,
    Set_h_pf_out=true,
    SteadyStateWall=true,
    pstart=810927,
    TstartWall={393.15,393.15,393.15},
    Tstartsf=398.15,
    DTstartsf=278.15)
    annotation (Placement(transformation(extent={{-42,42},{8,82}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{-14,90},
            {6,110}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                           generator(
    fstart=50,
    f(start=50),
    Np=1) annotation (Placement(transformation(extent={{96,18},{116,38}})));
  Modelica.Blocks.Sources.Constant const(k=50)
    annotation (Placement(transformation(extent={{76,68},{90,82}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Expander expander(
    redeclare package Medium = Medium,
    FF_exp=1,
    V_s=1,
    N_rot(start=50),
    rho_su(start=72),
    constPinit=true,
    constinit=true,
    epsilon_start=0.5839,
    FF_start=0.0001115,
    ExpType=ThermoCycle.Functions.Enumerations.ExpTypes.Screw,
    p_su_start=804749,
    p_ex_start=109301,
    T_su_start=398.05)
    annotation (Placement(transformation(extent={{52,2},{76,26}})));
 ParametrizedModels.PdropHP_143 pdropHP_143_1(redeclare package Medium =           Medium)
    annotation (Placement(transformation(extent={{28,40},
            {48,60}})));
 ParametrizedModels.PdropLP_143 pdropLP_143_1( redeclare package Medium =           Medium)
    annotation (Placement(transformation(extent={{44,-10},{24,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    p=810927,
    T_0=297.89)
    annotation (Placement(transformation(extent={{-94,-68},{-74,-48}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1D       Recuperator1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    steadystate_h_cold=true,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    Mdotconst_cold=false,
    Mdotconst_hot=false,
    Vhot=0.03781*k_Vol_rec,
    Vcold=0.03781*k_Vol_rec,
    Unom_l_cold=15000,
    Unom_tp_cold=15000,
    Unom_v_cold=15000,
    Unom_l_hot=10000,
    Unom_tp_hot=10000,
    Unom_v_hot=10000,
    redeclare model ColdSideHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    redeclare model HotSideSideHeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    M_wall=69*k_Mass_rec,
    MdotNom_Hot=0.3061,
    MdotNom_Cold=0.3061,
    steadystate_T_wall=true,
    N=20,
    pstart_cold=810927,
    pstart_hot=94800,
    Tstart_inlet_cold=297.89,
    Tstart_outlet_cold=355.27,
    Tstart_inlet_hot=367.25,
    Tstart_outlet_hot=311.1,
    steadystate_h_hot=true)
    annotation (Placement(transformation(extent={{-24,24},{24,-24}},
        rotation=90,
        origin={-22,-26})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot2(
    Mdot_0=1.546,
    cp=4183,
    rho=1000,
    T_0=295.54)
    annotation (Placement(transformation(extent={{-68,-128},{-48,-108}})));
ParametrizedModels.Tank            tank_pL(
    L_start=0.6,
    redeclare package Medium = Medium,
    impose_pressure=false,
    SteadyState_p=true,
    SteadyState_L=true,
    Vtot=0.06,
    p_ng=29209,
    pstart=65494)
    annotation (Placement(transformation(extent={{-94,-104},{-70,-80}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(          redeclare
      package Medium =                                                                         Medium,
    p0=94800,
    h=13528)
    annotation (Placement(transformation(extent={{-98,-130},{-118,-110}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst Condenser(redeclare
      package Medium1 =                                                             Medium,
    redeclare model Medium2HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence_IdealFluid,
    Unom_sf=3600,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    steadystate_T_sf=true,
    steadystate_h_wf=true,
    steadystate_T_wall=true,
    counterCurrent=true,
    Unom_l=800,
    Unom_tp=800,
    Unom_v=800,
    N=20,
    pstart_wf=94800,
    Tstart_inlet_wf=305.15,
    Tstart_outlet_wf=296.61,
    Tstart_inlet_sf=295.54,
    Tstart_outlet_sf=303.15)
    annotation (Placement(transformation(extent={{-2,-74},{-36,-104}})));

equation
  connect(sourceCdot.flange,evaGw. InFlowSF) annotation (Line(
      points={{4.2,99.9},{48,99.9},{48,74},{7.5,74}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y,generator. f) annotation (Line(
      points={{90.7,75},{106.4,75},{106.4,37.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(expander.flange_elc, generator.shaft) annotation (Line(
      points={{72,15},{84,15},{84,28},{97.4,28}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(evaGw.OutFlowPF, pdropHP_143_1.InFlow) annotation (Line(
      points={{7.5,50.4},{17.74,50.4},{17.74,50},{29,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pdropHP_143_1.OutFlow, expander.InFlow) annotation (Line(
      points={{47,50},{54,50},{54,18.6},{57.2,18.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, pdropLP_143_1.InFlow) annotation (Line(
      points={{73,8},{74,8},{74,0},{43,0}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(Recuperator1.inlet_fl1, sourceMdot.flangeB) annotation (Line(
      points={{-30,-42},{-30,-58},{-75,-58}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(evaGw.InFlowPF, Recuperator1.outlet_fl1) annotation (Line(
      points={{-41.5,50},{-66,50},{-66,16},{-30,16},{-30,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Recuperator1.inlet_fl2, pdropLP_143_1.OutFlow) annotation (Line(
      points={{-12.4,-10.32},{-12.4,0},{25,0}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(sinkP.flangeB, tank_pL.OutFlow) annotation (Line(
      points={{-99.6,-120},{-82,-120},{-82,-102.56}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Recuperator1.outlet_fl2,Condenser. inletWf) annotation (Line(
      points={{-12.72,-41.68},{-12.72,-56},{14,-56},{14,-81.5},{-2,-81.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tank_pL.InFlow,Condenser. outletWf) annotation (Line(
      points={{-82,-81.92},{-82,-76},{-58,-76},{-58,-81.5},{-36,-81.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot2.flange,Condenser. inletSf) annotation (Line(
      points={{-49.8,-118.1},{-42,-118.1},{-42,-96.5},{-36,-96.5}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -140},{140,120}}), graphics), Icon(coordinateSystem(extent={{-120,
            -140},{140,120}})));
end Step_8_OldStyle;
