within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36;
model Step_4_single
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
    annotation (Placement(transformation(extent={{-42,42},{10,100}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{-2,106},{18,126}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    T_0=293.27)
    annotation (Placement(transformation(extent={{-94,10},{-74,30}})));
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
    annotation (Placement(transformation(extent={{54,-2},{78,22}})));
 ParametrizedModels.PdropHP_143 pdropHP_143_1(redeclare package Medium =           Medium)
    annotation (Placement(transformation(extent={{26,44},{46,64}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
                                                                    redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    p=810927,
    T_0=297.89)
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(         redeclare
      package Medium =                                                                         Medium, p0=
       109301)
    annotation (Placement(transformation(extent={{70,-74},{90,-54}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       810927)
    annotation (Placement(transformation(extent={{-48,-18},{-68,2}})));
  MovingBoundaryLibrary.Components.Single.HX_singlephase_pT hX_singlephase_pT(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    A_cf=16.18,
    A_hf=16.18,
    U_cf=3000,
    U_hf=3000,
    p_cf_start=810927,
    p_hf_start=91000,
    T_cf_su_start=297.89,
    T_hf_su_start=367.25,
    T_cf_ex_start=355.27,
    T_hf_ex_start=311.1)
    annotation (Placement(transformation(extent={{-22,-62},{14,-18}})));
  ParametrizedModels.PdropLP_143 pdropLP_143_1(redeclare package Medium =           Medium)
    annotation (Placement(transformation(extent={{72,-22},{52,-2}})));
equation
  connect(sourceCdot.flange,evaGw. InFlowSF) annotation (Line(
      points={{16.2,115.9},{42,115.9},{42,88},{12,88},{12,88.4},{9.48,88.4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB,evaGw. InFlowPF) annotation (Line(
      points={{-75,20},{-62,20},{-62,53.6},{-41.48,53.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(const.y,generator. f) annotation (Line(
      points={{90.7,75},{106.4,75},{106.4,37.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaGw.OutFlowPF, pdropHP_143_1.InFlow) annotation (Line(
      points={{9.48,54.18},{17.74,54.18},{17.74,54},{27,54}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hX_singlephase_pT.outlet_hf, sinkP1.flangeB) annotation (Line(
      points={{-20.2,-56.28},{-20.2,-64},{71.6,-64}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, hX_singlephase_pT.inlet_cf) annotation (
      Line(
      points={{-51,-60},{-46,-60},{-46,-58},{-40,-58},{-40,-40.44},{
          -23.8,-40.44}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinkP.flangeB, hX_singlephase_pT.outlet_cf) annotation (Line(
      points={{-49.6,-8},{40,-8},{40,-40.44},{15.8,-40.44}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pdropLP_143_1.OutFlow, hX_singlephase_pT.inlet_hf)
    annotation (Line(
      points={{53,-12},{12.2,-12},{12.2,-24.16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pdropHP_143_1.OutFlow, expander.InFlow) annotation (Line(
      points={{45,54},{58,54},{58,52},{66,52},{66,28},{59.2,28},{59.2,14.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.flange_elc, generator.shaft) annotation (Line(
      points={{74,11},{84,11},{84,28},{97.4,28}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(expander.OutFlow, pdropLP_143_1.InFlow) annotation (Line(
      points={{75,4},{80,4},{80,6},{90,6},{90,-12},{71,-12}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{140,120}}), graphics), Icon(coordinateSystem(extent={{-120,-120},
            {140,120}})));
end Step_4_single;
