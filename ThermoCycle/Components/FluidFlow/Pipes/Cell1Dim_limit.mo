within ThermoCycle.Components.FluidFlow.Pipes;
model Cell1Dim_limit
  "1-D fluid flow model (Real fluid model) with a limiter on the node enthalpies"
replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
//Modelica.Media.Interfaces.PartialTwoPhaseMedium
  import ThermoCycle.Functions.Enumerations.HTtypes;
  parameter HTtypes HTtype=HTtypes.LiqVap
    "Select type of heat transfer coefficient";
/* Thermal and fluid ports */
 ThermoCycle.Interfaces.Fluid.FlangeA_limit InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB_limit OutFlow(redeclare package Medium =
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
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone ";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp
    "if HTtype = LiqVap : heat transfer coefficient, two-phase zone";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v
    "if HTtype = LiqVap : heat transfer coefficient, vapor zone";
 /* FLUID INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
/* NUMERICAL OPTIONS  */
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean limit_hnode=true
    "Limits the node enthalpy to ensure more robustness"                                  annotation(Dialog(tab="Numerical options"));
  parameter Real yLimit(min=0,max=1)=0.9
    "Limiting factor. Defines how close to the singular system we can go. Should be set close to 1"
                                                                                                        annotation(Dialog(tab="Numerical options",enable=limit_hnode));
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
    annotation (Dialog(enable=max_der, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
  parameter Boolean steadystate=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Intialization options", tab="Initialization"));
/* FLUID VARIABLES */
  Medium.ThermodynamicState  fluidState;
  Medium.SaturationProperties sat;
  //Medium.Temperature T_sat "Saturation temperature";
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot_su(start=Mdotnom);
  Modelica.SIunits.MassFlowRate M_dot_ex(start=Mdotnom);
  Medium.SpecificEnthalpy h(start=hstart)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature T "Fluid temperature";
  Modelica.SIunits.Temperature T_wall "Internal wall temperature";
  Medium.Density rho "Fluid cell density";
  Modelica.SIunits.DerDensityByEnthalpy drdh
    "Derivative of density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp
    "Derivative of density by pressure";
  Modelica.SIunits.SpecificEnthalpy hnode_su(start=hstart)
    "Enthalpy state variable at inlet node";
  Modelica.SIunits.SpecificEnthalpy hnode_ex(start=hstart)
    "Enthalpy state variable at outlet node";
  Real dMdt "Time derivative of mass in cell";
  Modelica.SIunits.HeatFlux qdot "heat flux at each cell";
  Modelica.SIunits.CoefficientOfHeatTransfer U
    "Heat transfer coefficient between wall and working fluid";
  Real x "Vapor quality";
  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
equation
  //Saturation
  sat = Medium.setSat_p(p);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  //T_sat = Medium.temperature(sat);
  /* Fluid Properties */
  fluidState = Medium.setState_ph(p,h);
  T = Medium.temperature(fluidState);
  rho = Medium.density(fluidState);
  if max_der then
      drdp = min(max_drhodt/10^5, Medium.density_derp_h(fluidState));
      drdh = max(max_drhodt/(-4000), Medium.density_derh_p(fluidState));
  else
      drdp = Medium.density_derp_h(fluidState);
      drdh = Medium.density_derh_p(fluidState);
  end if;
  /* ENERGY BALANCE */
    Vi*rho*der(h) + M_dot_ex*(hnode_ex - h) - M_dot_su*(hnode_su - h) - Vi*der(p) = Ai*qdot
    "Energy balance";
  qdot = U*(T_wall - T);
  x = (h - h_l)/(h_v - h_l);
if (HTtype == HTtypes.MassFlowDependent) then
      U = ThermoCycle.Functions.U_sf(Unom=Unom_l, Mdot=M_dot_su/Mdotnom);
elseif (HTtype == HTtypes.LiqVap) then
      U = ThermoCycle.Functions.U_hx(
            Unom_l=Unom_l,
            Unom_tp=Unom_tp,
            Unom_v=Unom_v,
            x=x);
end if;
  /* MASS BALANCE */
  if filter_dMdt then
      der(dMdt) = (Vi*(drdh*der(h) + drdp*der(p)) - dMdt)/TT
      "Mass derivative for each volume";
       else
      dMdt = Vi*(drdh*der(h) + drdp*der(p));
   end if;
if Mdotconst then
      M_dot_ex = M_dot_su;
   else
      dMdt = -M_dot_ex + M_dot_su;
end if;

//     hnode_ex = if M_dot_ex >= 0 then h else inStream(OutFlow.h_outflow);
//     hnode_su = if M_dot_su <= 0 then h else inStream(InFlow.h_outflow);
hnode_ex = actualStream(OutFlow.h_outflow);
hnode_su = actualStream(InFlow.h_outflow);
if not limit_hnode then
    InFlow.h_outflow = h;
    OutFlow.h_outflow = h;
    InFlow.h_limit = -1E10;
    OutFlow.h_limit = -1E10;
else
    InFlow.h_outflow = noEvent(max(h,inStream(InFlow.h_limit)));
    OutFlow.h_outflow = noEvent(max(h,inStream(OutFlow.h_limit)));
    InFlow.h_limit = h + yLimit*rho/drdh;
    OutFlow.h_limit = InFlow.h_limit;
end if;

Q_tot = Ai*qdot "Total heat flow through the thermal port";
M_tot = Vi*rho;

/* pressures */
 p = OutFlow.p;
 InFlow.p = p;
/*Mass Flow*/
 M_dot_su = InFlow.m_flow;
 if Mdotconst then
   OutFlow.m_flow = - M_dot_su;
 else
   OutFlow.m_flow = -M_dot_ex;
 end if;
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
  if filter_dMdt then
    der(dMdt) = 0;
    end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Implementation of the Cell 1-D model with the limiter proposed in: </p>
<p>Schulze et al., A limiter for Preventing Singularity in Simplified Finite Volume Methods</p>
<p><br/>S. Quoilin, July 2013</p>
</html>"));
end Cell1Dim_limit;
