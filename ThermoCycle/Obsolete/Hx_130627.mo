within ThermoCycle.Obsolete;
model Hx_130627
  "Simplified heat exchanger model, useful for the ORCNext project"
 extends ThermoCycle.Components.Units.BaseUnits.BaseHxConst;
 replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model";
  // Heat exchanger geometric characteristics:
  parameter Integer N(min=1) = 5 "Number of cells";
  parameter Modelica.SIunits.Area A=16.18 "Heat exchange area";
  parameter Modelica.SIunits.Volume V=0.03781
    "Heat exchanger internal volume, working fluid side";
  parameter Modelica.SIunits.Volume V_sf=0.03781
    "Total Internal volume, hot side [m3]";
  final parameter Modelica.SIunits.Volume Vi=V/N
    "Internal volume for each cell, cold side [m3]";
  final parameter Modelica.SIunits.Area Ai=A/N;
  final parameter Modelica.SIunits.Volume Vi_sf= V_sf/N;
  /* Select type of heat transfer*/
  import ThermoCycle.Functions.Enumerations.HTtypes;
  parameter HTtypes HTtype=HTtypes.LiqVap
    "Select type of heat transfer coefficient";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=300
    "Constant heat transfer coefficient, liquid zone";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=700
    "Constant heat transfer coefficient, two-phase zone";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=400
    "Constant heat transfer coefficient, vapor zone";
  import ThermoCycle.Functions.Enumerations.HT_sf;
