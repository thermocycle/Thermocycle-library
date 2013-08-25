within ThermoCycle.Components.FluidFlow.Pipes;
model CellConst
  "1-D fluid flow model (finite volume discretization - ideal fluid model)"

/* Thermal and fluid ports */
  Interfaces.Fluid.Flange_Cdot InFlow
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Interfaces.Fluid.Flange_ex_Cdot OutFlow
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  Interfaces.HeatTransfer.ThermalPortL Wall_int
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));

  // Geometric characteristics:
  parameter Modelica.SIunits.Volume Vi "Volume of a single cell";
  parameter Modelica.SIunits.Area Ai "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom= 3
    "Norminal  fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer  Unom=500
    "Nominal heat transfer coefficient,secondary fluid";
 /*INITIAL VALUES */
  parameter Modelica.SIunits.Temperature Tstart= 145 + 273.15
    "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
parameter Boolean steadystate=true
    "if true, sets the derivative of T to zero during Initialization"
    annotation (Dialog(group="Intialization options", tab="Initialization"));

 /************************** NUMERICAL OPTIONS  ******************************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));

/********************************* FLUID VARIABLES **************************************************/
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
ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.IdealFluid.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation_IdealFluid
    "Convective heat transfer"                                                                                                     annotation (choicesAllMatching = true);
HeatTransfer heatTransfer(
final Mdotnom = Mdotnom,
final Unom = Unom,
final M_dot = Mdot,
final T_fluid = T)              annotation (Placement(transformation(extent={{-6,-14},
            {14,6}})));

equation
  T_su = Tnode_su;
     //Energy balance
    Vi*cp*rho_su*der(T) + Mdot*cp*(Tnode_ex - Tnode_su) = Ai*qdot;

    if (Discretization == Discretizations.centr_diff or Discretization ==
        Discretizations.centr_diff_robust or Discretization == Discretizations.centr_diff_AllowFlowReversal) then
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
  Mdot = InFlow.Mdot;
  OutFlow.Mdot = Mdot;
/*Specific heat capacity */
  cp = InFlow.cp;
  OutFlow.cp = cp;
/*Temperatures */
  T_su = InFlow.T;
  OutFlow.T = Tnode_ex;
/*Density*/
  rho_su = InFlow.rho;
  OutFlow.rho = rho_su;
  /* Thermal port boundary condition */

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
            lineColor={0,0,255})}), Diagram(graphics));
end CellConst;
