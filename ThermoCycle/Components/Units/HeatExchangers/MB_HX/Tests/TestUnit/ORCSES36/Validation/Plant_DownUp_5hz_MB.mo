within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36.Validation;
model Plant_DownUp_5hz_MB
replaceable package Medium =
      CoolProp2Modelica.Media.SES36_CP;
parameter Real k_Vol_rec = 1;
parameter Real k_Mass_rec = 1;

Real m_dot_wf;
Real W_dot;
Real T_eva_su;
Real T_exp_su;
Real p_exp_su;
Real T_sf_cd_su;
Real VV;
Real T_exp_out;
Real p_exp_out;
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{-30,104},{-10,124}})));
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
    annotation (Placement(transformation(extent={{52,12},{76,36}})));
 ParametrizedModels.PdropHP_143 pdropHP_143_1(redeclare package Medium =           Medium)
    annotation (Placement(transformation(extent={{28,40},
            {48,60}})));
  ParametrizedModels.PdropLP_143 pdropLP_143_1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{44,-10},{24,10}})));
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
    N=20,
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
    Unom_sf=3600,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Mdotnom_wf=0.3061,
    Mdotnom_sf=1.546,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    N=20,
    pstart_wf=94702,
    Tstart_inlet_wf=311.1,
    Tstart_outlet_wf=296.61,
    Tstart_inlet_sf=295.54,
    Tstart_outlet_sf=303.51)
    annotation (Placement(transformation(extent={{32,-72},{2,-102}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot2(
    Mdot_0=1.546,
    cp=4183,
    rho=1000,
    T_0=295.54)
    annotation (Placement(transformation(extent={{-52,-152},{-32,-132}})));
ParametrizedModels.Tank             tank_pL(
    Vtot=0.06032,
    L_start=0.6,
    redeclare package Medium = Medium,
    p_ng=29209,
    pstart=65494,
    impose_pressure=false)
    annotation (Placement(transformation(extent={{-66,-110},{-42,-86}})));
  ParametrizedModels.Pump
                      pump_AD(
    redeclare package Medium = Medium,
    PumpType=ThermoCycle.Functions.Enumerations.PumpTypes.ORCNext,
    f_pp0=50,
    PumpInput=ThermoCycle.Functions.Enumerations.PumpInputs.freq,
    M_dot_start=0.3061,
    hstart=16131) annotation (Placement(transformation(extent={{-124,
            -78},{-94,-48}})));
  ParametrizedModels.T_cf_cd_su_spline
                            Tcf_cd_su annotation (Placement(
        transformation(extent={{-104,-144},{-84,-124}})));
  ParametrizedModels.f_pp_spline
                      f_pump annotation (Placement(transformation(
          extent={{-150,-40},{-130,-20}})));
  ParametrizedModels.orcMassFlow
                      orcMassFlow annotation (Placement(transformation(
          extent={{-148,-10},{-128,10}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensorRecEva(redeclare package
      Medium =         Medium)
    annotation (Placement(transformation(extent={{-78,22},{-96,40}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensorEvaExp(redeclare package
      Medium =         Medium)
    annotation (Placement(transformation(extent={{6,52},{20,66}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp SensorExpRec(redeclare package
      Medium =         Medium) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,24})));
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
    VoidFraction=false,
    VoidF=0.8,
    pstart=810927,
    TstartWall={393.15,393.15,393.15},
    Tstartsf=398.15,
    DTstartsf=278.15)
    annotation (Placement(transformation(extent={{-60,50},{-10,90}})));
equation

 m_dot_wf = orcMassFlow.M_dot_orc;
 W_dot = expander.W_dot;
 T_eva_su = sensorRecEva.T;
 T_exp_su = sensorEvaExp.T;
 p_exp_su = expander.InFlow.p;
 T_sf_cd_su =  Tcf_cd_su.y;
 VV = evaGw.evaGeneral.volumeTP.VV;
 T_exp_out = SensorExpRec.T;
 p_exp_out = expander.OutFlow.p;

  connect(const.y,generator. f) annotation (Line(
      points={{90.7,75},{106.4,75},{106.4,37.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(expander.flange_elc, generator.shaft) annotation (Line(
      points={{72,25},{84,25},{84,28},{97.4,28}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pdropHP_143_1.OutFlow, expander.InFlow) annotation (Line(
      points={{47,50},{54,50},{54,28.6},{57.2,28.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, pdropLP_143_1.InFlow) annotation (Line(
      points={{73,18},{74,18},{74,0},{43,0}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(Recuperator1.outlet_fl2, Condenser.inletWf) annotation (Line(
      points={{-12.72,-41.68},{-12.72,-56},{78,-56},{78,-80},{32,-80},{32,-79.5}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(sourceCdot2.flange,Condenser. inletSf) annotation (Line(
      points={{-33.8,-142.1},{-10,-142.1},{-10,-94.5},{2,-94.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tank_pL.InFlow, Condenser.outletWf) annotation (Line(
      points={{-54,-87.92},{-54,-80},{2,-80},{2,-79.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump_AD.OutFlow, Recuperator1.inlet_fl1) annotation (Line(
      points={{-100.6,-51.9},{-30,-51.9},{-30,-42}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump_AD.InFlow, tank_pL.OutFlow) annotation (Line(
      points={{-119.8,-62.25},{-140,-62.25},{-140,-116},{-54,-116},{
          -54,-108.56}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(f_pump.y, pump_AD.flow_in) annotation (Line(
      points={{-129,-30},{-113.8,-30},{-113.8,-51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(orcMassFlow.M_dot_orc, pump_AD.M_dot_ext) annotation (Line(
      points={{-128,0.2},{-116,0.2},{-116,0},{-107.95,0},{-107.95,
          -50.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tcf_cd_su.y, sourceCdot2.T_source) annotation (Line(
      points={{-83,-134},{-62,-134},{-62,-144.1},{-49.3,-144.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Recuperator1.outlet_fl1, sensorRecEva.InFlow) annotation (Line(
      points={{-30,-10},{-30,26.68},{-80.7,26.68}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensorEvaExp.OutFlow, pdropHP_143_1.InFlow) annotation (Line(
      points={{17.9,55.64},{22,55.64},{22,50},{29,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SensorExpRec.InFlow, pdropLP_143_1.OutFlow) annotation (Line(
      points={{17,19.2},{18,19.2},{18,0},{25,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SensorExpRec.OutFlow, Recuperator1.inlet_fl2) annotation (Line(
      points={{3,19.2},{-12.4,19.2},{-12.4,-10.32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensorRecEva.OutFlow, evaGw.InFlowPF) annotation (Line(
      points={{-93.3,26.68},{-108,26.68},{-108,58},{-59.5,58}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, evaGw.InFlowSF) annotation (Line(
      points={{-11.8,113.9},{6,113.9},{6,82},{-10.5,82}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(evaGw.OutFlowPF, sensorEvaExp.InFlow) annotation (Line(
      points={{-10.5,58.4},{-2.25,58.4},{-2.25,55.64},{8.1,55.64}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{140,120}}), graphics), Icon(coordinateSystem(extent={{-160,
            -160},{140,120}})),
    experiment(StartTime=-1500, StopTime=3500),
    __Dymola_experimentSetupOutput);
end Plant_DownUp_5hz_MB;
