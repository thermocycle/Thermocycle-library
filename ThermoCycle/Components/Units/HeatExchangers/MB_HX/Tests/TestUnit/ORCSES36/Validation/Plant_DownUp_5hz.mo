within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36.Validation;
model Plant_DownUp_5hz

replaceable package Medium = CoolProp2Modelica.Media.SES36_CP;

parameter Integer Nnodes = 20;
parameter Real k_Vol_eva = 0.6;
parameter Real k_Mass_eva = 0.02;
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

  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst evaporator(
    Mdotconst_wf=false,
    steadystate_T_wall=true,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare package Medium1 = Medium,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance,
    Mdotnom_wf=0.3061,
    Unom_l=3000,
    Unom_tp=8700,
    Unom_v=3000,
    V_sf=0.03781*k_Vol_eva,
    V_wf=0.03781*k_Vol_eva,
    M_wall=69*k_Mass_eva,
    Mdotnom_sf=3.147,
    steadystate_T_sf=true,
    steadystate_h_wf=false,
    N=Nnodes,
    Unom_sf=1000,
    pstart_wf=810927,
    Tstart_inlet_wf=355.27,
    Tstart_outlet_wf=398.05,
    Tstart_inlet_sf=398.15,
    Tstart_outlet_sf=389.45)
    annotation (Placement(transformation(extent={{-36,74},{0,112}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    cp=1907,
    rho=937.952,
    T_0=398.15)
    annotation (Placement(transformation(extent={{50,100},{30,120}})));
 ParametrizedModels.PdropHP_143 pdropHP(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{28,72},{48,92}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                           generator(
    fstart=50,
    f(start=50),
    Np=1) annotation (Placement(transformation(extent={{88,64},{108,84}})));
  Modelica.Blocks.Sources.Constant const(k=50)
    annotation (Placement(transformation(extent={{74,94},{88,108}})));
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
    annotation (Placement(transformation(extent={{56,58},{80,82}})));

  ThermoCycle.Components.Units.HeatExchangers.Hx1D       recuperator(
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
    N=Nnodes,
    pstart_cold=810927,
    pstart_hot=94702,
    Tstart_inlet_cold=297.89,
    Tstart_outlet_cold=355.27,
    Tstart_inlet_hot=367.25,
    Tstart_outlet_hot=311.1)
    annotation (Placement(transformation(extent={{-24,24},{24,-24}},
        rotation=90,
        origin={-30,18})));

ParametrizedModels.PdropLP_143 pdropLP(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{52,28},{32,48}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst condenser(
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
    N=Nnodes,
    pstart_wf=94702,
    Tstart_inlet_wf=311.1,
    Tstart_outlet_wf=296.61,
    Tstart_inlet_sf=295.54,
    Tstart_outlet_sf=303.51)
    annotation (Placement(transformation(extent={{64,-20},{34,-50}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot1(
    Mdot_0=1.546,
    cp=4183,
    rho=1000,
    T_0=295.54)
    annotation (Placement(transformation(extent={{-4,-66},{16,-46}})));
ParametrizedModels.Tank tank(
    Vtot=0.06032,
    L_start=0.6,
    redeclare package Medium = Medium,
    impose_pressure=false,
    p_ng=29209,
    pstart=65494) annotation (Placement(transformation(extent={{-68,-56},
            {-44,-32}})));
  ParametrizedModels.Pump pump(
    redeclare package Medium = Medium,
    PumpType=ThermoCycle.Functions.Enumerations.PumpTypes.ORCNext,
    f_pp0=50,
    PumpInput=ThermoCycle.Functions.Enumerations.PumpInputs.freq,
    M_dot_start=0.3061,
    hstart=16131) annotation (Placement(transformation(extent={{-100,
            -38},{-70,-8}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensorEvaExp(redeclare package
      Medium =         Medium)
    annotation (Placement(transformation(extent={{10,80},{24,94}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp sensorRecEva(redeclare package
      Medium =         Medium)
    annotation (Placement(transformation(extent={{-66,78},{-48,96}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp SensorExpRec(redeclare package
      Medium =         Medium) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={14,52})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp SensorCondTank(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{14,-34},{-6,-14}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTp SensorRecCond(redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{36,-6},{56,14}})));
 ParametrizedModels.T_cf_cd_su_spline
    Tcf_cd_su annotation (Placement(transformation(extent={{-38,-74},
            {-18,-54}})));
  ParametrizedModels.f_pp_spline f_pump
    annotation (Placement(transformation(extent={{-144,8},{-124,28}})));
  ParametrizedModels.orcMassFlow orcMassFlow
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
equation

 m_dot_wf = orcMassFlow.M_dot_orc;
 W_dot = expander.W_dot;
 T_eva_su = sensorRecEva.T;
 T_exp_su = sensorEvaExp.T;
 p_exp_su = expander.InFlow.p;
 T_sf_cd_su =  Tcf_cd_su.y;
 VV = 1;
 T_exp_out = SensorExpRec.T;
 p_exp_out = expander.OutFlow.p;

  connect(const.y,generator. f) annotation (Line(
      points={{88.7,101},{98.4,101},{98.4,83.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(expander.flange_elc, generator.shaft) annotation (Line(
      points={{76,71},{76,74},{89.4,74}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pdropHP.OutFlow, expander.InFlow) annotation (Line(
      points={{47,82},{61.2,82},{61.2,74.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, pdropLP.InFlow) annotation (Line(
      points={{77,64},{78,64},{78,36},{51,36},{51,38}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(pump.InFlow, tank.OutFlow) annotation (Line(
      points={{-95.8,-22.25},{-112,-22.25},{-112,-66},{-56,-66},{-56,
          -54.56}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(evaporator.outletWf, sensorEvaExp.InFlow) annotation (Line(
      points={{0,83.5},{2,83.5},{2,83.64},{12.1,83.64}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SensorExpRec.InFlow, pdropLP.OutFlow) annotation (Line(
      points={{21,47.2},{33,47.2},{33,38}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SensorExpRec.OutFlow, recuperator.inlet_fl2) annotation (Line(
      points={{7,47.2},{-20.4,47.2},{-20.4,33.68}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl2, SensorRecCond.InFlow) annotation (
      Line(
      points={{-20.72,2.32},{-20.72,-0.8},{39,-0.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SensorRecCond.OutFlow, condenser.inletWf) annotation (Line(
      points={{53,-0.8},{80,-0.8},{80,-27.5},{64,-27.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(condenser.outletWf, SensorCondTank.InFlow) annotation (Line(
      points={{34,-27.5},{24,-27.5},{24,-28.8},{11,-28.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SensorCondTank.OutFlow, tank.InFlow) annotation (Line(
      points={{-3,-28.8},{-24,-28.8},{-24,-28},{-56,-28},{-56,-33.92}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot1.flange, condenser.inletSf) annotation (Line(
      points={{14.2,-56.1},{25.1,-56.1},{25.1,-42.5},{34,-42.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Tcf_cd_su.y, sourceCdot1.T_source) annotation (Line(
      points={{-17,-64},{-6,-64},{-6,-58.1},{-1.3,-58.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.OutFlow, recuperator.inlet_fl1) annotation (Line(
      points={{-76.6,-11.9},{-64,-11.9},{-64,-4},{-38,-4},{-38,2}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(f_pump.y, pump.flow_in) annotation (Line(
      points={{-123,18},{-89.8,18},{-89.8,-11}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(evaporator.inletSf, sourceCdot.flange) annotation (Line(
      points={{0,102.5},{8,102.5},{8,109.9},{31.8,109.9}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(sensorEvaExp.OutFlow, pdropHP.InFlow) annotation (Line(
      points={{21.9,83.64},{26,83.64},{26,82},{29,82}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(orcMassFlow.M_dot_orc, pump.M_dot_ext) annotation (Line(
      points={{-100,40.2},{-88,40.2},{-88,42},{-83.95,42},{-83.95,
          -10.25}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(recuperator.outlet_fl1, sensorRecEva.InFlow) annotation (Line(
      points={{-38,34},{-40,34},{-40,58},{-90,58},{-90,82.68},{-63.3,82.68}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensorRecEva.OutFlow, evaporator.inletWf) annotation (Line(
      points={{-50.7,82.68},{-42.35,82.68},{-42.35,83.5},{-36,83.5}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -100},{120,140}}), graphics),
    Icon(coordinateSystem(extent={{-160,-100},{120,140}})),
    experiment(StartTime=-1500, StopTime=3500),
    __Dymola_experimentSetupOutput, Documentation(info = "<HTML>
    <p><big> The model simulates a step change in the pump rotational speed. 
    <p><big>The amplitude of the step is 5 Hz. 
    <p><big>The step downwards happens at t = 300 seconds the step upwards happens at t=2061 seconds.
    <p><big> The presence of non-condensable gases is modelled in the system by calculating the total pressure of the system as the sum of the working fluid pressure plus a constant 
    value representing the partial pressure of the non-condensable gases, calculated off-line based on the experimental values.</p>
     <p><big> The inputs to the model are:
     <ul>
     <li>Temperature and mass flow of the thermal energy source (they are constant during the simulation).
     <li>Expander and pump rotational speed
     <li>Working fluid mass flow rate
     <li>Temperature and mass flow of the cooling circuit. (the cooling fluid mass flow is not constant and it is imposed with a spline signal
</ul>
    <p> </p>
    <p> </p>
    <p> </p>
    The first steady state corresponds to line 93 of the EES file Data_Analysis_AD
    
    </HTML>"));
end Plant_DownUp_5hz;
