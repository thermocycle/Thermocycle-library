within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36;
model Step_2
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
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
    annotation (Placement(transformation(extent={{-54,-22},{-2,36}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{-56,72},{-36,92}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    T_0=293.27)
    annotation (Placement(transformation(extent={{-106,-54},{-86,-34}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(          redeclare
      package Medium =                                                                         Medium, p0=
       109301)
    annotation (Placement(transformation(extent={{54,-102},{74,-82}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                           generator(
    fstart=50,
    f(start=50),
    Np=1) annotation (Placement(transformation(extent={{84,-46},{104,-26}})));
  Modelica.Blocks.Sources.Constant const(k=50)
    annotation (Placement(transformation(extent={{64,4},{78,18}})));
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
    annotation (Placement(transformation(extent={{36,-58},{60,-34}})));
equation
  connect(sourceCdot.flange,evaGw. InFlowSF) annotation (Line(
      points={{-37.8,81.9},{28,81.9},{28,24},{-2,24},{-2,24.4},{-2.52,24.4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB,evaGw. InFlowPF) annotation (Line(
      points={{-87,-44},{-74,-44},{-74,-10.4},{-53.48,-10.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(const.y,generator. f) annotation (Line(
      points={{78.7,11},{94.4,11},{94.4,-26.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaGw.OutFlowPF, expander.InFlow) annotation (Line(
      points={{-2.52,-9.82},{41.2,-9.82},{41.2,-41.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.flange_elc, generator.shaft) annotation (Line(
      points={{56,-45},{62,-45},{62,-44},{70,-44},{70,-36},{85.4,-36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(expander.OutFlow, sinkP.flangeB) annotation (Line(
      points={{57,-52},{56,-52},{56,-64},{36,-64},{36,-92},{55.6,-92}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Step_2;
