within ThermoCycle.Components.FluidFlow.Pipes;
model AirCell "Constant specific heat fluid"
replaceable package Medium = Modelica.Media.Air.SimpleAir constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
/************ Thermal and fluid ports ***********/
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
        /************ Geometric characteristics **************/

  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Integer Nt(min=1) = 1 "Number of cells in parallel";
  parameter Modelica.SIunits.Volume Vi "Volume of a single cell";
  parameter Modelica.SIunits.Area Ai "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Constant heat transfer coefficient";

  parameter Medium.Temperature T_start=273.15+25 annotation (tab="Numerical options");
/*****************HEAT TRANSFER MODEL************************/
replaceable model HeatTransfer =
      ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Convective heat transfer"                                                         annotation (choicesAllMatching = true);
HeatTransfer ConvectiveHeatTransfer(redeclare final package Medium = Medium,
final n=1,
final Mdotnom = Mdotnom,
final Unom_l = Unom,
final Unom_tp = Unom,
final Unom_v = Unom,
final M_dot = Mdot,
final x = 0,
final FluidState={fluidState})
   annotation (Placement(transformation(extent={{-8,-16},{12,4}})));
/********************* VARIABLES *********************/
  Medium.ThermodynamicState  fluidState;
  Modelica.SIunits.MassFlowRate Mdot;
  Medium.SpecificEnthalpy h(start=Medium.specificEnthalpy(Medium.setState_pT(1E5,T_start)))
    "Average fluid enthalpy";
  Medium.Density rho "Average fluid cell density";
  Modelica.SIunits.HeatFlux qdot "heat flux at each cell";
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
equation
  /* Fluid Properties */
  h = (OutFlow.h_outflow + inStream(InFlow.h_outflow))/2;
  fluidState = Medium.setState_ph(InFlow.p,h);
  rho = Medium.density(fluidState);
  /* ENERGY BALANCE */
  Mdot*(OutFlow.h_outflow - inStream(InFlow.h_outflow)) = Ai*qdot
    "Energy balance";
  Q_tot = Ai*qdot "Total heat flow through the thermal port";
  qdot = ConvectiveHeatTransfer.q_dot[1];
  M_tot = Vi*rho;
  //* BOUNDARY CONDITIONS *//
  InFlow.h_outflow = 0;   // Never used since flow reversals not allowed
  /* pressures */
  InFlow.p = OutFlow.p;
  /*Mass Flow*/
  Mdot = InFlow.m_flow/Nt;
  OutFlow.m_flow/Nt = -Mdot;
  assert(Mdot>=0,"AirCell does not allow flow reversals. A negative flow has been encountered");
  /* Thermal port boundary condition */
  connect(ConvectiveHeatTransfer.thermalPortL[1], Wall_ext) annotation (Line(
      points={{1.8,0.6},{1.8,22.3},{2,22.3},{2,50}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{-54,2},{58,2},{32,16},{58,2},{34,-12}},
          color={0,0,255},
          smooth=Smooth.None)}),           Documentation(info="<HTML>
          
         <p><big>Model <b>CellConst</b> describes the flow of a constant specific heat fluid through a single cell. No dynamics is considered in this model.
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
</HTML>"));
end AirCell;
