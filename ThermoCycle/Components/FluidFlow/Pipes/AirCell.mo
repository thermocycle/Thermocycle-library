within ThermoCycle.Components.FluidFlow.Pipes;
model AirCell
replaceable package Medium = Modelica.Media.Air.SimpleAir constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
//* Select heat transfer coefficient */
  import ThermoCycle.Functions.Enumerations.HT_sf;
parameter HT_sf HTtype=HT_sf.Const "Select type of heat transfer coefficient";
/* Thermal and fluid ports */
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
ThermoCycle.Interfaces.HeatTransfer.ThermalPortL Wall_ext
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));
// Geometric characteristics
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Modelica.SIunits.Volume Vi "Volume of a single cell";
  parameter Modelica.SIunits.Area Ai "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Constant heat transfer coefficient";
/* FLUID VARIABLES */
  Medium.ThermodynamicState  fluidState;
  Modelica.SIunits.MassFlowRate Mdot;
  Medium.Temperature T_su "Inlet fluid temperature";
  Medium.Temperature T_ex "Exit fluid temperature";
  Modelica.SIunits.Temperature T_wall "Internal wall temperature";
  Medium.Density rho "Average fluid cell density";
  Medium.SpecificHeatCapacity cp "Average fluid cell heat capacity";
  Modelica.SIunits.HeatFlux qdot "heat flux at each cell";
  Modelica.SIunits.CoefficientOfHeatTransfer U
    "Heat transfer coefficient between wall and working fluid";
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
equation
  T_su = Medium.temperature(Medium.setState_ph(InFlow.p,InFlow.h_outflow));
  /* Fluid Properties */
  fluidState = Medium.setState_pT(InFlow.p,(T_su + T_ex)/2);
  rho = Medium.density(fluidState);
  cp = Medium.specificHeatCapacityCp(fluidState);
  /* ENERGY BALANCE */
  Mdot*cp*(T_ex - T_su) = Ai*qdot "Energy balance";
  qdot = Unom*(T_wall - (T_su + T_ex)/2);
 if (HTtype == HT_sf.Const) then
      U = Unom;
      elseif (HTtype == HT_sf.MassFlowDependent) then
       U = ThermoCycle.Functions.U_sf(Unom=Unom, Mdot=Mdot/Mdotnom);
 end if;
Q_tot = Ai*qdot "Total heat flow through the thermal port";
M_tot = Vi*rho;
//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
 inStream(InFlow.h_outflow) = Medium.specificEnthalpy(Medium.setState_pT(InFlow.p,T_su));
 OutFlow.h_outflow = Medium.specificEnthalpy(Medium.setState_pT(InFlow.p,T_ex));
/* pressures */
 InFlow.p = OutFlow.p;
/*Mass Flow*/
 Mdot = InFlow.m_flow;
 OutFlow.m_flow = -Mdot;
  /* Thermal port boundary condition */
/*Temperatures */
 Wall_ext.T = T_wall;
 /*Heat flow */
  Wall_ext.phi = qdot;
  annotation (Diagram(graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid)}));
end AirCell;
