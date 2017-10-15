within ThermoCycle.Components.FluidFlow.Pipes;
model Pipe
  "Model of a tube to account for thermal inertia and heat losses in pipings"
//   import AmbianceLosses;
//   import RMH_Sept2014;

replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching = true);

/******************************** GEOMETRIES ***********************************/

parameter Integer Nt=1 "Number of cells in parallel in the Flow1DimInc";
parameter Integer N(min=1)=10 "Number of cells";
parameter Modelica.SIunits.Area A_in = 1 "Inside surface area of the tube";
parameter Modelica.SIunits.Area A_ex = 1 "Outisde surface area of the tube";
parameter Modelica.SIunits.Volume V_in = 1 "Volume of fluid inside the tube";
//parameter Modelica.SIunits.Length L_sl = 1 "Length of the split line";

/************************************************ HEAT TRANSFER ***********************************************************/

replaceable model Flow1DimHeatTransferModel =
      Components.HeatFlow.HeatTransfer.MassFlowDependence constrainedby
    Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Fluid heat transfer model" annotation (choicesAllMatching = true, Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=100
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone " annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=100
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=100
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_ex =  1
    "Heat transfer coefficient to the ambiance";

/*************************** METAL WALL & AMBIANCE *********************************************************/
parameter Modelica.SIunits.Mass M_wall = 1 "Wall mass of the tube";
parameter Modelica.SIunits.SpecificHeatCapacity c_wall = 500
    "Specific heat capacity of the wall";
/*MASS FLOW*/
parameter Modelica.SIunits.MassFlowRate Mdotnom = 1
    "Nominal fluid flow rate inside the tube";

/*INITIAL VALUES*/
  /*pressure*/
parameter Modelica.SIunits.Pressure pstart = 2e5 "Fluid pressure start value"
                                   annotation (Dialog(tab="Initialization"));
  /*Temperatures*/
parameter Modelica.SIunits.Temperature Tstart_inlet = 283
    "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet = 283
    "Outlet temperature start value" annotation (Dialog(tab="Initialization"));
parameter Real T_ext_param = -1;

/*steady state */
parameter Boolean steadystate_h=false
    "if true, sets the derivative of h to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));

/******************************************** NUMERICAL OPTIONS ****************************************************/

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

////////// COMPONENTS //////////

  Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
    redeclare package Medium = Medium,
    redeclare model Flow1DimHeatTransferModel = Flow1DimHeatTransferModel,
    Nt=Nt,
    N=N,
    A=A_in,
    V=V_in,
    Mdotnom=Mdotnom,
    pstart=pstart,
    Tstart_inlet=Tstart_inlet,
    Tstart_outlet=Tstart_outlet,
    Mdotconst=Mdotconst,
    max_der=max_der,
    filter_dMdt=filter_dMdt,
    max_drhodt=max_drhodt,
    TT=TT,
    steadystate=steadystate_h,
    Unom_l=Unom_l,
    Unom_tp=Unom_tp,
    Unom_v=Unom_v,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{-14,0},{10,24}})));

  ThermoCycle.Interfaces.Fluid.FlangeA flangeA(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-94,-2},{-74,18}}),
        iconTransformation(extent={{-120,38},{-96,62}})));
  ThermoCycle.Interfaces.Fluid.FlangeB flangeB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{78,0},{98,20}}),
        iconTransformation(extent={{76,40},{100,64}})));
  Components.HeatFlow.Walls.MetalWall metalWall(
    N=N,
    Aext=A_ex,
    Aint=A_in,
    M_wall=M_wall,
    c_wall=c_wall,
    Tstart_wall_1=Tstart_inlet,
    Tstart_wall_end=Tstart_outlet)
    annotation (Placement(transformation(extent={{-18,64},{20,24}})));

  Components.HeatFlow.Sources.AmbientLosses ambianceLosses(N=N, Uloss=
        Unom_ex)
    annotation (Placement(transformation(extent={{-8,68},{10,88}})));
  Modelica.Blocks.Interfaces.RealInput T_ext annotation (Placement(
        transformation(
        extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={1,107}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-8,94})));

equation
if cardinality(T_ext) == 0 then
  T_ext = T_ext_param;
end if;

T_ext = ambianceLosses.T_input;

  connect(ambianceLosses.ThermalPort_ext, metalWall.Wall_ext) annotation (Line(
      points={{1,68.4},{1,54.6},{0.62,54.6},{0.62,50}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flow1Dim.Wall_int, metalWall.Wall_int) annotation (Line(
      points={{-2,17},{0,17},{0,38},{1,38}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flangeA, flow1Dim.InFlow) annotation (Line(
      points={{-84,8},{-48,8},{-48,12},{-12,12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1Dim.OutFlow, flangeB) annotation (Line(
      points={{8,12.1},{48,12.1},{48,10},{88,10}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -20},{100,120}}),  graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-20},{100,120}}),  graphics={
                             Bitmap(
          extent={{-108,103},{90,-5}},
          imageSource=
              "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",
          fileName="modelica://RMH_Sept2014/../../../Picture1.png")}));
end Pipe;
