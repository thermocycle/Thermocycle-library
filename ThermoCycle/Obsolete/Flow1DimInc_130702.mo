within ThermoCycle.Obsolete;
model Flow1DimInc_130702
  "1-D fluid flow model (finite volume discretization - incompressible fluid model)"
replaceable package Medium =
      ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66                            constrainedby
    Modelica.Media.Interfaces.PartialMedium
    "Medium model - Incompressible Fluid" annotation (choicesAllMatching = true);
//* Select heat transfer coefficient */
  import ThermoCycle.Functions.Enumerations.HT_sf;
parameter HT_sf HTtype=HT_sf.Const "Select type of heat transfer coefficient";
/* Thermal and fluid ports */
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
  Interfaces.HeatTransfer.ThermalPort Wall_int(N=N)
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));
// Geometric characteristics
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Integer N(min=1)=2 "Number of cells";
  parameter Modelica.SIunits.Area A = 16.18
    "Lateral surface of the tube: heat exchange area";
  parameter Modelica.SIunits.Volume V = 0.03781 "Volume of the tube";
  final parameter Modelica.SIunits.Volume Vi=V/N "Volume of a single cell";
  final parameter Modelica.SIunits.Area Ai=A/N
    "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom = 0.02588
    "Nominal fluid flow rate";
   parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "if HTtype = Const: Heat transfer coefficient";
    parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value" annotation (Dialog(tab="Initialization"));
 /* FLUID INITIAL VALUES */
  parameter Medium.Temperature Tstart_inlet "Inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_outlet "Outlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart_inlet = Medium.specificEnthalpy_pTX(pstart,Tstart_inlet,fill(0,0))
    "Inlet temperature start value"
     annotation (Dialog(tab="Initialization"));  /*= Medium.specificEnthalpy_pTX*/
  parameter Medium.SpecificEnthalpy hstart_outlet =  Medium.specificEnthalpy_pTX(pstart,Tstart_outlet,fill(0,0))
    "Outlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart[N]=linspace(
        hstart_inlet,hstart_outlet,
        N) "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/* NUMERICAL OPTIONS  */
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean steadystate=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
/* FLUID VARIABLES */
  Medium.ThermodynamicState  fluidState[N];
  Modelica.SIunits.MassFlowRate M_dot_su;
  Modelica.SIunits.MassFlowRate Mdot(start=Mdotnom);
  Medium.SpecificEnthalpy h[N](start=hstart)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature T[N] "Fluid temperature";
  Modelica.SIunits.Temperature T_wall[N] "Internal wall temperature";
  Medium.Density rho[N] "Fluid cell density";
  Medium.SpecificHeatCapacity cp[N] "Fluid cell heat capacity";
  Modelica.SIunits.SpecificEnthalpy hnode[N + 1]
    "Enthalpy state variables at each node";
  Modelica.SIunits.HeatFlux qdot[N] "heat flux at each cell";
  Modelica.SIunits.CoefficientOfHeatTransfer U
    "Heat transfer coefficient between wall and working fluid";
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
equation
  Mdot = M_dot_su;
for j in 1:N loop
  /* Fluid Properties */
  fluidState[j] = Medium.setState_phX(InFlow.p,h[j],fill(0,0));
  T[j] = Medium.temperature(fluidState[j]);
  rho[j] = Medium.density(fluidState[j]);
  cp[j] = Medium.specificHeatCapacityCp(fluidState[j]);
  /* ENERGY BALANCE */
Vi*rho[j]*der(h[j]) + Mdot*(hnode[j + 1]  - hnode[j]) = Ai*qdot[j]
      "Energy balance";
  qdot[j] = U*(T_wall[j] - T[j]);
/* MASS BALANCE */
// Mdot[j + 1] = Mdot[j];
if (Discretization==Discretizations.centr_diff) then
      h[j] = (hnode[j] + hnode[j + 1])/2;
else
  hnode[j + 1] = h[j];
     //!! Needs to be modified in case of flow reversal
end if;
end for;
if (HTtype == HT_sf.Const) then
      U = Unom;
      elseif (HTtype == HT_sf.MassFlowDependent) then
       U = ThermoCycle.Functions.U_sf(
                          Unom=Unom, Mdot=Mdot/Mdotnom);
 end if;
Q_tot = Ai*sum(qdot) "Total heat flow through the thermal port";
M_tot = Vi*sum(rho);
//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
 inStream(InFlow.h_outflow) = hnode[1];
 hnode[1] = InFlow.h_outflow;
 OutFlow.h_outflow = hnode[N + 1];
/*Mass flow*/
 M_dot_su = InFlow.m_flow;
OutFlow.m_flow = - M_dot_su;
/* pressures */
 InFlow.p = OutFlow.p;
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
  if steadystate then
    der(h) = zeros(N);
      end if;
  annotation (Diagram(graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={170,85,255},
          fillPattern=FillPattern.Solid)}));
end Flow1DimInc_130702;
