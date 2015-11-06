within ThermoCycle.Components.Units.HeatExchangers;
model Hx1DConst_MD

replaceable package Medium1 = ThermoCycle.Media.DummyFluid
                                               constrainedby
    Modelica.Media.Interfaces.PartialMedium   annotation (choicesAllMatching = true);
  Interfaces.Fluid.Flange_Cdot inletSf
    annotation (Placement(transformation(extent={{88,40},{108,60}}),
        iconTransformation(extent={{90,40},{110,60}})));
  Interfaces.Fluid.Flange_ex_Cdot outletSf
    annotation (Placement(transformation(extent={{-106,40},{-86,60}}),
        iconTransformation(extent={{-110,40},{-90,60}})));
  Interfaces.Fluid.FlangeA inletWf( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}}),
        iconTransformation(extent={{-110,-60},{-90,-40}})));
  Interfaces.Fluid.FlangeB outletWf( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{86,-60},{106,-40}}),
        iconTransformation(extent={{90,-60},{110,-40}})));

/******************************* COMPONENTS ***********************************/
    // redeclare final model Flow1DimHeatTransferModel =
    //     Medium1HeatTransferModel,
  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim_MD
                                         WorkingFluid(
    redeclare package Medium = Medium1,
    N=N,
    Nt=Nt,
    A=A_wf,
    V=V_wf,
    pstart=pstart_wf,
    Mdotnom=Mdotnom_wf,
    U_nom= Unom_wf,
    steadystate=steadystate_h_wf,
    Mdotconst=Mdotconst_wf,
    max_der=max_der_wf,
    filter_dMdt=filter_dMdt_wf,
    max_drhodt=max_drhodt_wf,
    TT=TT_wf,
    Tstart_inlet=Tstart_inlet_wf,
    Tstart_outlet=Tstart_outlet_wf)
    annotation (Placement(transformation(extent={{-44,-124},{50,-36}})));
  Components.HeatFlow.Walls.MetalWall metalWall(M_wall=M_wall, c_wall=c_wall,
    Aext=A_wf,
    Aint=A_sf,
    N=N,
    Tstart_wall_1=(Tstart_inlet_wf + Tstart_outlet_sf)/2,
    Tstart_wall_end=(Tstart_outlet_wf + Tstart_inlet_sf)/2,
    steadystate_T_wall=steadystate_T_wall)
    annotation (Placement(transformation(extent={{-40,-50},{46,14}})));
  Components.HeatFlow.Walls.CountCurr countCurr(N=N,counterCurrent=counterCurrent)
  annotation (Placement(transformation(extent={{-42,3},{40,48}})));
 ThermoCycle.Components.FluidFlow.Pipes.Flow1DConst    SecondaryFluid(
   redeclare final model Flow1DConstHeatTransferModel =
        Medium2HeatTransferModel,
    N=N,
    Nt=Nt,
    A=A_sf,
    V=V_sf,
    Mdotnom=Mdotnom_sf,
    Unom=Unom_sf,
    Tstart_inlet=Tstart_inlet_sf,
    Tstart_outlet=Tstart_outlet_sf,
    steadystate=steadystate_T_sf,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{44,126},{-44,32}})));

/***************************** GEOMETRIES ***************************************************/
parameter Integer N(min=1)=5 "Number of nodes for the heat exchanger";
parameter Integer Nt(min=1)=1 "Number of tubes in parallel";
parameter Modelica.SIunits.Volume V_sf= 0.03781 "Volume secondary fluid";
parameter Modelica.SIunits.Volume V_wf= 0.03781 "Volume primary fluid";
parameter Modelica.SIunits.Area A_sf = 16.18 "Area secondary fluid";
parameter Modelica.SIunits.Area A_wf = 16.18 "Area primary fluid";

/****************************** HEAT TRANSFER *************************************/
parameter Boolean counterCurrent = true
    "Swap temperature and flux vector order";
/*Secondary fluid*/
replaceable model Medium2HeatTransferModel =
  ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence_IdealFluid
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones_IdealFluid
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_sf = 369
    "Coefficient of heat transfer, secondary fluid" annotation (Dialog(group="Heat transfer", tab="General"));

