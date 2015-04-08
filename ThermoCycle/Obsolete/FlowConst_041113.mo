within ThermoCycle.Obsolete;
model FlowConst_041113
  "1-D fluid flow model (finite volume discretization - ideal fluid model)"
  /* Select heat transfer coefficient */
  import ThermoCycle.Functions.Enumerations.HT_sf;
parameter HT_sf HTtype=HT_sf.Const "Select type of heat transfer coefficient";

/************ Thermal and fluid ports ***********/
  Interfaces.Fluid.Flange_Cdot flange_Cdot
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Interfaces.Fluid.Flange_ex_Cdot flange_ex_Cdot
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  Interfaces.HeatTransfer.ThermalPort Wall_int(N=N)
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));
/************ Geometric characteristics **************/
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Integer N(min=1) = 10 "Number of cells";
//   parameter Modelica.SIunits.Length L "Tube length";
//   parameter Modelica.SIunits.Length D_int "Tube internal diameter";
//   final parameter Modelica.SIunits.Area A_cross = D_int^2*pi/4
//     "Cross sectional area of the tube";
  parameter Modelica.SIunits.Area A= 16.18
    "Lateral surface of the tube: heat exchange area";
  parameter Modelica.SIunits.Volume V = 0.03781 "Volume of the tube";
  final parameter Modelica.SIunits.Volume Vi=V/N "Volume of a single cell";
  final parameter Modelica.SIunits.Area Ai=A/N
    "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom= 3
    "Norminal  fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer  Unom=500
    "Nominal heat transfer coefficient,secondary fluid";

 /************ FLUID INITIAL VALUES ***************/
  parameter Modelica.SIunits.Temperature Tstart_inlet = 145 + 273.15
    "Inlet temperature start value"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_outlet = 135 + 273.15
    "Outlet temperature start value"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart[N]=linspace(
        Tstart_inlet,
        Tstart_outlet,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
parameter Boolean steadystate_T=true
    "if true, sets the derivative of T to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));

/****************** NUMERICAL OPTIONS  ***********************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));

/***************  VARIABLES ******************/
  Modelica.SIunits.MassFlowRate Mdot;
  Modelica.SIunits.SpecificHeatCapacity cp;
  Modelica.SIunits.Temperature T_su;
  Modelica.SIunits.Density rho_su;
  Modelica.SIunits.Temperature T[N](start=Tstart) "Node temperatures";
  Modelica.SIunits.HeatFlux qdot[N] "Average heat flux";
  Modelica.SIunits.Temperature Tnode[N + 1];
  Modelica.SIunits.Temperature T_wall[N] "Internal wall temperature";
  Modelica.SIunits.CoefficientOfHeatTransfer U
    "Heat transfer coefficient,secondary fluid";
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass";

equation
  Tnode[1] = T_su;
  for j in 1:N loop
    qdot[j] = U*(T_wall[j] - T[j]);
     //Energy balance- There is no mass balance.
    Vi*cp*rho_su*der(T[j]) + Mdot*cp*(Tnode[j + 1] - Tnode[j]) = Ai*qdot[j];
    if (Discretization == Discretizations.centr_diff or Discretization ==
        Discretizations.centr_diff_robust or Discretization == Discretizations.centr_diff_AllowFlowReversal) then
      T[j] = (Tnode[j] + Tnode[j + 1])/2;
    else         // Upwind schemes
      Tnode[j + 1] = T[j];
      //!! Needs to be modified in case of flow reversal
    end if;
  end for;
 // Choose heat transfer coefficient
  if (HTtype == HT_sf.Const) then
    U = Unom;
  elseif (HTtype == HT_sf.MassFlowDependent) then
    U = ThermoCycle.Functions.U_sf(Unom=Unom, Mdot=Mdotnom/Mdotnom);
  end if;
Q_tot = Ai*sum(qdot) "Total heat flow through the thermal port";
M_tot = V * rho_su;
//* BOUNDARY CONDITIONS *//
/*Mass Flow*/
  Mdot = flange_Cdot.Mdot;
  flange_ex_Cdot.Mdot = Mdot;
/*Specific heat capacity */
  cp = flange_Cdot.cp;
  flange_ex_Cdot.cp = cp;
/*Temperatures */
  T_su = flange_Cdot.T;
  flange_ex_Cdot.T = Tnode[N+1];
/*Density*/
  rho_su = flange_Cdot.rho;
  flange_ex_Cdot.rho = rho_su;
  /* Thermal port boundary condition */
/*Temperatures */
 for j in 1:N loop
 Wall_int.T[j] = T_wall[j];
 end for;
 /*Heat flow */
 for j in 1:N loop
  Wall_int.phi[j] = qdot[j];
 end for;
initial equation
      if steadystate_T then
    der(T) = zeros(N);
      end if;
  annotation (Icon(graphics={Rectangle(extent={{-90,40},{90,-40}},
            lineColor={0,0,255})}), Diagram(graphics));
end FlowConst_041113;