parameter HT_sf HTtype_sf=HT_sf.Const
    "Select type of heat transfer coefficient";
 parameter Modelica.SIunits.CoefficientOfHeatTransfer  Unom_sf=369
    "Nominal heat transfer coefficient,secondary fluid";
    // Secondary fluid initial values:
  parameter Modelica.SIunits.MassFlowRate Mdotnom_sf = 3
    "Norminal secondary fluid flow rate";
  parameter Modelica.SIunits.Temperature Tstart_sf_left=408.45
    "Secondary fluid temperature start value - first node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_sf_right=418.15
    "Secondary fluid temperature start value - last node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_sf[N]=linspace(
        Tstart_sf_left,
        Tstart_sf_right,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
  // Wall Temperatures initial values:
  parameter Modelica.SIunits.Mass M_wall=69 "Wall mass";
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall=500
    "Specific heat capacity of the metal";
  parameter Modelica.SIunits.Temperature Tstart_wall_left=( Tstart_wf_left+Tstart_sf_right)/2
    "Wall temperature start value - first node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wall_right=( Tstart_wf_right+Tstart_sf_left)/2
    "Wall temperature start value - last node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wall[N]=linspace(
        Tstart_wall_left,
        Tstart_wall_right,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
  // Working fluid initial values:
  parameter Modelica.SIunits.MassFlowRate Mdotnom=0.2588
    "Nominal working fluid flow rate";
  parameter Modelica.SIunits.Pressure pstart=23.57e5
    "Working fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.SpecificEnthalpy hstart_left=283000
    "Inlet working fluid enthalpy start value"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.SpecificEnthalpy hstart_right=505000
    "Outlet enthalpy start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wf_left=334.9
    "Working fluid temperature start value - first node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wf_right=413.15
    "Working fluid temperature start value - last node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wf[N]=linspace(
        Tstart_wf_left,
        Tstart_wf_right,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.SpecificEnthalpy hstart[N]=linspace(
        hstart_left,
        hstart_right,
        N) "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/* Parameters for Numerical Options */
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate at each node (easier convergence)"
    annotation (Dialog(group="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative during phase transitions"
    annotation (Dialog(group="Numerical options"));
  parameter Boolean average_Tcell=true
    "Set to yes to impose the cell enthalpy as the average of the surrounding nodes enthalpies"
    annotation (Dialog(group="Numerical options"));
   parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt with a first-order filter"
     annotation (Dialog(group="Numerical options"));
//
   parameter Real max_drhodt=100 "Maximum value for the density derivative"
     annotation (Dialog(enable=max_der, group="Numerical options"));
   parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
     annotation (Dialog(enable=filter_dMdt, group="Numerical options"));
  parameter Boolean steadystate_T_sf=true
    "if true, sets the derivative of T_sf to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
  parameter Boolean steadystate_h=true
    "if true, sets the derivative of h (working fluid enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
  parameter Boolean steadystate_T_wall=true
    "if true, sets the derivative of T_wall to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
  /* VARIABLES */
  /* SECONDARY FLUID */
  Modelica.SIunits.MassFlowRate M_dot_sf;
  Modelica.SIunits.SpecificHeatCapacity cp_sf;
  Modelica.SIunits.Temperature T_sf_su;
  Modelica.SIunits.Density rho_sf_su;
  Modelica.SIunits.Temperature T_sf[N](start=Tstart_sf) "Node temperatures";
  Modelica.SIunits.HeatFlux qdot_sf[N] "Average heat flux";
  Modelica.SIunits.Temperature Tnode_sf[N + 1];
  /*METAL WALL */
  Modelica.SIunits.Temperature T_wall[N](start=linspace(
          Tstart_wall_left,
          Tstart_wall_right,
          N)) "Cell temperatures";
    /* WORKING FLUID */
  Modelica.SIunits.MassFlowRate M_dot_su;
  /* Medium variables */
  Medium.ThermodynamicState fluidState[N];
  Medium.SaturationProperties sat;
  Medium.SpecificEnthalpy h[N](start=linspace(
          hstart_left,
          hstart_right,
          N)) "Fluid specific enthalpy at the nodes";
  Modelica.SIunits.Pressure p(start=pstart);
  Medium.Temperature T[N](start=Tstart_wf) "Fluid temperature";
  Medium.Density rho[N] "Fluid cell density";
  Modelica.SIunits.DerDensityByEnthalpy drdh[N]
    "Derivative of density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp[N]
    "Derivative of density by pressure";
  Modelica.SIunits.SpecificEnthalpy hnode[N + 1] "Enthalpy state variables";
  Real dMdt[N] "Time derivative of mass in each cell between two nodes";
  Modelica.SIunits.HeatFlux qdot_wf[N] "Average heat flux";
  Modelica.SIunits.MassFlowRate Mdot[N + 1](each start=Mdotnom, each min=0);
  //HEAT TRANSFER
  // Heat transfer variables:
  Modelica.SIunits.CoefficientOfHeatTransfer U_wf[N]
    "Heat transfer coefficient between wall and working fluid";
   Modelica.SIunits.CoefficientOfHeatTransfer U_sf
    "Heat transfer coefficient,secondary fluid";
    //
  Real x[N] "Vapor quality";
  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
equation
  Tnode_sf[N + 1] = T_sf_su;
  //Cold fluid properties
  //Saturation
  sat = Medium.setSat_p(p);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  for j in 1:N loop
    //loop for each cell
    fluidState[j] = Medium.setState_ph(p,h[j]);
    T[j] = Medium.temperature(fluidState[j]);
    rho[j] = Medium.density(fluidState[j]);
    if max_der then
    //  drdp[j] = min(max_drhodt/10^5, refrigerant[j].drhodp);  // This correlation do not allow to simulate the ORCNextCycle
    //   drdh[j] = max(max_drhodt/(-4000), refrigerant[j].drhodh);
      drdp[j] = min(0.01,  Medium.density_derp_h(fluidState[j]));
      drdh[j] = max(-0.01, Medium.density_derh_p(fluidState[j]));
    else
      drdp[j] = Medium.density_derp_h(fluidState[j]);
      drdh[j] = Medium.density_derh_p(fluidState[j]);
    end if;
    Vi*rho[j]*der(h[j]) + Mdot[j + 1]*(hnode[j + 1] - h[j]) - Mdot[j]*(hnode[
      j] - h[j]) - Vi*der(p) = Ai*qdot_wf[j] "Energy balance";
    // Equation 4.8, richter's thesis
    if filter_dMdt then
      der(dMdt[j]) = (Vi*(drdh[j]*der(h[j]) + drdp[j]*der(p)) - dMdt[j])/TT
        "Mass derivative for each volume";
    else
      dMdt[j] = Vi*(drdh[j]*der(h[j]) + drdp[j]*der(p));
    end if;
    // node quantities
    if Mdotconst then
      Mdot[j + 1] = Mdot[j];
    else
      dMdt[j] = -Mdot[j + 1] + Mdot[j];
    end if;
    if average_Tcell then
      h[j] = (hnode[j] + hnode[j + 1])/2;
      T_sf[j] = (Tnode_sf[j] + Tnode_sf[j + 1])/2;
    else
      hnode[j + 1] = h[j];
      //!! Needs to be modified in case of flow reversal
      Tnode_sf[j] = T_sf[j];
      //!! Needs to be modified in case of flow reversal
    end if;
    M_wall/(N)*der(T_wall[j])*c_wall = Ai*(qdot_sf[j] - qdot_wf[j])
      "Metal wall energy balance";
    qdot_wf[j] = U_wf[j]*(T_wall[j] - T[j]);
    qdot_sf[j] = U_sf*(T_sf[j] - T_wall[j]);
    //Energy balance secondary fluid. There is no mass balance.
    Vi_sf*cp_sf*rho_sf_su*der(T_sf[j]) = M_dot_sf*cp_sf*(Tnode_sf[j + 1] -
      Tnode_sf[j]) - Ai*qdot_sf[j];
    x[j] = (h[j] - h_l)/(h_v - h_l);
    U_wf[j] = ThermoCycle.Functions.U_hx(
          Unom_l=Unom_l,
          Unom_tp=Unom_tp,
          Unom_v=Unom_v,
          x=x[j]);
        //Mdot=1, It is not used in the functions.U_hx
  end for;
/* Heat transfer secondary fluid */
      if (HTtype_sf == HT_sf.Const) then
      U_sf = Unom_sf;
      elseif (HTtype_sf == HT_sf.MassFlowDependent) then
    U_sf = ThermoCycle.Functions.U_sf(Unom=Unom_sf, Mdot=Mdotnom_sf/
      Mdotnom_sf);
 end if;
  /* BOUNDARY CONDITION */
  /*Enthalpies */
  hnode[1] = inletWf.h_outflow;
  outletWf.h_outflow = hnode[N + 1];
  inStream(inletWf.h_outflow) = hnode[1];
  /*Mass flow Rate */
  M_dot_sf = inletSf.Mdot;
  outletSf.Mdot = M_dot_sf;
  M_dot_su = inletWf.m_flow;
  Mdot[1] = M_dot_su;
  if Mdotconst then
    outletWf.m_flow = -M_dot_su + sum(dMdt);
  else
    outletWf.m_flow = -Mdot[N + 1];
  end if;
  /*pressure */
  inletWf.p = p;
  p = outletWf.p;
  /*Specific heat capacity */
  cp_sf = inletSf.cp;
  outletSf.cp = cp_sf;
  /*Temperatures */
  T_sf_su = inletSf.T;
  outletSf.T = Tnode_sf[1];
  /*Density*/
  rho_sf_su = inletSf.rho;
  outletSf.rho = rho_sf_su;
initial equation
  if steadystate_T_sf then
    der(T_sf) = zeros(N);
  end if;
  if steadystate_h then
    der(h) = zeros(N);
  end if;
  if steadystate_T_wall then
    der(T_wall) = zeros(N);
  end if;
   if filter_dMdt then
     der(dMdt) = zeros(N);
   end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-100,46},{-80,66},{-60,46},{-40,66},{-20,46},{0,66},{20,46},
              {40,66},{60,46},{80,66},{100,46}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(extent={{-100,-66},{100,-100}}, textString="%name"),
        Line(
          points={{-100,-44},{-80,-24},{-60,-44},{-40,-24},{-20,-44},{0,-24},{20,
              -44},{40,-24},{60,-44},{80,-24},{100,-44}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5)}),                                         Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics));
end Hx_130627;
