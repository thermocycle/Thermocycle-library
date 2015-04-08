within ThermoCycle.Obsolete;
model HxRec1D_1808
extends ThermoCycle.Components.Units.BaseUnits.BaseHx;
  Components.FluidFlow.Pipes.Flow1Dim Hotside(
    redeclare package Medium = Medium2,
    N=N,
    A=Ahot,
    V=Vhot,
    Mdotnom=MdotNom_Hot,
    pstart=pstart_hot,
    Tstart_inlet=Tstart_inlet_hot,
    Tstart_outlet=Tstart_outlet_hot,
    Mdotconst=Mdotconst_hot,
    max_der=max_der_hot,
    filter_dMdt=filter_dMdt_hot,
    max_drhodt=max_drhodt_hot,
    TT=TT_hot,
    steadystate=steadystate_h_hot,
    Unom_l=Unom_l_hot,
    Unom_tp=Unom_tp_hot,
    Unom_v=Unom_v_hot,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{40,134},{-34,74}})));
  Components.HeatFlow.Walls.CountCurr countCurr(N=N, counterCurrent=true)
    annotation (Placement(transformation(extent={{62,58},{-58,-8}})));
  Components.HeatFlow.Walls.MetalWall metalWall(
    N=N,
    Aext=Ahot,
    Aint=Acold,
    c_wall=c_wall,
    M_wall=M_wall,
    Tstart_wall_1=(Tstart_inlet_cold + Tstart_outlet_hot)/2,
    steadystate_T_wall=steadystate_T_wall,
    Tstart_wall_end=(Tstart_inlet_hot + Tstart_outlet_cold)/2)
    annotation (Placement(transformation(extent={{-36,-70},{38,-14}})));
  Components.FluidFlow.Pipes.Flow1Dim Coldside(
    redeclare package Medium = Medium1,
    N=N,
    A=Acold,
    V=Vcold,
    Mdotnom=MdotNom_Cold,
    pstart=pstart_cold,
    Tstart_inlet=Tstart_inlet_cold,
    Tstart_outlet=Tstart_outlet_cold,
    steadystate=steadystate_h_cold,
    Mdotconst=Mdotconst_cold,
    max_der=max_der_cold,
    filter_dMdt=filter_dMdt_cold,
    max_drhodt=max_drhodt_cold,
    TT=TT_cold,
    Unom_l=Unom_l_cold,
    Unom_tp=Unom_tp_cold,
    Unom_v=Unom_v_cold,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{-42,-152},{42,-68}})));
/* GEOMETRIES */
parameter Integer N=5 "Number of nodes for the heat exchanger";
parameter Modelica.SIunits.Volume Vhot = 0.03781 "Volume hot fluid";
parameter Modelica.SIunits.Volume Vcold= 0.03781 "Volume cold fluid";
parameter Modelica.SIunits.Area Ahot = 16.18 "Area hot fluid";
parameter Modelica.SIunits.Area Acold = 16.18 "Area cold fluid";
/*HEAT TRANSFER */
  import ThermoCycle.Functions.Enumerations.HTtypes;
  parameter HTtypes HTtypeCold=HTtypes.LiqVap
    "Cold fluid: Choose heat transfer coeff. type. Set LiqVap with Unom_l=Unom_tp=Unom_v to have a Const HT"
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l_cold=100
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone " annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp_cold=100
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v_cold=100
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter HTtypes HTtypeHot=HTtypes.LiqVap
    "Hot fluid: Choose heat transfer coeff. type. Set LiqVap with Unom_l=Unom_tp=Unom_v to have a Const HT"
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l_hot=100
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone " annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp_hot=100
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v_hot=100
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
 /*METAL WALL*/
parameter Modelica.SIunits.Mass M_wall= 69
    "Mass of the metal wall between the two fluids";
parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 500
    "Specific heat capacity of metal wall";
/*MASS FLOW*/
parameter Modelica.SIunits.MassFlowRate MdotNom_Hot= 0.2588
    "Nominal flow rate of hot fluid";
parameter Modelica.SIunits.MassFlowRate MdotNom_Cold = 0.2588
    "Nominal flow rate of cold fluid";
/*INITIAL VALUES*/
  /*pressure*/
parameter Modelica.SIunits.Pressure pstart_cold = 23.57e5
    "Nominal inlet pressure of cold fluid"  annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure pstart_hot = 1.54883e5
    "Nominal inlet pressure of hot fluid"  annotation (Dialog(tab="Initialization"));
/*Temperatures*/
parameter Modelica.SIunits.Temperature Tstart_inlet_cold = 308.43
    "Initial value of cold fluid temperature at the inlet"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet_cold = 334.78
    "Initial value of cold fluid temperature at the outlet"  annotation (Dialog(tab="Initialization"));
