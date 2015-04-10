within ThermoCycle.Components.FluidFlow.Pipes;
model Cell1Dim_limit
  "1-D fluid flow model (Real fluid model) with a limiter on the node enthalpies"
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
/************ Thermal and fluid ports ***********/
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
/************ Geometric characteristics **************/
  parameter Integer Nt(min=1)=1 "Number of cells in parallel";
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
  /************ FLUID INITIAL VALUES ***************/
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
/****************** NUMERICAL OPTIONS  ***********************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal
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
    annotation (Dialog(group="Initialization options", tab="Initialization"));
/********************************* HEAT TRANSFER MODEL ********************************/
/* Heat transfer Model */
replaceable model HeatTransfer =
ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Convective heat transfer"                                                         annotation (choicesAllMatching = true);
HeatTransfer heatTransfer( redeclare final package Medium = Medium,
final n=1,
final Mdotnom = Mdotnom/Nt,
final Unom_l = Unom_l,
final Unom_tp = Unom_tp,
final Unom_v = Unom_v,
final M_dot = M_dot_su,
final x = x,
final FluidState={fluidState})
                          annotation (Placement(transformation(extent={{-12,-14},
            {8,6}})));
/***************  VARIABLES ******************/
  Medium.ThermodynamicState  fluidState;
  Medium.SaturationProperties sat;
  //Medium.Temperature T_sat "Saturation temperature";
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot_su(start=Mdotnom/Nt);
  Modelica.SIunits.MassFlowRate M_dot_ex(start=Mdotnom/Nt);
  Medium.SpecificEnthalpy h(start=hstart)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature T "Fluid temperature";
 // Modelica.SIunits.Temperature T_wall "Internal wall temperature";
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
//  qdot = U*(T_wall - T);
  x = (h - h_l)/(h_v - h_l);
Q_tot = Ai*qdot "Total heat flow through the thermal port";
qdot = heatTransfer.q_dot[1];
M_tot = Vi*rho;
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
  if (Discretization == Discretizations.centr_diff) then  //dummy values since this canno by used
    hnode_ex = 0;
    hnode_su = 0;
    assert(h>1E20,"Flow1dim with limiter cannot be used yet with the central differences discretization scheme");
  elseif (Discretization == Discretizations.centr_diff_AllowFlowReversal) then   //dummy values since this canno by used
    hnode_ex = 0;
    hnode_su = 0;
    assert(h>1E20,"Flow1dim with limiter cannot be used yet with the central differences discretization scheme");
  elseif (Discretization == Discretizations.upwind_AllowFlowReversal) then
    hnode_ex = actualStream(OutFlow.h_outflow);
    hnode_su = actualStream(InFlow.h_outflow);
  elseif (Discretization == Discretizations.upwind) then         //In this case upwind_AllowFlowReversal and upwind are actually identical
    hnode_ex = if M_dot_ex >= 0 then h else inStream(OutFlow.h_outflow);
    hnode_su = if M_dot_su <= 0 then h else inStream(InFlow.h_outflow);
  else                                           // Upwind scheme with smoothing
    hnode_ex = homotopy(inStream(OutFlow.h_outflow) + ThermoCycle.Functions.transition_factor(-Mdotnom/10,0,M_dot_ex,1) * (h - inStream(OutFlow.h_outflow)),h);
    hnode_su = homotopy(h + ThermoCycle.Functions.transition_factor(-Mdotnom/10,Mdotnom/10,M_dot_su,1) * (inStream(InFlow.h_outflow) - h), inStream(InFlow.h_outflow));
  end if;
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
/* pressures */
 p = OutFlow.p;
 InFlow.p = p;
/*Mass Flow*/
 M_dot_su = InFlow.m_flow/Nt;
 if Mdotconst then
   OutFlow.m_flow/Nt = - M_dot_su;
 else
   OutFlow.m_flow/Nt = -M_dot_ex;
 end if;
InFlow.Xi_outflow = inStream(OutFlow.Xi_outflow);
OutFlow.Xi_outflow = inStream(InFlow.Xi_outflow);
initial equation
  if steadystate then
    der(h) = 0;
      end if;
  if filter_dMdt then
    der(dMdt) = 0;
    end if;

equation
  connect(heatTransfer.thermalPortL[1], Wall_int) annotation (Line(
      points={{-2.2,2.6},{-2.2,23.3},{2,23.3},{2,50}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><big>Model <b>Cell1Dim_limit</b> represents the <em><FONT COLOR=red><a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Cell1D\">Cell1D</a></FONT></em> model with the limiter proposed in: </p>
<p>Schulze et al., A limiter for Preventing Singularity in Simplified Finite Volume Methods</p>. 
<p><big>An overall flow model can be obtained by interconnecting several cells in series 
         (see <em><FONT COLOR=red><a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim_limit\">Flow1Dim_limit</a></FONT></em>).
         
<p><b><big>Numerical options</b></p>
<p><big>Two more options are available with respecto to Cell1Dim model:
<ul><li>limit_hnode: if set to true, it limits the node enthalpy to ensure more robustness of the model
<li>ylimit: it is a security factor to ensure a minimum distance between the outlet enthalpy and the theoretical limit 
 </ul>

<p><br/>S. Quoilin, July 2013</p>


</html>"));
end Cell1Dim_limit;
