within ThermoCycle.Components.Units.PdropAndValves;
model Valve_lin "Valve assuming a linear relationship with the pressure drop"
  extends ThermoCycle.Icons.Water.Valve;
   Modelica.Blocks.Interfaces.RealInput cmd annotation (Placement(
        transformation(
        origin={0,80},
        extent={{-20,-20},{20,20}},
        rotation=270)));
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Boolean UseNom=false
    "if true, uses Nominal Conditions to compute valve throat area";
  parameter Modelica.SIunits.Area Afull=10e-5
    "Cross-sectional area of the fully open valve"                                           annotation (Dialog(enable=(not UseNom)));
  parameter Real Xopen(
    min=0,
    max=1) = 1
    "Valve opening if no external command is connected (0=fully closed; 1=fully open)";
  parameter Boolean CheckValve=false
    "Set to true to allow only positive flow rate";
  Real K(start=Afull) "Valve throat area";
  parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.1 "Nominal mass flow rate"
                             annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_nom=0 "Nominal pressure drop"
                           annotation (Dialog(tab="Nominal Conditions"));

  Modelica.SIunits.Pressure DELTAp(start=DELTAp_nom);
  Modelica.SIunits.MassFlowRate Mdot(start=Mdot_nom);

  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";

  if cardinality(cmd) == 0 then
    cmd = Xopen;
  end if;

  if not UseNom then
    K = Afull;
  else
    K = Mdot_nom/DELTAp_nom;
  end if;

  DELTAp = InFlow.p - OutFlow.p;
  Mdot = InFlow.m_flow;

  if CheckValve then
    Mdot = max(0,cmd * K * DELTAp);
    //if Mdot>0, the reverse flow can be imposed, which simplifies the DAE system:
    InFlow.h_outflow = 6E6;
  else
    Mdot = cmd * K * DELTAp;
    InFlow.h_outflow = inStream(OutFlow.h_outflow);
  end if;

  inStream(InFlow.h_outflow) = OutFlow.h_outflow;

initial equation

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{-100,-40},{100,-74}}, textString=
              "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<HTML>
<p><big> The <b>Valve</b> model represents the expansion of a fluid through a valve.
 <p><big>The assumptions for this model are:
         <ul><li> No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger).
         <li> No thermal energy losses to the environment
         <li> The expansion is assumed isenthalpic
         <li> Incompressible flow for computing the pressure drop
         </ul>
</HTML>",
        uses(Modelica(version="3.2"))));
end Valve_lin;
