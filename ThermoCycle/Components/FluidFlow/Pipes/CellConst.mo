within ThermoCycle.Components.FluidFlow.Pipes;
model CellConst
  "1-D fluid flow model (finite volume discretization - ideal fluid model)"

/************ Thermal and fluid ports ***********/
  Interfaces.Fluid.Flange_Cdot InFlow
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Interfaces.Fluid.Flange_ex_Cdot OutFlow
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  Interfaces.HeatTransfer.ThermalPortL Wall_int
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));

  /************ Geometric characteristics **************/
  parameter Integer Nt(min=1)=1 "Number of cells in parallel";
  parameter Modelica.SIunits.Volume Vi "Volume of a single cell";
  parameter Modelica.SIunits.Area Ai "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom= 3
    "Norminal  fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer  Unom=500
    "Nominal heat transfer coefficient,secondary fluid";

/************ FLUID INITIAL VALUES ***************/
  parameter Modelica.SIunits.Temperature Tstart= 145 + 273.15
    "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));

 /************************** NUMERICAL OPTIONS  ******************************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
parameter Boolean steadystate=true
    "if true, sets the derivative of T to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));

/********************************* VARIABLES **************************************************/
  Modelica.SIunits.Temperature T_su;
  Modelica.SIunits.MassFlowRate Mdot;
  Modelica.SIunits.SpecificHeatCapacity cp;
  Modelica.SIunits.Density rho_su;
  Modelica.SIunits.Temperature T(start=Tstart) "Node temperatures";
  Modelica.SIunits.Temperature Tnode_su;
  Modelica.SIunits.Temperature Tnode_ex;
  Modelica.SIunits.HeatFlux qdot "Average heat flux";
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass";

/********************************* HEAT TRANSFER MODEL ********************************/
/* Heat transfer Model */
replaceable model HeatTransfer =
ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence_IdealFluid
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones_IdealFluid
    "Convective heat transfer"                                                                                                   annotation (choicesAllMatching = true);
HeatTransfer heatTransfer(
final Mdotnom = Mdotnom/Nt,
final Unom = Unom,
final M_dot = Mdot,
final T_fluid = T)              annotation (Placement(transformation(extent={{-6,-14},
            {14,6}})));

equation
  T_su = Tnode_su;
     //Energy balance
    Vi*cp*rho_su*der(T) + Mdot*cp*(Tnode_ex - Tnode_su) = Ai*qdot;

    if (Discretization == Discretizations.centr_diff or Discretization == Discretizations.centr_diff_AllowFlowReversal) then
      T = (Tnode_su + Tnode_ex)/2;
    else         // Upwind schemes
      Tnode_ex = T;
      //!! Needs to be modified in case of flow reversal
    end if;

qdot = heatTransfer.q_dot;
Q_tot = Ai*sum(qdot) "Total heat flow through the thermal port";
M_tot = Vi * rho_su;

//* BOUNDARY CONDITIONS *//
/*Mass Flow*/
  Mdot = InFlow.Mdot/Nt;
  OutFlow.Mdot/Nt = Mdot;
/*Specific heat capacity */
  cp = InFlow.cp;
  OutFlow.cp = cp;
/*Temperatures */
  T_su = InFlow.T;
  OutFlow.T = Tnode_ex;
/*Density*/
  rho_su = InFlow.rho;
  OutFlow.rho = rho_su;

initial equation
      if steadystate then
    der(T) = 0;
      end if;

equation
  connect(heatTransfer.thermalPortL, Wall_int) annotation (Line(
      points={{3.8,2.6},{3.8,23.3},{2,23.3},{2,50}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Icon(graphics={Rectangle(extent={{-90,40},{90,-40}},
            lineColor={0,0,255})}), Diagram(graphics),Documentation(info="<HTML>
          
         <p><big>Model <b>CellConst</b> describes the flow of a constant specific heat fluid through a single cell.  An overall flow model can be obtained by interconnecting several cells in series
          (see <em><FONT COLOR=red><a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1DConst\">Flow1DConst</a></FONT></em>)
         <p><big>Two types of variables can be distinguished: cell variables and node variables. Node variables are characterized by the su (supply) and ex (exhaust) subscripts, and correspond to the inlet and outlet nodes at each cell. 
         The relation between the cell and node values depends on the discretization scheme selected.
         <p><big>The assumptions for this model are:
         <ul><li> Velocity is considered uniform on the cross section. 1-D lumped parameter model
         <li> The model is based on dynamic energy balances and on a static mass and momentum balance
         <li> Constant pressure is assumed in the cell
         <li> Constant heat capacity is assumed in the cell 
         <li> Axial thermal energy transfer is neglected
          <li> Thermal energy transfer through the lateral surface is ensured by the <em>wall_int</em> connector. The actual heat flow is computed by the thermal energy model
         </ul>
  
  <p><big> The thermal energy transfer  through the lateral surface is computed by the <em><a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer\">ConvectiveHeatTransfer</a></em> model which is inerithed in the <em>CellConst</em> model.
         
          <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following option is available:
        <ul>
        <li> HeatTransfer: the user can choose the thermal energy model he prefers </ul> 
          <p><b><big>Numerical options</b></p>
<p><big> In this tab several options are available to make the model more robust:
<ul><li> Discretization: 2 main discretization options are available: UpWind and central difference method.
</ul>
</HTML>"));
end CellConst;
