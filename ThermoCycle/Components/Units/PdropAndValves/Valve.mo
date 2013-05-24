within ThermoCycle.Components.Units.PdropAndValves;
model Valve
  "Valve with incompressible flow hypothesis for the calculation of the pressure drop"
  extends ThermoCycle.Icons.Water.Valve;
   Modelica.Blocks.Interfaces.RealInput cmd annotation (Placement(
        transformation(
        origin={0,80},
        extent={{-20,-20},{20,20}},
        rotation=270)));
replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Area Afull=10e-5;
  parameter Real Xopen(
    min=0,
    max=1) = 1
    "Valve opening if no external command is connected (0=fully closed; 1=fully open)";
  parameter Modelica.SIunits.Pressure DELTAp_0=500
    "Pressure drop below which a 3rd order interpolation is used for the computation of the flow rate in order to avoid infinite derivative at 0";
  Modelica.SIunits.Area A(start=Afull) "Valve throat area";
  parameter Modelica.SIunits.Pressure p_su_start=1e5
    "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_su_start=423.15
    "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure DELTAp_start=10000
    "Start value for the pressure drop"
    annotation (Dialog(tab="Initialization"));
  Modelica.SIunits.Pressure DELTAp(start=DELTAp_start);
  Modelica.SIunits.Pressure DELTAp_bis(start=DELTAp_start);
  parameter Modelica.SIunits.MassFlowRate Mdot_start=0.1
    "Mass flow rate intial value" annotation (Dialog(tab="Initialization"));
  Modelica.SIunits.MassFlowRate Mdot(start=Mdot_start);
  parameter Modelica.SIunits.Time t_init=10
    "if constinit is true, time during which the pressure drop is set to the constant value DELTAp_start"
    annotation (Dialog(tab="Initialization", enable=constinit));
  parameter Boolean constinit=false
    "if true, sets the pressure drop to a constant value at the beginning of the simulation in order to avoid oscillations"
    annotation (Dialog(tab="Initialization"));
  /*FluidState */
  Medium.ThermodynamicState  fluidState(p(start=p_su_start));
  Medium.Density  rho "Inlet density";
  /*time */
  Modelica.SIunits.Time t_change=5;
  Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";
  /*Fluid properties */
  fluidState = Medium.setState_ph(InFlow.p,inStream(InFlow.h_outflow));
  rho = Medium.density(fluidState);
  if constinit then
    DELTAp = DELTAp_start + (DELTAp_bis - DELTAp_start)*
      ThermoCycle.Functions.weightingfactor(
          t_init=t_init,
          length=t_change,
          t=time);
  else
    DELTAp = DELTAp_bis;
  end if;
  DELTAp = InFlow.p - OutFlow.p;
  A = Afull*cmd;
  if cardinality(cmd) == 0 then
    cmd = Xopen;
  end if;
  Mdot = A*sqrt(2*rho)*smooth(1, noEvent(if (DELTAp_bis > DELTAp_0)
     then sqrt(DELTAp_bis) else if (DELTAp_bis < -DELTAp_0) then -sqrt(-
    DELTAp_bis) else sqrt(DELTAp_0)*(DELTAp_bis/DELTAp_0)/4*(5 - (DELTAp_bis/
    DELTAp_0)^2)));
  // end if;
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
    Documentation(info="<HTML>
<p>This very simple model assumes a non-compressible flow for computing the pressure drop</p>
</HTML>",
        uses(Modelica(version="3.2"))));
end Valve;
