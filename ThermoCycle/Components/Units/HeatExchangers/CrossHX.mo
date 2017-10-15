within ThermoCycle.Components.Units.HeatExchangers;
model CrossHX
parameter Integer N(min=1) = 5 "Number of cells";
 replaceable package Medium1 =ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid" annotation (choicesAllMatching=true);
 replaceable package Medium2 =Modelica.Media.Air.SimpleAir constrainedby
    Modelica.Media.Interfaces.PartialMedium "Secondary fluid fluid" annotation (choicesAllMatching = true);

  /*******************************************  PARAMETER *****************************************************************/
  /*Geometry*/
  parameter Modelica.SIunits.Volume V_wf =  0.0397
    "Volume of working fluid side";
  parameter Modelica.SIunits.Area A_wf = 16.18
    "Lateral surface of working fluid side";
  parameter Modelica.SIunits.Volume V_sf= 0.0397 "Total volume of fluid";
  parameter Modelica.SIunits.Area A_sf= 16.18 "Total Lateral surface";
  parameter Modelica.SIunits.MassFlowRate Mdotnom_wf = 0.2588
    "Nominal fluid flow rate";
  parameter Modelica.SIunits.MassFlowRate Mdotnom_sf= 3
    "Nominal fluid flow rate";
/* MetalWall parameter */
  parameter Modelica.SIunits.Mass M_wall_tot= 69 "Mass of the Wall ";
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 500
    "Specific heat capacity of the metal ";

/******************************** HEAT TRANSFER **************************************************/
/*Secondary fluid*/
replaceable model Medium2HeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);
/*Working fluid*/
replaceable model Medium1HeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l= 300
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone " annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp= 700
    "if HTtype = LiqVap : heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v= 400
    "if HTtype = LiqVap : heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_sf= 100
    "Constant heat transfer coefficient" annotation (Dialog(group="Heat transfer", tab="General"));

/*PRESSURE DROP SECONDARY FLUID */

   parameter Boolean UseNom_sf=false
    "Use Nominal conditions to compute pressure drop characteristics" annotation (Dialog(group="Pdrop_sf", tab="General"));
 parameter Modelica.SIunits.Length h_sf=0
    "Static fluid head (dp = h * rho * g)"                                        annotation (Dialog(enable=(not UseNom),group="Pdrop_sf", tab="General"));
  parameter Real k_sf= 38.4E3*9.5
    "Coefficient for linear pressure drop (dp = k * V_dot)"                            annotation (Dialog(enable=(not UseNom_sf),group="Pdrop_sf", tab="General"));
  parameter Modelica.SIunits.Area Athroat_sf=(2*9.5*23282.7)^(-0.5)
    "Valve throat area for quadratic pressure drop (dp = 1/A²*M_dot²/(2*rho))"
                                                                                 annotation (Dialog(enable=(not UseNom_sf),group="Pdrop_sf", tab="General"));
 parameter Modelica.SIunits.Pressure DELTAp_0_sf=500
    "Pressure drop below which a 3rd order interpolation is used for the computation of the flow rate in order to avoid infinite derivative at 0"
                                                                                                        annotation (Dialog(group="Pdrop_sf", tab="General"));
parameter Modelica.SIunits.Pressure p_nom_sf=1e5 "Nominal pressure"
                       annotation (Dialog(group="Pdrop_sf",tab="Nominal Conditions"));
