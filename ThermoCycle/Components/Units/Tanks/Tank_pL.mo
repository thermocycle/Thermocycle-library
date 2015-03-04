within ThermoCycle.Components.Units.Tanks;
model Tank_pL
  "Fully-mixed two-phase tank model with pressure and level as state variables"
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Volume Vtot=0.002 "Volume of the tank";
  parameter Modelica.SIunits.Pressure p_ng = 0
    "Partial pressure of non-condensable gases";
  parameter Modelica.SIunits.Pressure pstart=5e5 "Initial pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter Real L_start=0.6 "Initial level"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean impose_L=true "Set to yes to impose the initial tank level"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean impose_pressure=false
    "Set to yes to impose the initial tank pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean SteadyState_p=false
    "Set to yes to impose initial steady-state on the pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean SteadyState_L=false
    "Set to yes to impose initial steady-state on the tank level"
    annotation (Dialog(tab="Initialisation"));
  Medium.SaturationProperties sat;
  Modelica.SIunits.Pressure p_tot(start=pstart) "Total pressure of the system";
  Medium.Density rho "Inlet density";
  Modelica.SIunits.Volume Vl(start=Vtot*L_start)
    "Volume of the fluid in liquid phase [m3]";
  Modelica.SIunits.Volume Vv(start=Vtot*(1 - L_start))
    "Volume of the fluid in vapor phase [m3]";
  Modelica.SIunits.MassFlowRate M_dot_ex "Outlet mass flow [kg/s]";
  Modelica.SIunits.MassFlowRate M_dot_su "Inlet mass flow [kg/s]";
  Modelica.SIunits.SpecificEnthalpy h_ex "Outlet enthalpy [kJ/kg] ";
  Modelica.SIunits.SpecificEnthalpy h_su "Inlet enthalpy [kJ/kg] ";
  Modelica.SIunits.Pressure p(start=pstart);
  Modelica.SIunits.Mass M "Total mass of the fluid stored [kg]";
  Modelica.SIunits.Enthalpy H;
  Real L(start=L_start) "Level in the tank";
  Real H_der "derivative of the total enthalpy";
  Modelica.Blocks.Interfaces.RealOutput level annotation (Placement(
        transformation(extent={{90,36},{128,74}}), iconTransformation(extent=
            {{72,26},{92,46}})));
  Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,74},{10,94}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));
equation
  level = L;
  p_tot = p + p_ng;
  Vtot = Vl + Vv;
  L = Vl/Vtot;
  h_ex = sat.hl;
  sat = Medium.setSat_p(p);
  // Energy balance:
  H_der = Vtot * ( (sat.hl * sat.dl - sat.hv * sat.dv)*der(L) + (L * (sat.hl * sat.ddldp + sat.dl * sat.dhldp) + (1-L) * (sat.hv*sat.ddvdp + sat.dv*sat.dhvdp))*der(p));
  H_der = semiLinear(M_dot_su,h_su,sat.hv) - M_dot_ex*h_ex + Vtot*der(p_tot);
  // Mass balance:
  Vtot * ((sat.dl-sat.dv)*der(L) + (L*sat.ddldp+(1-L)*sat.ddvdp)*der(p))=M_dot_su - M_dot_ex;
  // Total mass and enthalpy in the tank:
  rho = L * sat.dl + (1-L)*sat.dv;
  M = rho*Vtot;
  H = Vtot * (L * sat.dl * sat.hl + (1-L) * sat.dv * sat.hv);
 /* BOUNDARY CONDITION */
  /* Enthalpies */
  h_su = if noEvent(M_dot_su <= 0) then h_ex else inStream(InFlow.h_outflow);
  InFlow.h_outflow = sat.hv;
  OutFlow.h_outflow =   if noEvent(M_dot_ex >= 0) then h_ex else inStream(OutFlow.h_outflow);
  /*Mass Flow Rate */
  M_dot_su = InFlow.m_flow;
  -M_dot_ex = OutFlow.m_flow;
  /*pressure */
  InFlow.p = p_tot;
  OutFlow.p = p_tot;
initial equation
  if impose_L then
    L = L_start;
  end if;
  if impose_pressure then
    p_tot = pstart;
  end if;
  if SteadyState_p then
    der(p)=0;
  end if;
  if SteadyState_L then
    der(L)=0;
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-76,-16},{72,-88}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255}),
        Rectangle(
          extent={{-76,76},{72,-88}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-42,-24},{40,-24},{32,-24}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-24,-32},{24,-32},{16,-32}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-14,-40},{12,-40},{4,-40}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-4,-48},{4,-48},{-4,-48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Text(extent={{-100,52},{100,18}},
          textString="%name",
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p><big> Model <b>Tank_pL</b> represents a liquid receiver. It is assumed to be in thermodynamic equilibrium at all
times, i.e. the vapor and liquid are saturated at the given pressure.
It is modeled with a dynamic energy and mass balances.

<p><big>The exhaust flow rate is defined as saturated liquid while the supply flow rate coming from the inlet can
be either subcooled (in which case the receiver pressure is going to decrease), saturated (in which case the receiver pressure remains constant) or two-phase
(in which case the receiver pressure is going to increase).
<p><big> It uses  <b>L </b>, the relative level, and  <b>p</b>, pressure, as state variables
<p><big>It only requires one saturation call to the thermodynamic properties.</p>

<p><b><big>Modelling options</b></p>
  <p><big> In the <b>Initialization</b> tab the following options are available:
        <ul><li> impose_L: if  true, the level of the tank is imposed during <em>Initialization</em>
         <li> impose_pressure: if  true, the pressure of the tank is imposed during <em>Initialization</em>
         <li> SteadyState_p: if  true, the derivative of the pressure of the tank is set to zero during <em>Initialization</em>
         <li> SteadyState_L: if  true, the derivative of the level of the tank is set to zero during <em>Initialization</em>
         </ul>


<p>Sylvain Quoilin, March 2013.</p>
</html>"));
end Tank_pL;
