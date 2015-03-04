within ThermoCycle.Obsolete;
model Flow1Dim_130627
  "1-D fluid flow model (finite volume discretization - real fluid model)"
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
//Modelica.Media.Interfaces.PartialTwoPhaseMedium
  import ThermoCycle.Functions.Enumerations.HTtypes;
  parameter HTtypes HTtype=HTtypes.LiqVap
    "Select type of heat transfer coefficient";
/* Thermal and fluid ports */
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort Wall_int(N=N)
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));
// Geometric characteristics
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Integer N(min=1)=10 "Number of cells";
//   parameter Modelica.SIunits.Length L "Tube length";
//   parameter Modelica.SIunits.Length D_int "Tube internal diameter";
//   final parameter Modelica.SIunits.Area A_cross = D_int^2*pi/4
//     "Cross sectional area of the tube";
  parameter Modelica.SIunits.Area A = 16.18
    "Lateral surface of the tube: heat exchange area";
  parameter Modelica.SIunits.Volume V = 0.03781 "Volume of the tube";
  final parameter Modelica.SIunits.Volume Vi=V/N "Volume of a single cell";
  final parameter Modelica.SIunits.Area Ai=A/N
    "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom = 0.2588
    "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l = 100
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone ";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp = 100
    "if HTtype = LiqVap : heat transfer coefficient, two-phase zone";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v = 100
    "if HTtype = LiqVap : heat transfer coefficient, vapor zone";
 /* FLUID INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_inlet "Inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_outlet "Outlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart[N]=linspace(
        Medium.specificEnthalpy_pT(pstart,Tstart_inlet),Medium.specificEnthalpy_pT(pstart,Tstart_outlet),
        N) "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/* NUMERICAL OPTIONS  */
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt=100 "Maximum value for the density derivative"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=max_der, tab="Numerical options"));
//enable=filter_dMdt,enable=max_der,
  parameter Boolean steadystate=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
/* FLUID VARIABLES */
  Medium.ThermodynamicState  fluidState[N];
  Medium.SaturationProperties sat;
  //Medium.Temperature T_sat "Saturation temperature";
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot_su;
  Medium.SpecificEnthalpy h[N](start=hstart)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature T[N];//(start=Tstart) "Fluid temperature";
  Modelica.SIunits.Temperature T_wall[N] "Internal wall temperature";
  Medium.Density rho[N] "Fluid cell density";
  Modelica.SIunits.DerDensityByEnthalpy drdh[N]
    "Derivative of density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp[N]
    "Derivative of density by pressure";
  Modelica.SIunits.SpecificEnthalpy hnode[N + 1]
    "Enthalpy state variables at each node";
  Real dMdt[N] "Time derivative of mass in each cell between two nodes";
  Modelica.SIunits.HeatFlux qdot[N] "heat flux at each cell";
  Modelica.SIunits.MassFlowRate Mdot[N + 1](each start=Mdotnom, each min=0);
  Modelica.SIunits.CoefficientOfHeatTransfer U[N]
    "Heat transfer coefficient between wall and working fluid";
  Real x[N] "Vapor quality";
  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
equation
  Mdot[1] = M_dot_su;
  //Saturation
  sat = Medium.setSat_p(p);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  //T_sat = Medium.temperature(sat);
for j in 1:N loop
  /* Fluid Properties */
  fluidState[j] = Medium.setState_ph(p,h[j]);
  T[j] = Medium.temperature(fluidState[j]);
  rho[j] = Medium.density(fluidState[j]);
  if max_der then
      drdp[j] = min(max_drhodt/10^5, Medium.density_derp_h(fluidState[j]));
      drdh[j] = max(max_drhodt/(-4000), Medium.density_derh_p(fluidState[j]));
  else
      drdp[j] = Medium.density_derp_h(fluidState[j]);
      drdh[j] = Medium.density_derh_p(fluidState[j]);
  end if;
  /* ENERGY BALANCE */
    Vi*rho[j]*der(h[j]) + Mdot[j + 1]*(hnode[j + 1] - h[j]) - Mdot[j]*(hnode[j] - h[j]) - Vi*der(p) = Ai*qdot[j]
      "Energy balance";
  qdot[j] = U[j]*(T_wall[j] - T[j]);
  x[j] = (h[j] - h_l)/(h_v - h_l);
if (HTtype == HTtypes.MassFlowDependent) then
      U[j] = ThermoCycle.Functions.U_sf(Unom=Unom_l, Mdot=Mdot[j]/Mdotnom);
elseif (HTtype == HTtypes.LiqVap) then
      U[j] = ThermoCycle.Functions.U_hx(
            Unom_l=Unom_l,
            Unom_tp=Unom_tp,
            Unom_v=Unom_v,
            x=x[j]);
end if;
  /* MASS BALANCE */
  if filter_dMdt then
      der(dMdt[j]) = (Vi*(drdh[j]*der(h[j]) + drdp[j]*der(p)) - dMdt[j])/TT
        "Mass derivative for each volume";
       else
      dMdt[j] = Vi*(drdh[j]*der(h[j]) + drdp[j]*der(p));
   end if;
if Mdotconst then
      Mdot[j + 1] = Mdot[j];
   else
      dMdt[j] = -Mdot[j + 1] + Mdot[j];
end if;
if (Discretization==Discretizations.centr_diff) then
      h[j] = (hnode[j] + hnode[j + 1])/2;
else
  hnode[j + 1] = h[j];
     //!! Needs to be modified in case of flow reversal
end if;
end for;
Q_tot = Ai*sum(qdot) "Total heat flow through the thermal port";
M_tot = Vi*sum(rho);
//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
 inStream(InFlow.h_outflow) = hnode[1];
 hnode[1] = InFlow.h_outflow;
 OutFlow.h_outflow = hnode[N + 1];
/* pressures */
 p = OutFlow.p;
 InFlow.p = p;
/*Mass Flow*/
 M_dot_su = InFlow.m_flow;
 if Mdotconst then
   OutFlow.m_flow = - M_dot_su + sum(dMdt);
 else
   OutFlow.m_flow = -Mdot[N+1];
 end if;
// InFlow.Xi_outflow = inStream(OutFlow.Xi_outflow);
// OutFlow.Xi_outflow = inStream(InFlow.Xi_outflow);
  /* Thermal port boundary condition */
/*Temperatures */
 for j in 1:N loop
 Wall_int.T[j] = T_wall[j];
 end for;
 /*Heat flow */
 for j in 1:N loop
  Wall_int.phi[j] = qdot[j];
 end for;
/*Heat transfer coefficient */
//   for j in 1:N loop
//   Wall_int.gamma[j] = Unom;
//   end for;
initial equation
  if steadystate then
    der(h) = zeros(N);
      end if;
  if filter_dMdt then
    der(dMdt) = zeros(N);
    end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{
            -120,-120},{120,120}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
                  extent={{-120,-120},{120,120}}),
                                      graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid)}));
end Flow1Dim_130627;
