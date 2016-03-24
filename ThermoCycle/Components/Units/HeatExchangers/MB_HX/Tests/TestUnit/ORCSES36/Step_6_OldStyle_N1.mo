within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36;
model Step_6_OldStyle_N1
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
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
  ParametrizedModels.PdropLP_143 pdropLP_143_1(redeclare package Medium =           Medium)
    annotation (Placement(transformation(extent={{44,-10},{24,10}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    p=810927,
    T_0=297.89)
    annotation (Placement(transformation(extent={{-94,-68},{-74,-48}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(         redeclare
      package Medium =                                                                         Medium,
    h=187588,
    p0=94702)
    annotation (Placement(transformation(extent={{-68,-92},{-88,-72}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1D       Recuperator1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    steadystate_h_cold=true,
    steadystate_T_wall=true,
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
    steadystate_h_hot=true,
    N=2,
    pstart_cold=810927,
    pstart_hot=94702,
    Tstart_inlet_cold=297.89,
    Tstart_outlet_cold=355.27,
    Tstart_inlet_hot=367.25,
    Tstart_outlet_hot=311.1)
    annotation (Placement(transformation(extent={{-24,24},{24,-24}},
        rotation=90,
        origin={-22,-26})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst Condenser(
    redeclare package Medium1 = Medium,
    steadystate_h_wf=true,
    steadystate_T_sf=true,
    steadystate_T_wall=true,
    Unom_l=1000,
    Unom_tp=1000,
    Unom_v=1000,
    max_der_wf=true,
    filter_dMdt_wf=true,
    N=30,
    Unom_sf=3600,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Mdotnom_wf=0.3061,
    Mdotnom_sf=1.546,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    pstart_wf=94702,
    Tstart_inlet_wf=311.1,
    Tstart_outlet_wf=296.61,
    Tstart_inlet_sf=295.54,
    Tstart_outlet_sf=303.51)
    annotation (Placement(transformation(extent={{-2,-72},{-32,-102}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot2(
    Mdot_0=1.546,
    cp=4183,
    rho=1000,
    T_0=295.54)
    annotation (Placement(transformation(extent={{-64,-114},{-44,-94}})));
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
      points={{-30,-42},{-42,-42},{-42,-58},{-75,-58}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Recuperator1.outlet_fl2, Condenser.inletWf) annotation (Line(
      points={{-12.72,-41.68},{-12.72,-56},{20,-56},{20,-80},{-2,-80},{-2,-79.5}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(sinkP1.flangeB, Condenser.outletWf) annotation (Line(
      points={{-69.6,-82},{-50,-82},{-50,-78},{-46,-78},{-46,-79.5},{-32,-79.5}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(sourceCdot2.flange,Condenser. inletSf) annotation (Line(
      points={{-45.8,-104.1},{-40,-104.1},{-40,-94.5},{-32,-94.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(evaGw.InFlowPF, Recuperator1.outlet_fl1) annotation (Line(
      points={{-41.5,50},{-66,50},{-66,16},{-30,16},{-30,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Recuperator1.inlet_fl2, pdropLP_143_1.OutFlow) annotation (Line(
      points={{-12.4,-10.32},{-12.4,0},{25,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{140,120}}), graphics), Icon(coordinateSystem(extent={{-120,-120},
            {140,120}})));
end Step_6_OldStyle_N1;
