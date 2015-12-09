within ThermoCycle.Components.Units.PdropAndValves;
model Pdrop "Linear pressure drop"
  extends ThermoCycle.Icons.Water.PressDrop;
    replaceable package Medium = ThermoCycle.Media.R245fa_CP
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model"
                                                           annotation (choicesAllMatching = true);
   /* Define the type of pressure drop */
  import ThermoCycle.Functions.Enumerations.PressureDrops;
  parameter PressureDrops DPtype=PressureDrops.UD;
  parameter Modelica.SIunits.Pressure p_su_start=1e5
    "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure DELTAp_start=10000
    "Start value for the pressure drop"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.MassFlowRate Mdot_start=0.1
    "Mass flow rate initial value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.MassFlowRate Mdot_max=0.1
    "flow rate at DELTAp_max";
  parameter Modelica.SIunits.Pressure DELTAp_max=20E5
    "Pressure drop at Mdot_max";
  /* Variables */
  Modelica.SIunits.MassFlowRate Mdot(start=Mdot_start);
  Modelica.SIunits.Pressure DELTAp(start=DELTAp_start);
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";
    if (DPtype == PressureDrops.ORCnextHP) then
    DELTAp = ThermoCycle.Functions.TestRig.PressureDropCorrelation_HP(
      M_flow=Mdot);
    DELTAp = InFlow.p - OutFlow.p;
    elseif (DPtype == PressureDrops.ORCnextLP) then
    DELTAp = ThermoCycle.Functions.TestRig.PressureDropCorrelation_LP(
      M_flow=Mdot);
    DELTAp = InFlow.p - OutFlow.p;
    else
     DELTAp = InFlow.p - OutFlow.p;
     Mdot = Mdot_max*DELTAp/DELTAp_max;
     end if;
  /* BOUNDARY CONDITIONS */
  Mdot = InFlow.m_flow;
  InFlow.h_outflow = inStream(OutFlow.h_outflow);
  inStream(InFlow.h_outflow) = OutFlow.h_outflow;
initial equation

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-120,-120},{
            120,120}}),
                    graphics={Text(extent={{-100,-40},{100,-74}}, textString=
              "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-120,-120},
            {120,120}}),graphics),
    Documentation(info="<HTML>
<p>This very simple model assumes a non-compressible flow for computing the pressure drop</p>
</HTML>",
        uses(Modelica(version="3.2"))));
end Pdrop;
