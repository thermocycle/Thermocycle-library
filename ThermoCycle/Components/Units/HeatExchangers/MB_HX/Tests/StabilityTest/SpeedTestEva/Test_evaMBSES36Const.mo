within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.StabilityTest.SpeedTestEva;
model Test_evaMBSES36Const
replaceable package Medium =
      ThermoCycle.Media.SES36_CP;
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
    VoidF=0.8,
    VoidFraction=false,
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
    annotation (Placement(transformation(extent={{-86,-42},{-66,-22}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       804749)
    annotation (Placement(transformation(extent={{88,-24},{108,-4}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    cp=1907,
    rho=937.952,
    T_0=398.15)
    annotation (Placement(transformation(extent={{12,22},{32,42}})));
    /* Variable for checking total energy and mass balance */
//    Real m_dot_su;
//    Real M_su;
//    Real E_su;
//
//    Real m_dot_ex;
//    Real M_ex;
//    Real E_ex;
//
//    Real dMdt_tot;
//    Real dUdt_tot;
//    Real dM;
//    Real dU;
//
//    Real Q_tot;
//    Real E_ext_tot;
//    /* Variable for model accuracy */
//    Real h_outflow;
//    Real T_outflow;
//    Real m_outflow;
//
// equation
// /*SYSTEM INLET */
//  /* Mass at the inlet*/
//  m_dot_su = evaG.evaGeneral.InFlow.m_flow;
//  der(M_su) = m_dot_su;
//  /* Total energy at the inlet */
//  der(E_su) = evaG.evaGeneral.InFlow.h_outflow*evaG.evaGeneral.InFlow.m_flow;
//
// /*SYSTEM OUTLET */
//  /*Mass at the outlet*/
//  m_dot_ex = evaG.evaGeneral.OutFlow.m_flow;
//  der(M_ex) = m_dot_ex;
//  /* Total energy at the outlet */
//  der(E_ex) = evaG.evaGeneral.OutFlow.h_outflow*evaG.evaGeneral.OutFlow.m_flow;
//
//  /*ENERGY CHANGE IN THE SYSTEM*/
//  dMdt_tot = evaG.evaGeneral.volumeSC.dMdt + evaG.evaGeneral.volumeTP.dMdt + evaG.evaGeneral.volumeSH.dMdt;
//  dUdt_tot = evaG.evaGeneral.volumeSC.dUdt + evaG.evaGeneral.volumeTP.dUdt + evaG.evaGeneral.volumeSH.dUdt;
//  der(dU) = dUdt_tot;
//  der(dM) = dMdt_tot;
//
//  Q_tot = evaG.evaGeneral.volumeSC.q_dot + evaG.evaGeneral.volumeTP.q_dot + evaG.evaGeneral.volumeSH.q_dot;
//  der(E_ext_tot) = Q_tot;
//
//  /* Outlet variables value */
//  h_outflow = evaG.evaGeneral.OutFlow.h_outflow;
//  T_outflow = evaG.evaGeneral.volumeSH.T_b-273.15;
//  m_outflow = evaG.evaGeneral.OutFlow.m_flow;

equation
  connect(sourceMdot.flangeB, eva.InFlowPF) annotation (Line(
      points={{-67,-32},{-36,-32},{-36,-30.2857},{-26.2222,-30.2857}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(eva.OutFlowPF, sinkP.flangeB) annotation (Line(
      points={{26.5556,-31},{62,-31},{62,-14},{89.6,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, eva.InFlowSF) annotation (Line(
      points={{30.2,31.9},{58,31.9},{58,6.85714},{26.5556,6.85714}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(
      StartTime=-400,
      StopTime=125,
      __Dymola_NumberOfIntervals=525),
    __Dymola_experimentSetupOutput);
end Test_evaMBSES36Const;