/*Working fluid*/

replaceable model Medium1HeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_wf=300
    "Coefficient of heat transfer, primary fluid" annotation (Dialog(group="Heat transfer", tab="General"));

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
protected
 Modelica.SIunits.Power Q_sf_;
 Modelica.SIunits.Power Q_wf_;
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
 SummaryClass Summary( T_profile( n=N, Tsf = SecondaryFluid.Cells[end:-1:1].T, Twall = metalWall.T_wall, Twf = WorkingFluid.Summary.T_profile.T_cell,PinchPoint = min(SecondaryFluid.Cells[end:-1:1].T-WorkingFluid.Summary.T_profile.T_cell)),p_wf = WorkingFluid.Summary.p,Q_sf = Q_sf_,Q_wf = Q_wf_);
equation
 /*Heat flow */
 Q_sf_ = -SecondaryFluid.Q_tot;
 Q_wf_ = WorkingFluid.Q_tot;
  connect(metalWall.Wall_ext, WorkingFluid.Wall_int)
                                                 annotation (Line(
      points={{2.14,-27.6},{2.14,-41.8},{3,-41.8},{3,-61.6667}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(SecondaryFluid.Wall_int, countCurr.side1)
                                               annotation (Line(
      points={{0,55.5},{0,32.25},{-1,32.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(SecondaryFluid.flange_ex_Cdot, outletSf)
                                              annotation (Line(
      points={{-44,79},{-74,79},{-74,50},{-96,50}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(inletSf, SecondaryFluid.flange_Cdot)
                                          annotation (Line(
      points={{98,50},{50,50},{50,79},{44,79}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(inletWf, WorkingFluid.InFlow)
                                    annotation (Line(
      points={{-90,-50},{-70,-50},{-70,-80},{-36.1667,-80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(WorkingFluid.OutFlow, outletWf)
                                      annotation (Line(
      points={{42.1667,-79.6333},{74,-79.6333},{74,-50},{96,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(countCurr.side2, metalWall.Wall_int) annotation (Line(
      points={{-1,18.75},{-1,5.375},{3,5.375},{3,-8.4}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-98,50},{-78,30},{-58,50},{-38,30},{-18,50},{2,30},{22,50},{
              42,30},{62,50},{82,30},{102,50}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-100,-50},{-78,-30},{-60,-50},{-40,-30},{-20,-50},{0,-30},{20,
              -50},{40,-30},{60,-50},{80,-30},{100,-50}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-22,-74},{30,-74}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Polygon(
          points={{26,-64},{26,-84},{40,-74},{26,-64}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,90},{-10,70},{-24,80},{-10,90}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{40,80},{-12,80}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5)}),
    Documentation(info="<html>
<p>Model <b>Hx1DConst</b> represent the model of a counter-current heat exchanger in which one of the two fluid is a constant heat capacity fluid. It is based on the connection of different sub-components: </p>
<p><ul>
<li>A Flow1Dim component representing the flow of the fluid in one side of the exchanger </li>
<li>A Flow1DConst component representing the flow of the fluid in the other side of the exchanger </li>
<li>A MetalWall component representing the thermal energy accumulation in the metal wall </li>
<li>A CountCurr component that enables the possibility of parallel or countercurrent flow </li>
</ul></p>
<p><b>Modelling options</b> </p>
<p>In the <b>Initialization</b> tab the following options are available: </p>
<p><ul>
<li>steadystate_T_sf: if true, the derivative of temperature of the constant heat capacity fluid is set to zero during <i>Initialization</i> </li>
<li>steadystate_h_wf: if true, the derivative of enthalpy of the working fluid is set to zero during <i>Initialization</i> </li>
<li>steadystate_T_wall: if true, the derivative of temperature of the metal wall is set to zero during <i>Initialization</i> </li>
</ul></p>
<p><b>Numerical options</b></p>
<p>The numerical options available for the <b>HxRec1DConst</b> are the one implemented in <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Cell1Dim\">Cell1Dim</a> and <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.CellConst\">CellConst</a>. </p>
</html>"));
end Hx1DConst_MD;
