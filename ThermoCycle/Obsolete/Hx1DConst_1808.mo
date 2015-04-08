within ThermoCycle.Obsolete;
model Hx1DConst_1808
extends Components.Units.BaseUnits.BaseHxConst;
 ThermoCycle.Obsolete.Flow1Dim_1808  WorkingFluid(
    redeclare package Medium = Medium1,
    N=N,
    A=A_wf,
    V=V_wf,
    pstart=pstart_wf,
    Mdotnom=Mdotnom_wf,
    Unom_l=Unom_l,
    Unom_tp=Unom_tp,
    HTtype=HTtype_wf,
    Unom_v=Unom_v,
    steadystate=steadystate_h_wf,
    Mdotconst=Mdotconst_wf,
    max_der=max_der_wf,
    filter_dMdt=filter_dMdt_wf,
    max_drhodt=max_drhodt_wf,
    TT=TT_wf,
    Tstart_inlet=Tstart_inlet_wf,
    Tstart_outlet=Tstart_outlet_wf,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{-44,-124},{50,-36}})));
  Components.HeatFlow.Walls.MetalWall metalWall(M_wall=M_wall, c_wall=c_wall,
    Aext=A_wf,
    Aint=A_sf,
    N=N,
    Tstart_wall_1=(Tstart_inlet_wf + Tstart_outlet_sf)/2,
    Tstart_wall_end=(Tstart_outlet_wf + Tstart_inlet_sf)/2,
    steadystate_T_wall=steadystate_T_wall)
    annotation (Placement(transformation(extent={{-40,-50},{46,14}})));
  Components.HeatFlow.Walls.CountCurr countCurr(N=N)
  annotation (Placement(transformation(extent={{-42,3},{40,48}})));
 ThermoCycle.Obsolete.FlowConst_041113  SecondaryFluid(
    N=N,
    A=A_sf,
    V=V_sf,
    Mdotnom=Mdotnom_sf,
    Unom=Unom_sf,
    Tstart_inlet=Tstart_inlet_sf,
    Tstart_outlet=Tstart_outlet_sf,
    steadystate_T=steadystate_T_sf,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{44,126},{-44,32}})));
/* GEOMETRIES */
parameter Integer N=5 "Number of nodes for the heat exchanger";
parameter Modelica.SIunits.Volume V_sf= 0.03781 "Volume secondary fluid";
parameter Modelica.SIunits.Volume V_wf= 0.03781 "Volume primary fluid";
parameter Modelica.SIunits.Area A_sf = 16.18 "Area secondary fluid";
parameter Modelica.SIunits.Area A_wf = 16.18 "Area primary fluid";
/*HEAT TRANSFER */
/*Secondary fluid*/
  import ThermoCycle.Functions.Enumerations.HT_sf;
parameter ThermoCycle.Functions.Enumerations.HT_sf HTtype_sf=HT_sf.Const
    "Secondary fluid: Choose heat transfer coeff" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_sf = 369
    "Coefficient of heat transfer, secondary fluid" annotation (Dialog(group="Heat transfer", tab="General"));
/*Working fluid*/
  import ThermoCycle.Functions.Enumerations.HTtypes;
parameter HTtypes HTtype_wf=HTtypes.LiqVap
    "Working fluid: Choose heat transfer coeff. type. Set LiqVap with Unom_l=Unom_tp=Unom_v to have a Const HT"
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=300
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=700
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=400
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
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
 SummaryClass Summary( T_profile( n=N, Tsf = SecondaryFluid.T[end:-1:1], Twall = metalWall.T_wall, Twf = WorkingFluid.Cells.T,PinchPoint = min(SecondaryFluid.T[end:-1:1]-WorkingFluid.Cells.T)),p_wf = WorkingFluid.Summary.p,Q_sf = Q_sf_,Q_wf = Q_wf_);
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
          points={{-98,48},{-78,68},{-58,48},{-38,68},{-18,48},{2,68},{22,48},{42,
              68},{62,48},{82,68},{102,48}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-100,-50},{-78,-30},{-60,-50},{-40,-30},{-20,-50},{0,-30},{20,
              -50},{40,-30},{60,-50},{80,-30},{100,-50}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5)}));
end Hx1DConst_1808;
