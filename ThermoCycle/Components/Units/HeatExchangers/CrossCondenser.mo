within ThermoCycle.Components.Units.HeatExchangers;
model CrossCondenser "Cross flow condenser model"

 replaceable package Medium1 =ThermoCycle.Media.Water  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid" annotation (choicesAllMatching=true);
 replaceable package Medium2 =
      Modelica.Media.Incompressible.Examples.Glycol47                         constrainedby
    Modelica.Media.Interfaces.PartialMedium "Secondary fluid" annotation (choicesAllMatching = true);

/*******************************************  COMPONENTS *****************************************************************/
ThermoCycle.Interfaces.Fluid.FlangeA InFlow_fl1(redeclare package Medium =        Medium1)
    annotation (Placement(transformation(extent={{10,60},{30,80}}),
        iconTransformation(extent={{10,60},{30,80}})));
ThermoCycle.Interfaces.Fluid.FlangeB OutFlow_fl1(redeclare package Medium =        Medium1)
    annotation (Placement(transformation(extent={{10,-80},{30,-60}}),
        iconTransformation(extent={{10,-80},{30,-60}})));

ThermoCycle.Interfaces.Fluid.FlangeA InFlow_fl2(redeclare package Medium =Medium2)
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}}),
        iconTransformation(extent={{-90,-60},{-70,-40}})));
ThermoCycle.Interfaces.Fluid.FlangeB OutFlow_fl2(redeclare package Medium=Medium2)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}}),
        iconTransformation(extent={{-90,40},{-70,60}})));

  ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc SecondaryFluid(
    A=A_sf,
    V=V_sf,
    Mdotnom=Mdotnom_sf,
    Tstart_inlet=Tstart_sf_in,
    Tstart_outlet=Tstart_sf_out,
    Discretization=Discretization_sf,
    steadystate=steadystate_sf,
    N=N,
    redeclare model Flow1DimIncHeatTransferModel = Medium2HeatTransferModel,
    redeclare package Medium = Medium2,
    Unom=Unom_sf,
    pstart=100000)
    annotation (Placement(transformation(extent={{-30,-72},{30,-12}})));
  ThermoCycle.Components.HeatFlow.Sources.Source_T source_T(N=N)
    annotation (Placement(transformation(extent={{50,64},{90,92}})));
  ThermoCycle.Components.HeatFlow.Walls.MetalWall metalWall(Aext=A_wf, Aint=
        A_sf,
    M_wall=M_wall_tot,
    c_wall=c_wall,
    steadystate_T_wall=steadystate_T_wall,
    Tstart_wall_1=T_start_wall,
    Tstart_wall_end=T_start_wall,
    N=N)      annotation (Placement(transformation(extent={{2,22},{66,-22}})));
 ThermoCycle.Components.HeatFlow.Walls.ThermalResistance ports1(
    N=N,
    A=A_wf,
    U=U_wf) annotation (Placement(transformation(extent={{32,18},{92,58}})));

//flow1DimInc
/*******************************************  PARAMETER *****************************************************************/
parameter Integer N(min=1) = 5 "Number of cells";

/*Geometry*/
parameter Modelica.SIunits.Area A_wf = 16.18
    "Heat exchange area of working fluid side";

parameter Modelica.SIunits.Area A_sf= 16.18
    "Heat exchange area of secondary fluid side";
parameter Modelica.SIunits.Volume V_sf= 0.0397 "Volume of secondary fluid";
parameter Modelica.SIunits.MassFlowRate Mdotnom_sf= 3
    "Nominal secondary fluid mass flow rate";

/*MetalWall parameter*/
parameter Modelica.SIunits.Mass M_wall_tot= 69 "Mass of the wall";
parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 500
    "Specific heat capacity of the metal wall";

/******************************** HEAT TRANSFER **************************************************/
/*Secondary fluid*/
replaceable model Medium2HeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Heat transfer model of secondary fluid"                                                                                                   annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_sf
    "Heat transfer coefficient of secondary fluid"                                                         annotation (Dialog(group="Heat transfer", tab="General"));

