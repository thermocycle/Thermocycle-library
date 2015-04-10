within ThermoCycle.Components.FluidFlow.Pipes;
model Cell1DimInc "1-D incompressible fluid flow model"
replaceable package Medium = Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
    "Medium model - Incompressible Fluid" annotation (choicesAllMatching = true);
/************ Thermal and fluid ports ***********/
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
/************ Geometric characteristics **************/
  parameter Integer Nt(min=1)=1 "Number of cells in parallel";
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Modelica.SIunits.Volume Vi "Volume of a single cell";
  parameter Modelica.SIunits.Area Ai "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal Heat transfer coefficient ";
  /************ FLUID INITIAL VALUES ***************/
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
/****************** NUMERICAL OPTIONS  ***********************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
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
final Unom_l = Unom,
final Unom_tp = Unom,
final Unom_v = Unom,
final M_dot = M_dot,
final x = 0,
final FluidState={fluidState})
                          annotation (Placement(transformation(extent={{-12,-14},
            {8,6}})));
/***************  VARIABLES ******************/
  Medium.ThermodynamicState  fluidState;
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot(start=Mdotnom/Nt);
  Medium.SpecificEnthalpy h(start=hstart, stateSelect = StateSelect.always)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature T "Fluid temperature";
  //Modelica.SIunits.Temperature T_wall "Internal wall temperature";
  Medium.Density rho "Fluid cell density";
  Modelica.SIunits.SpecificEnthalpy hnode_su(start=hstart)
    "Enthalpy state variable at inlet node";
  Modelica.SIunits.SpecificEnthalpy hnode_ex(start=hstart)
    "Enthalpy state variable at outlet node";
  Modelica.SIunits.HeatFlux qdot "heat flux at each cell";
//   Modelica.SIunits.CoefficientOfHeatTransfer U
//     "Heat transfer coefficient between wall and working fluid";
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
/***********************************  EQUATIONS ************************************/
equation
  /* Fluid Properties */
  fluidState = Medium.setState_ph(p, h);
  T = Medium.temperature(fluidState);
  rho = Medium.density(fluidState);
  /* ENERGY BALANCE */
  Vi*rho*der(h) + M_dot*(hnode_ex - hnode_su) = Ai*qdot "Energy balance";
  Q_tot = Ai*qdot "Total heat flow through the thermal port";
  M_tot = Vi*rho;
qdot = heatTransfer.q_dot[1];
  if (Discretization == Discretizations.centr_diff) then
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
//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
  hnode_su = InFlow.h_outflow;
  OutFlow.h_outflow = hnode_ex;
/* pressures */
  p = OutFlow.p;
  InFlow.p = p;
/*Mass Flow*/
  M_dot = InFlow.m_flow/Nt;
  OutFlow.m_flow/Nt = -M_dot;
  InFlow.Xi_outflow = inStream(OutFlow.Xi_outflow);
  OutFlow.Xi_outflow = inStream(InFlow.Xi_outflow);
initial equation
  if steadystate then
    der(h) = 0;
      end if;

equation
  connect(heatTransfer.thermalPortL[1], Wall_int) annotation (Line(
      points={{-2.2,2.6},{-2.2,25.3},{2,25.3},{2,50}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid)}),Documentation(info="<HTML>
          
         <p><big>This model describes the flow of an incompressible fluid through a single cell. An overall flow model can be obtained by interconnecting several cells in series (see <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc\">Flow1DimInc</a>).
          <p><big><b>Enthalpy</b> is selected as state variable. 
          <p><big>Two types of variables can be distinguished: cell variables and node variables. Node variables are characterized by the su (supply) and ex (exhaust) subscripts, and correspond to the inlet and outlet nodes at each cell. The relation between the cell and node values depends on the discretization scheme selected. 
 <p><big>The assumptions for this model are:
         <ul><li> Velocity is considered uniform on the cross section. 1-D lumped parameter model
         <li> The model is based on dynamic energy balance and on a static  mass and  momentum balances
         <li> Constant pressure is assumed in the cell
         <li> Axial thermal energy transfer is neglected
         <li> Thermal energy transfer through the lateral surface is ensured by the <em>wall_int</em> connector. The actual heat flow is computed by the thermal energy model
         </ul>

 <p><big>The model is characterized by two flow connector and one lumped thermal port connector. During normal operation the fluid enters the model from the <em>InFlow</em> connector and exits from the <em>OutFlow</em> connector. In case of flow reversal the fluid direction is inversed.
 
 <p><big> The thermal energy transfer  through the lateral surface is computed by the <em><a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer\">ConvectiveHeatTransfer</a></em> model which is inerithed in the <em>Cell1DimInc</em> model.
 
        
        <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following options are available:
        <ul><li>Medium: the user has the possibility to easly switch Medium.
        <li> HeatTransfer: the user can choose the thermal energy model he prefers </ul> 
        <p><big> In the <b>Initialization</b> tab the following options are available:
        <ul><li> steadystate: If it sets to true, the derivative of enthalpy is sets to zero during <em>Initialization</em> 
         </ul>
        <p><b><big>Numerical options</b></p>
<p><big> In this tab several options are available to make the model more robust:
<ul><li> Discretization: 2 main discretization options are available: UpWind and central difference method. The authors recommend the <em>UpWind Scheme - AllowsFlowReversal</em> in case flow reversal is expected.
</ul>
 <p><big> 
        </HTML>"));
end Cell1DimInc;
