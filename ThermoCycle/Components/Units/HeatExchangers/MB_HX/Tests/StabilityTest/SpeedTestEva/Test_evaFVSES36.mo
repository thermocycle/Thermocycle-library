within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.StabilityTest.SpeedTestEva;
model Test_evaFVSES36

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
    annotation (Placement(transformation(extent={{-14,-30},{22,8}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    UseT=false,
    p=810927,
    T_0=293.27,
    h_0=11175.7)
    annotation (Placement(transformation(extent={{-54,-32},{-34,-12}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    cp=1907,
    rho=937.952,
    Mdot_0=2.147,
    T_0=398.15)
    annotation (Placement(transformation(extent={{52,-8},{32,12}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(          redeclare
      package Medium =                                                                         Medium, p0=
       804749)
    annotation (Placement(transformation(extent={{56,-30},{76,-10}})));
  BoundaryEva boundaryEva
    annotation (Placement(transformation(extent={{-18,16},{26,54}})));
   /* Working fluid */
   Real m_dot_su;
    Real M_su;
    Real E_su;

    Real m_dot_ex;
    Real M_ex;
    Real E_ex;

    Real dMdt_tot;
    Real dM;

    Real dUdt[N_cells];
    Real dUdt_tot;
   // Real dUdt_tot_2;
    Real dU;
    Real E_ext_tot;
   // Real E_ext_tot_2;
    Real Q_[N_cells];
    Real Q_tot_;

  /* Variable for model accuracy */
    Real h_outflow;
    Real T_outflow;
    Real m_outflow;

    /* SECONDARY FLUID */
    Real E_su_sf;
    Real E_ex_sf;
    Real E_ext_sf;
    Real dUdt_sf[N_cells];
    Real dUdt_sf_tot;
    Real dU_sf;

    /* METAL WALL */
    Real dUdt_wall[N_cells];
    Real dUdt_tot_wall;
    Real dU_wall;
    Real E_inWall;
    Real E_outWall;
/* INDEX MASS CONSERVATION */
Real DM_wf;
/* INDEX ENERGY CONSERVATION */
Real DE_HX_sf;
Real DE_HX_sfInOut;
Real DE_HX_wf;
Real DE_HX_wfInOut;
Real DE_HX_wall;
Real DE_HX;

equation
 /* CHECK ENERGY CONSERVATION */
 DE_HX_sfInOut =  E_su_sf -E_ex_sf;
 DE_HX_sf = E_ext_sf + (DE_HX_sfInOut) - dU_sf;
 DE_HX_wfInOut = E_su - abs(E_ex);
 DE_HX_wf = E_ext_tot + DE_HX_wfInOut - dU;
 DE_HX_wall = E_inWall  + E_outWall + abs(dU_wall);
 DE_HX = DE_HX_sf + DE_HX_wf + DE_HX_wall;

 /* CHECK MASS CONSERVATION */
DM_wf = M_su + M_ex - dM;
/***************************** SECONDARY FLUID ********************************/
 der(E_su_sf) = eva.SecondaryFluid.flange_Cdot.cp*eva.SecondaryFluid.flange_Cdot.T*eva.SecondaryFluid.flange_Cdot.Mdot;
 der(E_ex_sf) = eva.SecondaryFluid.flange_ex_Cdot.cp*eva.SecondaryFluid.flange_ex_Cdot.T*eva.SecondaryFluid.flange_ex_Cdot.Mdot;
 der(E_ext_sf) =eva.SecondaryFluid.Q_tot;
 for i in 1:N_cells loop
 dUdt_sf[i] = eva.SecondaryFluid.Cells[i].Mdot*eva.SecondaryFluid.Cells[i].cp*(eva.SecondaryFluid.Cells[i].Tnode_su - eva.SecondaryFluid.Cells[i].Tnode_ex) + eva.SecondaryFluid.Cells[i].Ai*eva.SecondaryFluid.Cells[i].qdot;
 end for;
 dUdt_sf_tot = sum(dUdt_sf);
 der(dU_sf) = dUdt_sf_tot;

 /************************** METAL WALL **************************************/
 for i in 1:N_cells loop
 dUdt_wall[i] = eva.metalWall.Aext_i*eva.metalWall.Wall_ext.phi[i] + eva.metalWall.Aint_i*eva.metalWall.Wall_int.phi[i];
 end for;
 dUdt_tot_wall = sum(dUdt_wall);
 der(dU_wall) = dUdt_tot_wall;
 der(E_inWall) = eva.metalWall.Q_tot_int;
 der(E_outWall) = eva.metalWall.Q_tot_ext;
 /***************************** WORKING FLUID ********************************/
 /* WF SYSTEM INLET */
  /* Mass at the inlet*/
  m_dot_su = eva.WorkingFluid.InFlow.m_flow;
  der(M_su) = m_dot_su;
  /* Total energy at the inlet */
  der(E_su) = eva.WorkingFluid.InFlow.h_outflow*eva.WorkingFluid.InFlow.m_flow;

 /* WF SYSTEM OUTLET */
  /*Mass at the outlet*/
  m_dot_ex = eva.WorkingFluid.OutFlow.m_flow;
  der(M_ex) = m_dot_ex;
  /* Total energy at the outlet */
  der(E_ex) = eva.WorkingFluid.OutFlow.h_outflow*eva.WorkingFluid.OutFlow.m_flow;

  /*WF ENERGY CHANGE IN THE SYSTEM*/
  for i in 1:N_cells loop
    dUdt[i] =  eva.WorkingFluid.Cells[i].M_dot_su*eva.WorkingFluid.Cells[i].hnode_su - eva.WorkingFluid.Cells[i].M_dot_ex*eva.WorkingFluid.Cells[i].hnode_ex + eva.WorkingFluid.Cells[i].Ai*eva.WorkingFluid.Cells[i].qdot;
    Q_[i] = eva.WorkingFluid.Cells[i].Ai*eva.WorkingFluid.Cells[i].qdot;
  end for;
  dUdt_tot = sum(dUdt);
  //!!!!!!!!!!!!!!!!!!!!!!!! STRANGE THING --> NOT EXPLAINED YET !!!!!!!!!!!!!!!!!
  //dUdt_tot_2 = E_dot_su_tot - E_dot_ex_tot + eva.WorkingFluid.Q_tot;
  //SomeHow the method used to calculate dUdt_tot_2 leads to a different results
  // compared to the one used to calculate dUdt_tot --> I am not able to explain why
  Q_tot_ = sum(Q_);
  /* Total energy accumulation in the system */
  der(dU) = dUdt_tot;

  /* WF TOTAL THERMAL ENERGY INTO THE SYSTEM */
 der(E_ext_tot) = eva.WorkingFluid.Q_tot;
  // //der(E_ext_tot_2) = Q_tot_;
  /*MASS CHANGE IN THE SYSTEM */
  dMdt_tot = sum(eva.WorkingFluid.Cells.dMdt);
  /* Mass accumulation in the system */
  der(dM) = dMdt_tot;

   /* Outlet variables value */
  h_outflow = eva.outletWf.h_outflow;
  T_outflow = sensTp.fluidState.T-273.15;
  m_outflow = eva.outletWf.m_flow;

  connect(sourceMdot.flangeB, eva.inletWf) annotation (Line(
      points={{-35,-22},{-14,-22},{-14,-20.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, eva.inletSf) annotation (Line(
      points={{33.8,1.9},{28,1.9},{28,-1.5},{22,-1.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boundaryEva.h, sourceMdot.in_h) annotation (Line(
      points={{-18.22,35.19},{-38,35.19},{-38,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundaryEva.p, sinkP.in_p0) annotation (Line(
      points={{30.18,40.89},{62,40.89},{62,-11.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.outletWf, sinkP.flangeB) annotation (Line(
      points={{22,-20.5},{40,-20.5},{40,-20},{57.6,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(
      StartTime=-400,
      StopTime=125,
      __Dymola_NumberOfIntervals=625),
    __Dymola_experimentSetupOutput);
end Test_evaFVSES36;