/*Working fluid*/
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_wf
    "Heat transfer coefficient of working fluid" annotation (Dialog(group="Heat transfer", tab="General"));
/************************************************* INITIALIZATION ********************************/

/* SecondaryFluid Initial values */
  parameter Medium2.Temperature Tstart_sf_in "Inlet temperature start value"
     annotation (Dialog(group="Secondary Fluid", tab="Initialization"));
  parameter Medium2.Temperature Tstart_sf_out "Outlet temperature start value" annotation (Dialog(group="Secondary Fluid",tab="Initialization"));

/* WorkingFluid Initial values */
  parameter Modelica.SIunits.Temperature T_sat_start
    "Saturation temperature start value"                                                  annotation(Dialog(group="Working Fluid",tab = "Initialization"));
  parameter Modelica.SIunits.Pressure p_sat_start = Medium1.saturationPressure(T_sat_start)
    "Saturation pressure start value"                                                                                                     annotation(Dialog(group="Working Fluid",tab = "Initialization"));
  parameter Medium1.SpecificEnthalpy h_su_wf_start = Medium1.dewEnthalpy(Medium1.setSat_T(T_sat_start))
    "Inlet enthalpy start value"
    annotation(Dialog(group="Working Fluid",tab = "Initialization"));
  parameter Medium1.SpecificEnthalpy h_ex_wf_start = Medium1.bubbleEnthalpy(Medium1.setSat_T(T_sat_start))
    "Outlet enthalpy start value"
    annotation(Dialog(group="Working Fluid",tab = "Initialization"));
  Medium1.SpecificEnthalpy h_su_wf(start=h_su_wf_start) "Inlet enthalpy";
  Medium1.SpecificEnthalpy h_ex_wf(start=h_ex_wf_start) "Outlet enthalpy";

/*Metal Wall*/
  parameter Modelica.SIunits.Temperature T_start_wall = (Tstart_sf_in + T_sat_start)/2
    "Wall's temperature start value"
    annotation (Dialog(group="Metal Wall",tab="Initialization"));

/* Initialization Options */
parameter Boolean steadystate_sf=true
    "if true, sets the derivative of h (secondary fluid's enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
parameter Boolean steadystate_T_wall=true
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Initialization options", tab="Initialization"));

/************************************************* VARIABLES ********************************/
  Modelica.SIunits.Power Qdot
    "Heat flux exchanged between the wall and the secondary fluid";
  Modelica.SIunits.Power Qdot_tot "Total Heat flux exchanged";
  Medium1.SaturationProperties satState
    "Saturation state for the working fluid";
  Medium1.BaseProperties stateIn(p(start=p_sat_start),h(start=h_su_wf_start));
  Medium1.BaseProperties stateOut(p(start=p_sat_start),h(start=h_ex_wf_start));

/*************************************** NUMERICAL OPTIONS    *****************************************************************/

/* Secondary Fluid */
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization_sf=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the discretization scheme for the secondary fluid"  annotation (Dialog(tab="Numerical options"));

equation
  /* Set saturation state */
  satState = Medium1.setSat_p(InFlow_fl1.p);
  source_T.Temperature = satState.Tsat;

  /* Mass balance */
  InFlow_fl1.m_flow = - OutFlow_fl1.m_flow;

  Qdot = sum(SecondaryFluid.Cells.qdot) / N * A_sf;
  Qdot_tot = ports1.Qdot_tot;

  /* Energy balance */
  h_ex_wf = h_su_wf - Qdot_tot/InFlow_fl1.m_flow;

  /* Momentum balance */
  InFlow_fl1.p = OutFlow_fl1.p;

  /* Define inlet and outlet state for the working fluid */
  stateIn.p = InFlow_fl1.p;
  stateIn.h = h_su_wf;
  stateOut.p = OutFlow_fl1.p;
  stateOut.h = h_ex_wf;

