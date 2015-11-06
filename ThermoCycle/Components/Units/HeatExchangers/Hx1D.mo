within ThermoCycle.Components.Units.HeatExchangers;
model Hx1D

replaceable package Medium1 = ThermoCycle.Media.DummyFluid
                                               constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid"   annotation (choicesAllMatching = true);
replaceable package Medium2 = ThermoCycle.Media.DummyFluid
                                               constrainedby
    Modelica.Media.Interfaces.PartialMedium "In Hx1DInc: Secondary fluid"  annotation (choicesAllMatching = true);
  Interfaces.Fluid.FlangeA inlet_fl1( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}}),
        iconTransformation(extent={{-110,-60},{-90,-40}})));
  Interfaces.Fluid.FlangeB outlet_fl1( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{86,-60},{106,-40}}),
        iconTransformation(extent={{90,-60},{110,-40}})));
  Interfaces.Fluid.FlangeA inlet_fl2( redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{88,50},{108,70}})));
  Interfaces.Fluid.FlangeB outlet_fl2( redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{-108,48},{-88,68}})));

/******************************** GEOMETRIES ***********************************/
parameter Integer N(min=1)=5 "Number of nodes for the heat exchanger";
parameter Integer Nt(min=1)=1 "Number of tube in parallel";
parameter Modelica.SIunits.Volume Vhot = 0.03781 "Volume hot fluid";
parameter Modelica.SIunits.Volume Vcold= 0.03781 "Volume cold fluid";
parameter Modelica.SIunits.Area Ahot = 16.18 "Area hot fluid";
parameter Modelica.SIunits.Area Acold = 16.18 "Area cold fluid";

/************************************************ HEAT TRANSFER ***********************************************************/
parameter Boolean counterCurrent = true
    "Swap temperature and flux vector order";

/*Cold side*/
replaceable model ColdSideHeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l_cold=100
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone " annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp_cold=100
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v_cold=100
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));

/*Hot side*/
replaceable model HotSideSideHeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l_hot=100
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone " annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp_hot=100
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v_hot=100
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));

 /*************************** METAL WALL *********************************************************/
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

/******************************************** NUMERICAL OPTIONS ****************************************************/

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
/******************************* COMPONENTS ***********************************/
  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim
                                         Hotside(
    redeclare package Medium = Medium2,
    redeclare final model Flow1DimHeatTransferModel =
        HotSideSideHeatTransferModel,
    N=N,
    Nt=Nt,
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
    annotation (Placement(transformation(extent={{38,134},{-36,74}})));
  Components.HeatFlow.Walls.CountCurr countCurr(N=N, counterCurrent=counterCurrent)
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
    annotation (Placement(transformation(extent={{-40,-56},{34,0}})));
  ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim
                                         Coldside(
    redeclare package Medium = Medium1,
    redeclare final model Flow1DimHeatTransferModel =
        ColdSideHeatTransferModel,
    N=N,
    Nt=Nt,
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
    annotation (Placement(transformation(extent={{-44,-158},{40,-74}})));

/******************************* SUMMARY ***********************************/

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
      points={{-3.74,-36.4},{-3.74,-41.2},{-2,-41.2},{-2,-98.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(metalWall.Wall_int, countCurr.side1) annotation (Line(
      points={{-3,-19.6},{-3,-14.8},{2,-14.8},{2,15.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Hotside.Wall_int, countCurr.side2) annotation (Line(
      points={{1,91.5},{1,34.5},{2,34.5},{2,34.9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(inlet_fl1, Coldside.InFlow) annotation (Line(
      points={{-90,-50},{-68,-50},{-68,-116},{-37,-116}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Coldside.OutFlow, outlet_fl1) annotation (Line(
      points={{33,-115.65},{68,-115.65},{68,-50},{96,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Hotside.InFlow, inlet_fl2) annotation (Line(
      points={{31.8333,104},{70,104},{70,60},{98,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Hotside.OutFlow, outlet_fl2) annotation (Line(
      points={{-29.8333,103.75},{-65,103.75},{-65,58},{-98,58}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-150},
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
              Smooth.None)}),
    Documentation(info="<html>
<p>Model <b>Hx1D</b> represent the model of a counter-current plate heat exchanger. It is based on the connection of different sub-components: </p>
<p><ul>
<li>Two Flow1Dim components representing the flow of the fluid in the two sides of the exchanger </li>
<li>A MetalWall components representing the thermal energy accumulation in the metal wall </li>
<li>A CountCurr component that enables the possibility of parallel or countercurrent flow </li>
</ul></p>
<p><b>Modelling options</b> </p>
<p>In the <b>Initialization</b> tab the following options are available: </p>
<p><ul>
<li>steadystate_h_cold: if true, the derivative of enthalpy of the cold side is set to zero during <i>Initialization</i> </li>
<li>steadystate_h_hot: if true, the derivative of enthalpy of the hot side is set to zero during <i>Initialization</i> </li>
<li>steadystate_T_wall: if true, the derivative of Temperature of the metal wall is set to zero during <i>Initialization</i> </li>
</ul></p>
<p><b>Numerical options</b></p>
<p>The numerical options available for the <b>HxRec1D</b> are the one implemented in <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Cell1Dim\">Cell1Dim</a>. </p>
</html>"));
end Hx1D;
