within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.StabilityTest.SpeedTestEva;
model Test_evaMBSES36
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
      parameter Integer N_cells = 3;
ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Unit.EvaGw
                                                                                   eva(
    redeclare package Medium = Medium,
    cpw=500,
    Ltotal=66.6,
    AA=0.0007,
    YY=0.243,
    Mw=69,
    counterCurrent=true,
    Mdotnom=0.3061,
    hstartSC=8E4,
    hstartTP=2E5,
    hstartSH=256022,
    lstartSC=22.2,
    lstartTP=22.2,
    lstartSH=22.2,
    h_pf_out=256022,
    SteadyStateWall=true,
    Unomsf=500,
    SteadyStatePF=true,
    Set_h_pf_out=false,
    UnomSC=3000,
    UnomTP=8700,
    UnomSH=3000,
    epsNTU_sf=true,
    epsNTU_pf=false,
    VoidF=0.7,
    VoidFraction=true,
    pstart=810927,
    TstartWall={393.15,393.15,393.15},
    Tstartsf=398.15,
    DTstartsf=283.15)
    annotation (Placement(transformation(extent={{-24,-36},{26,14}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    h_0=11175.7,
    UseT=false,
    T_0=293.15)
    annotation (Placement(transformation(extent={{-68,-36},{-48,-16}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       810927)
    annotation (Placement(transformation(extent={{60,-36},{80,-16}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    cp=1907,
    rho=937.952,
    T_0=398.15)
    annotation (Placement(transformation(extent={{52,-6},{32,14}})));
  BoundaryEva boundaryEva
    annotation (Placement(transformation(extent={{-18,20},{22,52}})));
    /* Variable for checking total energy and mass balance */
    Real m_dot_su;
    Real M_su;
    Real E_su;

    Real m_dot_ex;
    Real M_ex;
    Real E_ex;

    Real dMdt_tot;
    Real dUdt_tot;
    Real dM;
    Real dU;

    Real Q_tot;
    Real E_ext_tot;
    /* Variable for model accuracy */
    Real h_outflow;
    Real T_outflow;
    Real m_outflow;

   /* SECONDARY FLUID */
     Real E_su_sf;
     Real E_ex_sf;
     Real E_ext_sf;

  /* METAL WALL */
  Real E_inWall;
  Real E_outWall;
  Real dUdt_wall[N_cells];
  Real dUdt_tot_wall;
  Real dU_wall;

/* INDEX MASS CONSERVATION */
Real DM_wf;
/* INDEX ENERGY CONSERVATION */
Real DE_HX_sf;
Real DE_HX_sfInOut;
Real DE_HX_wf;
Real DE_HX_wfInOut;
Real DE_HX_wall;

equation
 /* CHECK ENERGY CONSERVATION */
 DE_HX_wfInOut = E_su - abs(E_ex);
 DE_HX_wf = E_ext_tot +  DE_HX_wfInOut - dU;
 DE_HX_sfInOut = E_su_sf - E_ex_sf;
 DE_HX_sf = -E_ext_sf + DE_HX_sfInOut;
 DE_HX_wall = E_inWall  + E_outWall + abs(dU_wall);

/* CHECK MASS CONSERVATION */
DM_wf = M_su + M_ex - dM;

/***************************** SECONDARY FLUID ********************************/
 der(E_su_sf) = eva.secondaryFluid.InFlow_sf.cp*eva.secondaryFluid.InFlow_sf.T*eva.secondaryFluid.InFlow_sf.Mdot;
 der(E_ex_sf) = eva.secondaryFluid.OutFlow_sf.cp*eva.secondaryFluid.OutFlow_sf.T*eva.secondaryFluid.OutFlow_sf.Mdot;
 der(E_ext_sf) =eva.secondaryFluid.qtot;

/************************** METAL WALL **************************************/
der(E_inWall) = eva.Wall.Q_totIn;
der(E_outWall) = eva.Wall.Q_totOut;
for i in 1:N_cells loop
dUdt_wall[i] = eva.Wall.dUdt[i];
end for;
dUdt_tot_wall = sum(dUdt_wall);
der(dU_wall) = dUdt_tot_wall;
/***************************** WORKING FLUID ********************************/
/*SYSTEM INLET */
 /* Mass at the inlet*/
  m_dot_su = eva.evaGeneral.InFlow.m_flow;
  der(M_su) = m_dot_su;
  /* Total energy at the inlet */
  der(E_su) = eva.evaGeneral.InFlow.h_outflow*eva.evaGeneral.InFlow.m_flow;

 /*SYSTEM OUTLET */
  /*Mass at the outlet*/
  m_dot_ex = eva.evaGeneral.OutFlow.m_flow;
  der(M_ex) = m_dot_ex;
  /* Total energy at the outlet */
  der(E_ex) = eva.evaGeneral.OutFlow.h_outflow*eva.evaGeneral.OutFlow.m_flow;

  /*ENERGY CHANGE IN THE SYSTEM*/
  dMdt_tot = eva.evaGeneral.volumeSC.dMdt + eva.evaGeneral.volumeTP.dMdt + eva.evaGeneral.volumeSH.dMdt;
  dUdt_tot = eva.evaGeneral.volumeSC.dUdt + eva.evaGeneral.volumeTP.dUdt + eva.evaGeneral.volumeSH.dUdt;
  der(dU) = dUdt_tot;
  der(dM) = dMdt_tot;

  Q_tot = eva.evaGeneral.volumeSC.q_dot + eva.evaGeneral.volumeTP.q_dot + eva.evaGeneral.volumeSH.q_dot;
  der(E_ext_tot) = Q_tot;

  /* Outlet variables value */
  h_outflow = eva.evaGeneral.OutFlow.h_outflow;
  T_outflow = eva.evaGeneral.volumeSH.T_b-273.15;
  m_outflow = eva.evaGeneral.OutFlow.m_flow;

  connect(sourceMdot.flangeB, eva.InFlowPF) annotation (Line(
      points={{-49,-26},{-38,-26},{-38,-30.2857},{-26.2222,-30.2857}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(eva.OutFlowPF, sinkP.flangeB) annotation (Line(
      points={{26.5556,-31},{62,-31},{62,-26},{61.6,-26}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, eva.InFlowSF) annotation (Line(
      points={{33.8,3.9},{30,3.9},{30,6.85714},{26.5556,6.85714}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boundaryEva.h, sourceMdot.in_h) annotation (Line(
      points={{-18.2,36.16},{-52,36.16},{-52,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundaryEva.p, sinkP.in_p0) annotation (Line(
      points={{25.8,40.96},{66,40.96},{66,-17.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(
      StartTime=-400,
      StopTime=125,
      __Dymola_NumberOfIntervals=525),
    __Dymola_experimentSetupOutput);
end Test_evaMBSES36;