/* BOUNDARY CONDITIONS */
 InFlow_fl1.h_outflow=inStream(OutFlow_fl1.h_outflow);
  h_su_wf=inStream(InFlow_fl1.h_outflow);
  OutFlow_fl1.h_outflow=h_ex_wf;

  connect(InFlow_fl2, SecondaryFluid.InFlow) annotation (Line(
      points={{-80,-50},{-64,-50},{-64,-42},{-25,-42}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SecondaryFluid.OutFlow, OutFlow_fl2) annotation (Line(
      points={{25,-41.75},{76,-41.75},{76,-24},{-58,-24},{-58,50},{-80,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(metalWall.Wall_int, SecondaryFluid.Wall_int) annotation (Line(
      points={{34,-6.6},{34,-18},{0,-18},{0,-29.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(source_T.thermalPort, ports1.port1) annotation (Line(
      points={{69.8,72.26},{69.8,60},{62,60},{62,44}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ports1.port2, metalWall.Wall_ext) annotation (Line(
      points={{62,36},{62,20},{33.36,20},{33.36,6.6}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,40},{-54,-40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          lineThickness=0.5,
          radius=3),
        Rectangle(
          extent={{-60,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.HorizontalCylinder,
          lineThickness=0.5,
          radius=5),
        Line(
          points={{-80,-38},{-80,-22},{90,-22},{90,22},{-80,22},{-80,38},{
              -86,32},{-86,32}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{-80,38},{-74,32},{-74,32}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{20,56},{20,-54},{28,-44},{28,-44}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,-54},{12,-46},{12,-46}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(extent={{-80,14},{120,-12}},   textString="%name")}),Documentation(info="<HTML>
         
         <p><big>Model <b>CrossCondenser</b> represents a cross-flow condenser where the working fluid is in the shell side and the cooling fluid is in the tube side.
         
         <p><big>The assumptions for this model are:
         <ul><li> The working fluid is considered in thermodynamic equilibrium at all times, i.e. the vapor and the liquid are saturated at the condenser tamperature,
         which is considered uniform in the whole condenser
         <li> Static mass, energy and momentum balance are considered for the working fluid
         <li> Constant pressure is assumed in the working fluid
         <li> Energy accumulation in the metal wall is taken into account 
         <li> A constant thermal resistance is considered to model the heat transfer betweet the metal wall and the working fluid
         <li> The secondary fluid flow is represented by a discretized 1-dimensional straight tube
          <li> The secondary fluid is considered an incompressible fluid 
         </ul>

         <p><big> The model is based on the connection of four different sub-components:
         <ul><li> Flow1DimInc: the flow of the secondary fluid
         <li> MetalWall: the thermal energy accumulation in the metal wall
         <li>SourceT: an heat port to fix the saturation temperature of the working fluid
         <li> ThermalResistance: the thermal resistance between the metal wall and the working fluid
         </ul>
         
 <p><big>The model is characterized by four flow connectors and one realInput. During normal operation the working fluid enters the model from the <em>InFlow_fl1</em> connector and exits from the <em>OutFlow_fl1</em> connector
 and the secondary fluid enters the model from the  <em>InFlow_fl2</em> connector and exits from the  <em>OutFlow_fl2</em> connector. The realInput interface <em>source_T</em> is used to set the saturation state.  
       
        <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following options are available:
        <ul><li>Medium1: the user has the possibility to easly switch working fluid.
        <li>Medium2: the user has the possibility to easly switch secondary fluid.
        <li> HeatTransfer: the user can choose the thermal energy model he prefers for modeling the heat transfer between secondary fluid and metal wall </ul> 
        <p><big> In the <b>Initialization</b> tab the following options are available:
        <ul><li> steadystate_sf: If true, the derivative of enthalpy of the secondary fluid is set to zero during <em>Initialization</em> 
            <li> steadystate_T_wall: If true, the derivative of the temperature of the metal wall is set to zero during <em>Initialization</em> 
         </ul>
        <p><b><big>Numerical options</b></p>
<p><big> In this tab the following option is available:
<ul><li> Discretization: 2 main discretization options are available: UpWind and central difference method. The authors recommend the <em>UpWind Scheme - AllowsFlowReversal</em> in case flow reversal is expected.
 </ul>
 <p><big> 
        </HTML>"));
end CrossCondenser;