parameter Modelica.SIunits.Temperature T_nom_sf=283.15 "Nominal temperature"
                          annotation (Dialog(group="Pdrop_sf",tab="Nominal Conditions"));
 parameter Modelica.SIunits.Density rho_nom_sf=Medium1.density_pT(
          p_nom_sf,
          T_nom_sf) "Nominal density"    annotation (Dialog(group="Pdrop_sf",tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_stat_nom_sf=0
    "Nominal static pressure drop"
                           annotation (Dialog(group="Pdrop_sf",tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_lin_nom_sf=0
    "Nominal linear pressure drop"
                           annotation (Dialog(group="Pdrop_sf",tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_quad_nom_sf=0
    "Nominal quadratic pressure drop"                                                      annotation (Dialog(group="Pdrop_sf",tab="Nominal Conditions"));
   parameter Boolean   use_rho_nom_sf=false
    "Use the nominal density for the computation of the pressure drop (i.e it depends only the flow rate)"
                           annotation (Dialog(group="Pdrop_sf",tab="Nominal Conditions"));

/************************************************* INITIALIZATION ********************************/

 /* WorkingFluid Initial values */
parameter Modelica.SIunits.Pressure pstart_wf = 23.57
    "Fluid pressure start value"     annotation (Dialog(tab="Initialization"));
  parameter Medium1.Temperature Tstart_wf_in "Inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  //parameter Medium1.Temperature Tstart_wf_out "outlet temperature start value"annotation (Dialog(tab="Initialization"));
  parameter Medium1.SpecificEnthalpy hstart_wf_in=Medium1.specificEnthalpy_pT(pstart_wf,Tstart_wf_in)
    "Start value of inlet enthalpy"
    annotation (Dialog(tab="Initialization"));

  /*Metal Wall*/
  parameter Modelica.SIunits.Temperature T_start_wall = (Tstart_wf_in + T_nom_sf)/2
    "Start value of temperature (initialized by default)"
    annotation (Dialog(tab="Initialization"));
parameter Boolean steadystate_wf=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
parameter Boolean steadystate_T_wall=true
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Initialization options", tab="Initialization"));
      parameter Boolean constinit_sf=false
    "if true, sets the pressure drop to a constant value at the beginning of the simulation in order to avoid oscillations"
    annotation (Dialog(group="Initialization options",tab="Initialization"));
  parameter Boolean UseHomotopy_sf=false
    "if true, uses homotopy to set the pressure drop to zero in the first initialization"
  annotation (Dialog(group="Initialization options",tab="Initialization"));
  parameter Modelica.SIunits.Pressure   DELTAp_start_sf=DELTAp_stat_nom_sf + DELTAp_lin_nom_sf + DELTAp_quad_nom_sf
    "Start Value for the pressure drop"                                                         annotation (Dialog(group="Initialization options",tab="Initialization"));
    parameter Modelica.SIunits.Time t_init_sf=10
    "if constinit is true, time during which the pressure drop is set to the constant value DELTAp_start"
    annotation (Dialog(tab="Initialization", enable=constinit));

/*************************************** NUMERICAL OPTIONS    *****************************************************************/

/* Working Fluid */
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization_wf=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean Mdotconst_wf=false
    "Set to yes to assume constant mass flow rate at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der_wf=false
    "Set to yes to limit the density derivative during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt_wf=false
    "Set to yes to filter dMdt with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt_wf=100 "Maximum value for the density derivative"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT_wf=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=max_der_wf, tab="Numerical options"));

  ThermoCycle.Components.FluidFlow.Pipes.MultiFlow1D    multiFlow1D_DP(
    redeclare package Medium = Medium2,
    redeclare final model MultiFlow1DimHeatTransferModel =
        Medium2HeatTransferModel,
    N=N,
    V_f=V_sf,
    Mdotnom=Mdotnom_sf,
    Unom=Unom_sf,
    UseNom=UseNom_sf,
    h=h_sf,
    k=k_sf,
    DELTAp_0=DELTAp_0_sf,
    p_nom=p_nom_sf,
    T_nom=T_nom_sf,
    rho_nom=rho_nom_sf,
    DELTAp_stat_nom=DELTAp_stat_nom_sf,
    DELTAp_lin_nom=DELTAp_lin_nom_sf,
    DELTAp_quad_nom=DELTAp_quad_nom_sf,
    use_rho_nom=use_rho_nom_sf,
    constinit=constinit_sf,
    UseHomotopy=UseHomotopy_sf,
    DELTAp_start=DELTAp_start_sf,
    t_init=t_init_sf,
    A_f=A_sf,
    A=Athroat_sf)
    annotation (Placement(transformation(extent={{-20,-66},{20,-32}})));
ThermoCycle.Components.HeatFlow.Walls.MetalWallL metalWallCell[N](
    each M_wall=M_wall_tot/N,
    each c_wall=c_wall,
    each Tstart_wall=T_start_wall,
    each steadystate_T_wall=steadystate_T_wall,
    each Aext=A_sf/N,
    each Aint=A_wf/N)
    annotation (Placement(transformation(extent={{-34,-18},{34,30}})));
    ThermoCycle.Components.FluidFlow.Pipes.Cell1Dim           flow1DimCell[N](
    redeclare package Medium = Medium1,
    redeclare final model HeatTransfer =
        Medium1HeatTransferModel,
    each Vi=V_wf/N,
    each Ai=A_wf/N,
    each Mdotnom=Mdotnom_wf,
    each Unom_l=Unom_l,
    each Unom_tp=Unom_tp,
    each Unom_v=Unom_v,
    each pstart=pstart_wf,
    each Discretization=Discretization_wf,
    each Mdotconst=Mdotconst_wf,
    each max_der=max_der_wf,
    each filter_dMdt=filter_dMdt_wf,
    each max_drhodt=max_drhodt_wf,
    each TT=TT_wf,
    each steadystate=steadystate_wf,
    each hstart = hstart_wf_in)    annotation (Placement(transformation(extent={{-28,74},{26,30}})));
ThermoCycle.Interfaces.Fluid.FlangeA Inlet_fl1(redeclare package Medium =        Medium1)
    annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));
ThermoCycle.Interfaces.Fluid.FlangeB Outlet_fl1(redeclare package Medium =        Medium1)
    annotation (Placement(transformation(extent={{88,-10},{108,10}})));
ThermoCycle.Interfaces.Fluid.FlangeA Inlet_fl2(redeclare package Medium =Medium2)
    annotation (Placement(transformation(extent={{-10,86},{10,106}})));
ThermoCycle.Interfaces.Fluid.FlangeB Outlet_fl2(redeclare package Medium=Medium2)
    annotation (Placement(transformation(extent={{-12,-106},{8,-86}})));
equation
  // Connect wall and refrigerant cells with eachother
  for i in 1:N-1 loop
    connect(flow1DimCell[i].OutFlow, flow1DimCell[i+1].InFlow);
  end for;
// flow1DimCell.hstart = linspace(hstart_wf_in,hstart_wf_out,N);
  connect(Outlet_fl2, multiFlow1D_DP.flangeB) annotation (Line(
      points={{-2,-96},{-2,-78},{86,-78},{86,-48},{72,-48},{72,-49},{20,-49}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Inlet_fl1, flow1DimCell[1].InFlow) annotation (Line(
      points={{-102,0},{-42,0},{-42,52},{-28,52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1DimCell[N].OutFlow, Outlet_fl1) annotation (Line(
      points={{26,51.78},{62,51.78},{62,0},{98,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(metalWallCell.Wall_ext, multiFlow1D_DP.thermalPortCell) annotation (
      Line(
      points={{-0.68,-1.2},{-0.68,-33.6},{0,-33.6},{0,-40.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Inlet_fl2, multiFlow1D_DP.flangeA) annotation (Line(
      points={{0,96},{-2,96},{-2,72},{-66,72},{-66,-49},{-20,-49}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1DimCell.Wall_int, metalWallCell.Wall_int) annotation (Line(
      points={{-1,41},{-1,28.5},{0,28.5},{0,13.2}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(points={{-80,2},{80,2},{62,12},{80,2},{64,-10}},      smooth=
              Smooth.None),
        Line(points={{-80,1},{80,1},{62,11},{80,1},{64,-11}},      smooth=
              Smooth.None,
          origin={-2,-1},
          rotation=-90)}),
    Documentation(info="<html>
<p>Model <b>CrossHX</b> represent the model of a cross flow plate heat exchanger where air is used as secondary fluid. Pressure drop is taken into account in the air side. It is based on the connection of different sub-components: </p>
<p><ul>
<li>A Flow1Dim component representing the flow of the fluid in one side of the exchanger </li>
<li>A MultiFlow1D component representing the flow of air in the other side of the exchanger </li>
<li>A MetalWall component representing the thermal energy accumulation in the metal wall </li>
</ul></p>
<p><b>Modelling options</b> </p>
<p>In the <b>Initialization</b> tab the following options are available: </p>
<p><ul>
<li>steadystate_wf: if true, the derivative of enthalpy of the working fluid is set to zero during <i>Initialization</i> </li>
<li>steadystate_T_wall: if true, the derivative of temperature of the metal wall is set to zero during <i>Initialization</i> </li>
<li>constinit_sf: if true, the pressure drop in the air side is set to a constant value during <i>Initialization</i> </li>
<li>UseHomotopy_sf: if true, it uses homotopy to set the pressure drop to zero during <i>Initialization</i> </li>
</ul></p>
<p><b>Numerical options</b></p>
<p>The numerical options available for the <b>CrossHX</b> are the one implemented in <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Cell1Dim\">Cell1Dim</a>. </p>
</html>"));
end CrossHX;