/*Temperatures*/
parameter Modelica.SIunits.Temperature Tstart_inlet_hot =  353.82
    "Initial value of hot fluid temperature at the inlet"  annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet_hot = 316.91
    "Initial value of hot fluid temperature at the outlet"  annotation (Dialog(tab="Initialization"));
/*steady state */
parameter Boolean steadystate_h_cold=false
    "if true, sets the derivative of h of cold fluid to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
parameter Boolean steadystate_h_hot=false
    "if true, sets the derivative of h of hot fluid to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
parameter Boolean steadystate_T_wall=false
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Initialization options", tab="Initialization"));
//NUMERICAL OPTIONS
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
/* Cold fluid */
  parameter Boolean Mdotconst_cold=false
    "Set to yes to assume constant mass flow rate of cold fluid at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der_cold=false
    "Set to yes to limit the density derivative of cold fluid during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt_cold=false
    "Set to yes to filter dMdt of cold fluid with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt_cold=100
    "Maximum value for the density derivative of primary fluid"
    annotation (Dialog(enable=max_der, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT_cold=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
/*Hot fluid */
/*Working fluid*/
  parameter Boolean Mdotconst_hot=false
    "Set to yes to assume constant mass flow rate of hot fluid at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der_hot=false
    "Set to yes to limit the density derivative of primary fluid during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt_hot=false
    "Set to yes to filter dMdt of hot fluid with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt_hot=100
    "Maximum value for the density derivative of primary fluid"
    annotation (Dialog(enable=max_der, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT_hot=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
//Variables
protected
Modelica.SIunits.Power Q_hot_;
Modelica.SIunits.Power Q_cold_;
Real PinchPoint_;
public
record SummaryBase
  replaceable Arrays T_profile;
  record Arrays
   parameter Integer n;
   Modelica.SIunits.Temperature[n] Thot;
   Modelica.SIunits.Temperature[n] Twall;
   Modelica.SIunits.Temperature[n] Tcold;
   Real PinchPoint;
  end Arrays;
  Modelica.SIunits.Pressure p_hot;
  Modelica.SIunits.Pressure p_cold;
  Modelica.SIunits.Power Q_hot;
  Modelica.SIunits.Power Q_cold;
end SummaryBase;
replaceable record SummaryClass = SummaryBase;
SummaryClass Summary( T_profile( n=N, Thot = Hotside.Cells[end:-1:1].T,  Twall = metalWall.T_wall,  Tcold = Coldside.Cells.T,PinchPoint = PinchPoint_), p_hot = Hotside.Summary.p, p_cold = Coldside.Summary.p,Q_hot = Q_hot_,Q_cold = Q_cold_);
equation
PinchPoint_ = min(Hotside.Cells[N].T -Coldside.Cells[1].T,Hotside.Cells[1].T - Coldside.Cells[N].T);
/*Heat flow */
Q_hot_ = -Hotside.Q_tot;
Q_cold_ = -Coldside.Q_tot;
  connect(metalWall.Wall_ext, Coldside.Wall_int) annotation (Line(
      points={{0.26,-50.4},{0.26,-41.2},{0,-41.2},{0,-92.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(metalWall.Wall_int, countCurr.side1) annotation (Line(
      points={{1,-33.6},{1,-14.8},{2,-14.8},{2,15.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Hotside.Wall_int, countCurr.side2) annotation (Line(
      points={{3,91.5},{3,34.5},{2,34.5},{2,34.9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(inlet_fl1, Coldside.InFlow) annotation (Line(
      points={{-90,-50},{-68,-50},{-68,-110},{-35,-110}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Coldside.OutFlow, outlet_fl1) annotation (Line(
      points={{35,-109.65},{68,-109.65},{68,-50},{96,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Hotside.InFlow, inlet_fl2) annotation (Line(
      points={{33.8333,104},{70,104},{70,60},{98,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Hotside.OutFlow, outlet_fl2) annotation (Line(
      points={{-27.8333,103.75},{-65,103.75},{-65,58},{-98,58}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,-150},
            {150,150}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
                  extent={{-150,-150},{150,150}}),
                                      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(extent={{-100,50},{100,70}},   lineColor={255,0,0}),
        Line(
          points={{-102,50},{-82,70},{-62,50},{-42,70},{-22,50},{-2,70},{18,
              50},{38,70},{58,50},{78,70},{98,50}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-100,-60},{-80,-40},{-60,-60},{-40,-40},{-20,-60},{0,-40},
              {20,-60},{40,-40},{60,-60},{80,-40},{100,-60}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Rectangle(extent={{-100,-60},{100,-40}}, lineColor={0,0,255}),
        Line(points={{-80,-76},{80,-76},{62,-66},{80,-76},{64,-88}}, smooth=
             Smooth.None),
        Line(points={{80,86},{-80,86},{-62,96},{-80,86},{-64,74}}, smooth=
              Smooth.None)}));
end HxRec1D_1808;
