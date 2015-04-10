within ThermoCycle.Components.FluidFlow.Pipes;
model Cell1Dim "1-D lumped fluid flow model (Real fluid model)"
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

/************ Thermal and fluid ports ***********/
 ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
 ThermoCycle.Interfaces.HeatTransfer.ThermalPortL Wall_int
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
    annotation (Dialog(enable=max_der, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
  parameter Boolean ComputeSat=false
    "Can be disabled if the flow is single-phase, or if saturation is passed as a parameter"
                                                                                             annotation (Dialog(tab="Numerical options"));
  //Medium.SaturationProperties  sat_in(ddldp=0,ddvdp=0,dhldp=0,dhvdp=0,dTp=0,hl=0,hv=1E5,sigma=0,sl=0,sv=0,dl=0,dv=0,psat=0,Tsat=300);
  Real[14] sat_in= {0,0,0,0,0,0,1E5,0,0,0,0,0,0,300};
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
 // Medium.ThermodynamicState State1;
  Medium.SaturationProperties sat;
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot_su(start=Mdotnom/Nt);
  Modelica.SIunits.MassFlowRate M_dot_ex(start=Mdotnom/Nt);
  Medium.SpecificEnthalpy h(start=hstart)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature T "Fluid temperature";
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
//   Modelica.SIunits.CoefficientOfHeatTransfer U
//     "Heat transfer coefficient between wall and working fluid";
  Real x "Vapor quality";
  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
equation
  //Saturation
  if ComputeSat then
    sat = Medium.setSat_p(p);
  else
    //sat = sat_in;
    sat.ddldp = sat_in[1];
    sat.ddvdp = sat_in[2];
    sat.dhldp = sat_in[3];
    sat.dhvdp = sat_in[4];
    sat.dTp = sat_in[5];
    sat.hl = sat_in[6];
    sat.hv = sat_in[7];
    sat.sigma = sat_in[8];
    sat.sl = sat_in[9];
    sat.sv = sat_in[10];
    sat.dl = sat_in[11];
    sat.dv = sat_in[12];
    sat.psat = sat_in[13];
    sat.Tsat = sat_in[14];
  end if;

  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
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

  x = (h - h_l)/(h_v - h_l);
  qdot = heatTransfer.q_dot[1];
  Q_tot = Ai*qdot;
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
  if (Discretization == Discretizations.centr_diff) then
    hnode_su = inStream(InFlow.h_outflow);
    hnode_ex = 2*h - hnode_su;
  elseif (Discretization == Discretizations.centr_diff_AllowFlowReversal) then
    if M_dot_su >= 0 and M_dot_ex >= 0 then       // Flow is going the right way
      hnode_su = inStream(InFlow.h_outflow);
      hnode_ex = 2*h - hnode_su;
    elseif M_dot_su <= 0 and M_dot_ex <= 0 then       // Reverse flow
      hnode_ex = inStream(OutFlow.h_outflow);
      hnode_su = 2*h - hnode_ex;
    elseif M_dot_su >= 0 and M_dot_ex <= 0 then        // Both flows entering the cell
      hnode_ex = inStream(OutFlow.h_outflow);
      hnode_su = inStream(InFlow.h_outflow);
    else                                         //  M_dot_su <= 0 and M_dot_ex >= 0 ; Both flows leaving the cell
      hnode_ex = h;
      hnode_su = h;
    end if;
  elseif (Discretization == Discretizations.upwind_AllowFlowReversal) then
    hnode_ex = if noEvent(M_dot_ex >= 0) then h else inStream(OutFlow.h_outflow);  ///
    hnode_su = if noEvent(M_dot_su <= 0) then h else inStream(InFlow.h_outflow);
  elseif (Discretization == Discretizations.upwind) then
    hnode_su = inStream(InFlow.h_outflow);
    hnode_ex = h;
  else                                           // Upwind scheme with smoothing
    hnode_ex = homotopy(inStream(OutFlow.h_outflow) + ThermoCycle.Functions.transition_factor(-Mdotnom/10,0,M_dot_ex,1) * (h - inStream(OutFlow.h_outflow)),h);
    hnode_su = homotopy(h + ThermoCycle.Functions.transition_factor(-Mdotnom/10,Mdotnom/10,M_dot_su,1) * (inStream(InFlow.h_outflow) - h), inStream(InFlow.h_outflow));
  end if;

//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
  InFlow.h_outflow = hnode_su;
  OutFlow.h_outflow = hnode_ex;

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
      points={{-2.2,2.6},{-2.2,28.3},{2,28.3},{2,50}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-88,24},{92,-20}},
          lineColor={0,0,255},
          textString="%Cell1D")}),Documentation(info="<HTML>
          
         <p><big>Model <b>Cell1Dim</b> describes the flow of fluid through a single cell. An overall flow model can be obtained by interconnecting several cells in series 
         (see <em><FONT COLOR=red><a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim\">Flow1Dim</a></FONT></em>).
         
          <p><big><b>Pressure</b> and <b>enthalpy</b> are selected as state variables. 
          <p><big>Two types of variables can be distinguished: cell variables and node variables. Node variables are characterized by the su (supply) and ex (exhaust) subscripts, and correspond to the inlet and outlet nodes at each cell. The relation between the cell and node values depends on the discretization scheme selected. 
 <p><big>The assumptions for this model are:
         <ul><li> Velocity is considered uniform on the cross section. 1-D lumped parameter model
         <li> The model is based on dynamic mass and energy balances and on a static momentum balance
         <li> Constant pressure is assumed in the cell
         <li> Axial thermal energy transfer is neglected
         <li> Thermal energy transfer through the lateral surface is ensured by the <em>wall_int</em> connector. The actual heat flow is computed by the thermal energy model
         </ul>

 <p><big>The model is characterized by two flow connector and one lumped thermal port connector. During normal operation the fluid enters the model from the <em>InFlow</em> connector and exits from the <em>OutFlow</em> connector. In case of flow reversal the fluid direction is inversed.
 <p><big> The thermal energy transfer  through the lateral surface is computed by the <em><a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer\">ConvectiveHeatTransfer</a></em> model which is inerithed in the <em>Cell1Dim</em> model. 
        
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
<li> Mdotconst: assume constant mass flow rate at each node.
<li> max_der: if true the density derivative is truncated during phase change
<li> filter_dMdt: if true a first order filter is applied to the fast variations of the density with respect to time
<li> max_drhodt: it represents the maximum value of the density derivative. It activates when using max_der is set to true
<li> TT: it represents the integration time of the first order filter. It activates when filter_dMdt is set to true
<li> ComputeSat: if false saturation properties are not computed in the fluid model and they can be passed as a parameter.
 </ul>
 <p><big> 
        </HTML>"));
end Cell1Dim;
