within ThermoCycle.Components.FluidFlow.Pipes;
model Cell1DimInc
  "1-D fluid incompressible flow model1-D fluid flow model (finite volume discretization - incompressible fluid model)"
replaceable package Medium = Media.Therminol66 constrainedby
    Modelica.Media.Interfaces.PartialMedium
    "Medium model - Incompressible Fluid" annotation (choicesAllMatching = true);
//* Select heat transfer coefficient */
  import ThermoCycle.Functions.Enumerations.HT_sf;
  parameter HT_sf HTtype=HT_sf.Const "Select type of heat transfer coefficient";
/* Thermal and fluid ports */
 ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
ThermoCycle.Interfaces.HeatTransfer.ThermalPortL  Wall_int
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));
// Geometric characteristics
  constant Real pi = Modelica.Constants.pi "pi-greco";

  parameter Modelica.SIunits.Volume Vi "Volume of a single cell";
  parameter Modelica.SIunits.Area Ai "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal Heat transfer coefficient ";
 /* FLUID INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
/* NUMERICAL OPTIONS  */
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean steadystate=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Intialization options", tab="Initialization"));
/* FLUID VARIABLES */
  Medium.ThermodynamicState  fluidState;
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot(start=Mdotnom);
  Medium.SpecificEnthalpy h(start=hstart, stateSelect = StateSelect.always)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature T "Fluid temperature";
  Modelica.SIunits.Temperature T_wall "Internal wall temperature";
  Medium.Density rho "Fluid cell density";
  Modelica.SIunits.SpecificEnthalpy hnode_su(start=hstart)
    "Enthalpy state variable at inlet node";
  Modelica.SIunits.SpecificEnthalpy hnode_ex(start=hstart)
    "Enthalpy state variable at outlet node";
  Modelica.SIunits.HeatFlux qdot "heat flux at each cell";
  Modelica.SIunits.CoefficientOfHeatTransfer U
    "Heat transfer coefficient between wall and working fluid";
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
equation
  /* Fluid Properties */
  fluidState = Medium.setState_ph(p, h);
  T = Medium.temperature(fluidState);
  rho = Medium.density(fluidState);
  /* ENERGY BALANCE */
  Vi*rho*der(h) + M_dot*(hnode_ex - hnode_su) = Ai*qdot "Energy balance";
  qdot = U*(T_wall - T);
  if (HTtype == HT_sf.Const) then
    U = Unom;
  elseif (HTtype == HT_sf.MassFlowDependent) then
    U = ThermoCycle.Functions.U_sf(Unom=Unom, Mdot=M_dot/Mdotnom);
  end if;
  if (Discretization == Discretizations.centr_diff) then
    hnode_su = inStream(InFlow.h_outflow);
    hnode_ex = 2*h - hnode_su;

  elseif (Discretization == Discretizations.centr_diff_robust) then     //no robustness method implemented for incompressible flow
    hnode_su = inStream(InFlow.h_outflow);
    hnode_ex = 2*h - hnode_su;

  elseif (Discretization == Discretizations.centr_diff_AllowFlowReversal) then
    if M_dot >= 0 then       // Flow is going the right way
      hnode_su = inStream(InFlow.h_outflow);
      hnode_ex = 2*h - hnode_su;
    else      // Reverse flow
      hnode_ex = inStream(OutFlow.h_outflow);
      hnode_su = 2*h - hnode_ex;
    end if;

  elseif (Discretization == Discretizations.upwind_AllowFlowReversal) then
    hnode_ex = if M_dot >= 0 then h else inStream(OutFlow.h_outflow);
    hnode_su = if M_dot <= 0 then h else inStream(InFlow.h_outflow);

  elseif (Discretization == Discretizations.upwind) then
    hnode_su = inStream(InFlow.h_outflow);
    hnode_ex = h;

  else                                           // Upwind scheme with smoothing (not implemented here)
    hnode_ex = if M_dot >= 0 then h else inStream(OutFlow.h_outflow);
    hnode_su = if M_dot <= 0 then h else inStream(InFlow.h_outflow);
  end if;

  Q_tot = Ai*qdot "Total heat flow through the thermal port";
  M_tot = Vi*rho;

//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
  hnode_su = InFlow.h_outflow;
  OutFlow.h_outflow = hnode_ex;
/* pressures */
  p = OutFlow.p;
  InFlow.p = p;
/*Mass Flow*/
  M_dot = InFlow.m_flow;
  OutFlow.m_flow = -M_dot;
  InFlow.Xi_outflow = inStream(OutFlow.Xi_outflow);
  OutFlow.Xi_outflow = inStream(InFlow.Xi_outflow);
  /* Thermal port boundary condition */
/*Temperatures */
  Wall_int.T = T_wall;
 /*Heat flow */
  Wall_int.phi = qdot;

initial equation
  if steadystate then
    der(h) = 0;
      end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid)}));
end Cell1DimInc;
