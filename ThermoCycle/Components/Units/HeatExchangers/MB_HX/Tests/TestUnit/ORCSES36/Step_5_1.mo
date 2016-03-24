within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36;
model Step_5_1
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
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Expander
                          expander(
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
    annotation (Placement(transformation(extent={{52,16},{76,40}})));
 ParametrizedModels.PdropHP_143 pdropHP_143_1(redeclare package Medium =           Medium)
    annotation (Placement(transformation(extent={{28,40},
            {48,60}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1D       Recuperator(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    steadystate_h_cold=true,
    steadystate_h_hot=false,
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
    N=40,
    M_wall=69*k_Mass_rec,
    MdotNom_Hot=0.3061,
    MdotNom_Cold=0.3061,
    pstart_cold=810927,
    pstart_hot=91000,
    Tstart_inlet_cold=297.89,
    Tstart_outlet_cold=355.27,
    Tstart_inlet_hot=367.25,
    Tstart_outlet_hot=311.1)
    annotation (Placement(transformation(extent={{-24,24},{24,-24}},
        rotation=90,
        origin={0,-32})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
                                                                    redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    p=810927,
    T_0=297.89)
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(         redeclare
      package Medium =                                                                         Medium, p0=
       91000)
    annotation (Placement(transformation(extent={{70,-74},{90,-54}})));
  ParametrizedModels.PdropLP_143 pdropLP_143_1(redeclare package Medium =           Medium)
    annotation (Placement(transformation(extent={{44,-10},{24,10}})));
equation
  connect(sourceCdot.flange,evaGw. InFlowSF) annotation (Line(
      points={{4.2,99.9},{48,99.9},{48,74},{7.5,74}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y,generator. f) annotation (Line(
      points={{90.7,75},{106.4,75},{106.4,37.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaGw.OutFlowPF, pdropHP_143_1.InFlow) annotation (Line(
      points={{7.5,50.4},{17.74,50.4},{17.74,50},{29,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, Recuperator.inlet_fl1) annotation (Line(
      points={{-51,-60},{-8,-60},{-8,-48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinkP1.flangeB, Recuperator.outlet_fl2) annotation (Line(
      points={{71.6,-64},{9.28,-64},{9.28,-47.68}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaGw.InFlowPF, Recuperator.outlet_fl1)
    annotation (Line(
      points={{-41.5,50},{-66,50},{-66,4},{-8,4},{-8,
          -16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pdropLP_143_1.OutFlow, Recuperator.inlet_fl2) annotation (
      Line(
      points={{25,0},{9.6,0},{9.6,-16.32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.flange_elc, generator.shaft) annotation (Line(
      points={{72,29},{97.4,29},{97.4,28}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pdropHP_143_1.OutFlow, expander.InFlow) annotation (Line(
      points={{47,50},{50,50},{50,52},{57.2,52},{57.2,32.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, pdropLP_143_1.InFlow) annotation (Line(
      points={{73,22},{76,22},{76,0},{43,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{140,120}}), graphics), Icon(coordinateSystem(extent={{-120,-120},
            {140,120}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Step_5_1;
