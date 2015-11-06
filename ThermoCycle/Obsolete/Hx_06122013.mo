within ThermoCycle.Obsolete;
model Hx_06122013 "Simplified heat exchanger model. Not object-oriented"
 //extends ThermoCycle.Components.Units.BaseUnits.BaseHxConst;

replaceable package Medium = ThermoCycle.Media.R245fa_CP
                                               constrainedby
    Modelica.Media.Interfaces.PartialMedium   annotation (choicesAllMatching = true);
  Interfaces.Fluid.Flange_Cdot inletSf
    annotation (Placement(transformation(extent={{88,40},{108,60}}),
        iconTransformation(extent={{90,40},{110,60}})));
  Interfaces.Fluid.Flange_ex_Cdot outletSf
    annotation (Placement(transformation(extent={{-106,40},{-86,60}}),
        iconTransformation(extent={{-110,40},{-90,60}})));
  Interfaces.Fluid.FlangeA inletWf( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}}),
        iconTransformation(extent={{-110,-60},{-90,-40}})));
  Interfaces.Fluid.FlangeB outletWf( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{86,-60},{106,-40}}),
        iconTransformation(extent={{90,-60},{110,-40}})));

// replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
//    Modelica.Media.Interfaces.PartialMedium "Medium model";
public
 record SummaryBase
   replaceable Arrays T_profile;
   record Arrays
    parameter Integer n;
    Modelica.SIunits.Temperature[n] Tsf;
    Modelica.SIunits.Temperature[n] Twall;
    Modelica.SIunits.Temperature[n] Twf;
   Real PinchPoint;
   end Arrays;
   Modelica.SIunits.Pressure p_wf;
   Modelica.SIunits.Power Q_sf;
   Modelica.SIunits.Power Q_wf;
 end SummaryBase;
 replaceable record SummaryClass = SummaryBase;
 SummaryClass Summary( T_profile( n=N, Tsf = T_sf, Twall = T_wall, Twf = T,PinchPoint = min(T_sf-T)),p_wf = p,Q_sf = A*sum(qdot_sf),Q_wf = A*sum(qdot_wf));
  // Heat exchanger geometric characteristics:
/* GEOMETRIES */
parameter Integer N=5 "Number of nodes for the heat exchanger";
parameter Modelica.SIunits.Volume V_sf= 0.03781 "Volume secondary fluid";
parameter Modelica.SIunits.Volume V_wf= 0.03781 "Volume primary fluid";
parameter Modelica.SIunits.Area A = 16.18 "Heat transfer area";
/*HEAT TRANSFER */
/*Secondary fluid*/
  import ThermoCycle.Functions.Enumerations.HT_sf;
parameter ThermoCycle.Functions.Enumerations.HT_sf HTtype_sf=HT_sf.Const
    "Secondary fluid: Choose heat transfer coeff" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_sf = 369
    "Coefficient of heat transfer, secondary fluid" annotation (Dialog(group="Heat transfer", tab="General"));
/*Working fluid*/
  import ThermoCycle.Functions.Enumerations.HTtypes;
parameter HTtypes HTtype_wf=HTtypes.LiqVap
    "Working fluid: Choose heat transfer coeff. type. Set LiqVap with Unom_l=Unom_tp=Unom_v to have a Const HT"
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=300
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=700
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=400
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
/*METAL WALL*/
parameter Modelica.SIunits.Mass M_wall= 69
    "Mass of the metal wall between the two fluids";
parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 500
    "Specific heat capacity of metal wall";
/*MASS FLOW*/
parameter Modelica.SIunits.MassFlowRate Mdotnom_sf= 3
    "Nominal flow rate of secondary fluid";
parameter Modelica.SIunits.MassFlowRate Mdotnom_wf= 0.2588
    "Nominal flow rate of working fluid";
/*INITIAL VALUES*/
  /*pressure*/
parameter Modelica.SIunits.Pressure pstart_wf= 23.57e5
    "Nominal inlet pressure of working fluid"  annotation (Dialog(tab="Initialization"));
/*Temperatures*/
parameter Modelica.SIunits.Temperature Tstart_inlet_wf = 334.9
    "Initial value of working fluid temperature at the inlet"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet_wf = 413.15
    "Initial value of working fluid temperature at the outlet"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_inlet_sf = 418.15
    "Initial value of secondary fluid temperature at the inlet"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet_sf = 408.45
    "Initial value of secondary fluid temperature at the outlet"  annotation (Dialog(tab="Initialization"));
/*steady state */
 parameter Boolean steadystate_T_sf=false
    "if true, sets the derivative of T_sf (secondary fluids Temperature in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
parameter Boolean steadystate_h_wf=false
    "if true, sets the derivative of h of primary fluid (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
