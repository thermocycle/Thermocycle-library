within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.StabilityTest.SpeedTestEva;
model Test_evaFVSES36Const

replaceable package Medium = ThermoCycle.Media.SES36_CP;
parameter Integer N_cells = 20;
parameter Real k_Vol_eva = 1;
parameter Real k_Mass_eva = 1;
parameter Real k_Vol_rec = 1;
parameter Real k_Mass_rec = 1;

  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst eva(
    Mdotconst_wf=false,
    steadystate_h_wf=true,
    steadystate_T_wall=true,
    steadystate_T_sf=false,
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
    Mdotnom_sf=2.147,
    Unom_sf=500,
    N=N_cells,
    pstart_wf=810927,
    Tstart_inlet_wf=293.27,
    Tstart_outlet_wf=398.05,
    Tstart_inlet_sf=398.15,
    Tstart_outlet_sf=389.45)
    annotation (Placement(transformation(extent={{-32,14},{4,52}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    UseT=false,
    h_0=11175.7,
    p=810927,
    T_0=293.27)
    annotation (Placement(transformation(extent={{-98,-2},{-78,18}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    cp=1907,
    rho=937.952,
    Mdot_0=2.147,
    T_0=398.15)
    annotation (Placement(transformation(extent={{18,80},{38,100}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(          redeclare
      package Medium =                                                                         Medium, p0=
       804749)
    annotation (Placement(transformation(extent={{68,-40},{88,-20}})));
//     Real m_dot_su;
//   // Real m_dot_su_tot;
//   // Real h_dot_su_tot;
//   // Real E_dot_su_tot;
//    Real M_su;
//    Real E_su;
//
//    Real m_dot_ex;
//   // Real m_dot_ex_tot;
//   // Real h_dot_ex_tot;
//   // Real E_dot_ex_tot;
//    Real M_ex;
//    Real E_ex;
//
//    Real dMdt_tot;
//    Real dM;
//
//    Real dUdt[N_cells];
//    Real dUdt_tot;
//   // Real dUdt_tot_2;
//    Real dU;
//    Real E_ext_tot;
//   // Real E_ext_tot_2;
//    Real Q_[N_cells];
//    Real Q_tot_;
//
//  /* Variable for model accuracy */
//    Real h_outflow;
//    Real T_outflow;
//    Real m_outflow;

    ThermoCycle.Components.FluidFlow.Sensors.SensTp SensTwfInlet(redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{-66,20},{-46,40}})));
  ThermoCycle.Components.HeatFlow.Sensors.SensTsf SensTsfInlet
    annotation (Placement(transformation(extent={{34,44},{14,64}})));
equation
// /*SYSTEM INLET */
//  /* Mass at the inlet*/
//  m_dot_su = eva.WorkingFluid.InFlow.m_flow;
//  der(M_su) = m_dot_su;
//  /* Total energy at the inlet */
//  der(E_su) = eva.WorkingFluid.InFlow.h_outflow*eva.WorkingFluid.InFlow.m_flow;
//  /* Sum of  enthalpy flow at the inlet  of each cell */
//  m_dot_su_tot = sum(eva.WorkingFluid.Cells.M_dot_su);
//  h_dot_su_tot = sum(eva.WorkingFluid.Cells.hnode_su);
//  E_dot_su_tot = eva.WorkingFluid.Cells.M_dot_su*eva.WorkingFluid.Cells.hnode_su; // m_dot_su_tot*h_dot_su_tot;
//
// /*SYSTEM OUTLET */
//  /*Mass at the outlet*/
//  m_dot_ex = eva.WorkingFluid.OutFlow.m_flow;
//  der(M_ex) = m_dot_ex;
//  /* Total energy at the outlet */
//  der(E_ex) = eva.WorkingFluid.OutFlow.h_outflow*eva.WorkingFluid.OutFlow.m_flow;
//  /* Sum of  enthalpy flow at the outlet  of each cell */
//  m_dot_ex_tot = sum(eva.WorkingFluid.Cells.M_dot_ex);
//  h_dot_ex_tot = sum(eva.WorkingFluid.Cells.hnode_ex);
//  E_dot_ex_tot = eva.WorkingFluid.Cells.M_dot_ex*eva.WorkingFluid.Cells.hnode_ex; //m_dot_ex_tot*h_dot_ex_tot;
//
//  /*ENERGY CHANGE IN THE SYSTEM*/
//  for i in 1:N_cells loop
//    dUdt[i] =  eva.WorkingFluid.Cells[i].M_dot_su*eva.WorkingFluid.Cells[i].hnode_su - eva.WorkingFluid.Cells[i].M_dot_ex*eva.WorkingFluid.Cells[i].hnode_ex + eva.WorkingFluid.Cells[i].Ai*eva.WorkingFluid.Cells[i].qdot;
//    Q_[i] = eva.WorkingFluid.Cells[i].Ai*eva.WorkingFluid.Cells[i].qdot;
//  end for;
//  dUdt_tot = sum(dUdt);
//  //!!!!!!!!!!!!!!!!!!!!!!!! STRANGE THING --> NOT EXPLAINED YET !!!!!!!!!!!!!!!!!
//  //dUdt_tot_2 = E_dot_su_tot - E_dot_ex_tot + eva.WorkingFluid.Q_tot;
//  //SomeHow the method used to calculate dUdt_tot_2 leads to a different results
//  // compared to the one used to calculate dUdt_tot --> I am not able to explain why
//  Q_tot_ = sum(Q_);
//  /* Total energy accumulation in the system */
//  der(dU) = dUdt_tot;
//
//  /* TOTAL THERMAL ENERGY INTO THE SYSTEM */
//  der(E_ext_tot) = eva.WorkingFluid.Q_tot;
// der(E_ext_tot_2) = Q_tot_;
//  /*MASS CHANGE IN THE SYSTEM */
//  dMdt_tot = sum(eva.WorkingFluid.Cells.dMdt);
//  /* Mass accumulation in the system */
//  der(dM) = dMdt_tot;
//
//   /* Outlet variables value */
//  h_outflow = eva.outletWf.h_outflow;
//  T_outflow = sensTp.fluidState.T-273.15;
//  m_outflow = eva.outletWf.m_flow;

  connect(sourceMdot.flangeB, SensTwfInlet.InFlow) annotation (Line(
      points={{-79,8},{-64,8},{-64,25.2},{-63,25.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SensTwfInlet.OutFlow, eva.inletWf) annotation (Line(
      points={{-49,25.2},{-46,25.2},{-46,23.5},{-32,23.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, SensTsfInlet.inlet) annotation (Line(
      points={{36.2,89.9},{56,89.9},{56,50},{30,50}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(SensTsfInlet.outlet, eva.inletSf) annotation (Line(
      points={{18,50},{16,50},{16,52},{14,52},{14,42.5},{4,42.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(eva.outletWf, sinkP.flangeB) annotation (Line(
      points={{4,23.5},{22,23.5},{22,24},{46,24},{46,-30},{69.6,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(
      StartTime=-400,
      StopTime=125,
      __Dymola_NumberOfIntervals=625),
    __Dymola_experimentSetupOutput);
end Test_evaFVSES36Const;
