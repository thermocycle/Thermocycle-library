within ThermoCycle.Components.Units.PdropAndValves;
model Valve
  "Valve with incompressible flow hypothesis for the calculation of the pressure drop"
  extends ThermoCycle.Icons.Water.Valve;
   Modelica.Blocks.Interfaces.RealInput cmd annotation (Placement(
        transformation(
        origin={0,80},
        extent={{-20,-20},{20,20}},
        rotation=270)));
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Boolean UseNom=false
    "Use Nominal conditions to compute pressure drop characteristics";
  parameter Modelica.SIunits.Area Afull=10e-5
    "Cross-sectional area of the fully open valve"                                           annotation (Dialog(enable=(not UseNom)));
  parameter Real Xopen(
    min=0,
    max=1) = 1
    "Valve opening if no external command is connected (0=fully closed; 1=fully open)";
  parameter Modelica.SIunits.Pressure DELTAp_0=500
    "Pressure drop below which a 3rd order interpolation is used for the computation of the flow rate in order to avoid infinite derivative at 0";
  Modelica.SIunits.Area A(start=Afull) "Valve throat area";
  parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.1 "Nominal mass flow rate"
                             annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal inlet pressure"
                       annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Temperature T_nom=423.15
    "Nominal inlet temperature"
                          annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Density rho_nom=Medium.density_pTX(
          p_nom,
          T_nom,fill(0,0)) "Nominal density"    annotation (Dialog(tab="Nominal Conditions"));

  parameter Modelica.SIunits.Pressure   DELTAp_nom=0 "Nominal pressure drop"
                           annotation (Dialog(tab="Nominal Conditions"));
  parameter Boolean   use_rho_nom=false
    "Use the nominal density for the computation of the pressure drop (i.e it depends only on the flow rate)"
                           annotation (Dialog(tab="Nominal Conditions"));

  Modelica.SIunits.Pressure DELTAp(start=DELTAp_nom);
  Modelica.SIunits.Pressure DELTAp_bis(start=DELTAp_nom);
  Modelica.SIunits.MassFlowRate Mdot(start=Mdot_nom);
  parameter Modelica.SIunits.Time t_init=10
    "if constinit is true, time during which the pressure drop is set to the constant value DELTAp_nom"
    annotation (Dialog(tab="Initialization", enable=constinit));
  parameter Boolean constinit=false
    "if true, sets the pressure drop to a constant value at the beginning of the simulation in order to avoid oscillations"
    annotation (Dialog(tab="Initialization"));
  /*FluidState */
  Medium.ThermodynamicState  fluidState(p(start=p_nom),T(start=T_nom));
  Medium.Density  rho "Inlet density";
  /*time */
  Modelica.SIunits.Time t_change=5;
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";
  /*Fluid properties */
  fluidState = Medium.setState_ph(InFlow.p,inStream(InFlow.h_outflow));
  if cardinality(cmd) == 0 then
    cmd = Xopen;
  end if;
  if not UseNom then
    A = Afull*cmd;
  else
    A = cmd* abs(Mdot_nom)/sqrt(max(abs(DELTAp_nom), 50)*2*rho_nom);
  end if;
  if use_rho_nom then
    rho = rho_nom;
  else
    rho = Medium.density(fluidState);
  end if;
  if constinit then
    DELTAp = DELTAp_nom + (DELTAp_bis - DELTAp_nom)*
      ThermoCycle.Functions.weightingfactor(
          t_init=t_init,
          length=t_change,
          t=time);
  else
    DELTAp = DELTAp_bis;
  end if;
  DELTAp = InFlow.p - OutFlow.p;
  Mdot = A*sqrt(2*rho)*smooth(1, noEvent(if (DELTAp_bis > DELTAp_0)
     then sqrt(DELTAp_bis) else if (DELTAp_bis < -DELTAp_0) then -sqrt(-
    DELTAp_bis) else sqrt(DELTAp_0)*(DELTAp_bis/DELTAp_0)/4*(5 - (DELTAp_bis/
    DELTAp_0)^2)));
  // Boundary conditions
  Mdot = InFlow.m_flow;
  InFlow.h_outflow = inStream(OutFlow.h_outflow);
  inStream(InFlow.h_outflow) = OutFlow.h_outflow;
initial equation

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{-100,-40},{100,-74}}, textString=
              "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<html>
<p>The <b>Valve</b> model represents the expansion of a fluid through a valve. </p>
<p>The assumptions for this model are: </p>
<p><ul>
<li>No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger). </li>
<li>No ambient heat losses (the expansion is assumed isenthalpic) </li>
<li>Incompressible flow for computing the pressure drop </li>
<li>Quadratic pressure drop (turbulent flow)</li>
</ul></p>
</html>",
        uses(Modelica(version="3.2"))));
end Valve;