parameter Boolean steadystate_T_wall=false
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Initialization options", tab="Initialization"));
//NUMERICAL OPTIONS //
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
/*Working fluid*/
  parameter Boolean Mdotconst_wf=false
    "Set to yes to assume constant mass flow rate of primary fluid at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der_wf=false
    "Set to yes to limit the density derivative of primary fluid during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt_wf=false
    "Set to yes to filter dMdt of primary fluid with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt_wf=100
    "Maximum value for the density derivative of primary fluid"
    annotation (Dialog(enable=max_der_wf, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT_wf=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt_wf, tab="Numerical options"));
 //Variables
  /* VARIABLES */
  /* SECONDARY FLUID */
  Modelica.SIunits.MassFlowRate M_dot_sf;
  Modelica.SIunits.SpecificHeatCapacity cp_sf;
  Modelica.SIunits.Temperature T_sf_su;
  Modelica.SIunits.Density rho_sf_su;
  Modelica.SIunits.Temperature T_sf[N](start=linspace(Tstart_outlet_sf,Tstart_inlet_sf,N))
    "Node temperatures";
  Modelica.SIunits.HeatFlux qdot_sf[N] "Average heat flux";
  Modelica.SIunits.Temperature Tnode_sf[N + 1];
  /*METAL WALL */
  Modelica.SIunits.Temperature T_wall[N](start=linspace(
          (Tstart_inlet_wf+Tstart_outlet_sf)/2,
          (Tstart_outlet_wf+Tstart_inlet_sf)/2,
          N)) "Cell temperatures";
    /* WORKING FLUID */
  Modelica.SIunits.MassFlowRate M_dot_su;
  /* Medium variables */
  Medium.ThermodynamicState fluidState[N];
  Medium.SaturationProperties sat;
  Medium.SpecificEnthalpy h[N](start=linspace(
        Medium.specificEnthalpy_pT(pstart_wf,Tstart_inlet_wf),Medium.specificEnthalpy_pT(pstart_wf,Tstart_outlet_wf),
        N)) "Fluid specific enthalpy at the nodes";
  Modelica.SIunits.Pressure p(start=pstart_wf);
  Medium.Temperature T[N](start=linspace(Tstart_inlet_wf,Tstart_outlet_wf,N))
    "Fluid temperature";
  Medium.Density rho[N] "Fluid cell density";
  Modelica.SIunits.DerDensityByEnthalpy drdh[N]
    "Derivative of density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp[N]
    "Derivative of density by pressure";
  Modelica.SIunits.SpecificEnthalpy hnode[N + 1] "Enthalpy state variables";
  Real dMdt[N] "Time derivative of mass in each cell between two nodes";
  Modelica.SIunits.HeatFlux qdot_wf[N] "Average heat flux";
  Modelica.SIunits.MassFlowRate Mdot[N + 1](each start=Mdotnom_wf, each min=0);
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
  Modelica.SIunits.Volume Vi_wf=V_wf/N;
  Modelica.SIunits.Area Ai=A/N;
  Modelica.SIunits.Volume Vi_sf= V_sf/N;
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
    if max_der_wf then
      drdp[j] = min(max_drhodt_wf/10^5,  Medium.density_derp_h(fluidState[j]));
      drdh[j] = max(max_drhodt_wf/(-4000), Medium.density_derh_p(fluidState[j]));
    else
      drdp[j] = Medium.density_derp_h(fluidState[j]);
      drdh[j] = Medium.density_derh_p(fluidState[j]);
    end if;
    Vi_wf*rho[j]*der(h[j]) + Mdot[j + 1]*(hnode[j + 1] - h[j]) - Mdot[j]*(hnode[
      j] - h[j]) - Vi_wf*der(p) = Ai*qdot_wf[j] "Energy balance";
    // Equation 4.8, richter's thesis
    if filter_dMdt_wf then
      der(dMdt[j]) = (Vi_wf*(drdh[j]*der(h[j]) + drdp[j]*der(p)) - dMdt[j])/TT_wf
        "Mass derivative for each volume";
    else
      dMdt[j] = Vi_wf*(drdh[j]*der(h[j]) + drdp[j]*der(p));
    end if;
    // node quantities
    if Mdotconst_wf then
      Mdot[j + 1] = Mdot[j];
    else
      dMdt[j] = -Mdot[j + 1] + Mdot[j];
    end if;
    if (Discretization == Discretizations.centr_diff) then
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
  if Mdotconst_wf then
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
  if steadystate_h_wf then
    der(h) = zeros(N);
  end if;
  if steadystate_T_wall then
    der(T_wall) = zeros(N);
  end if;
   if filter_dMdt_wf then
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
end Hx_06122013;
