within ThermoCycle.Components.Units.Tanks;
model Drum_pL
  "Fully-mixed two-phase Drum model with pressure and level as state variables. One inlet, two outlets (vapor and liquid)"

replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);

  /******************************* CONNECTORS *****************************/
    Modelica.Blocks.Interfaces.RealOutput level annotation (Placement(
        transformation(extent={{90,36},{128,74}}), iconTransformation(extent={{84,-10},
            {104,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow_l(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}),
        iconTransformation(extent={{-10,-100},{10,-80}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow_v(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

  /******************************* PARAMETERS *****************************/
  parameter Modelica.SIunits.Volume Vtot=0.002 "Volume of the tank";
  parameter Modelica.SIunits.Pressure p_ng = 0
    "Partial pressure of non-condensable gases";
  parameter Modelica.SIunits.Pressure pstart=5e5 "Initial pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Real L_start=0.6 "Initial level"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean impose_L=true "if true, imposes the initial tank level"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean impose_pressure=false
    "if true, imposes the initial tank pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean SteadyState_p=false
    "if true, imposes initial steady-state on the pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean SteadyState_L=false
    "if true, imposes initial steady-state on the tank level"
    annotation (Dialog(tab="Initialization"));
  /******************************* VARIABLES *****************************/
  Medium.SaturationProperties sat;
  Modelica.SIunits.Pressure p_tot(start=pstart) "Total pressure of the system";
  Medium.Density rho "Inlet density";
  Modelica.SIunits.Volume Vl(start=Vtot*L_start)
    "Volume of the fluid in liquid phase [m3]";
  Modelica.SIunits.Volume Vv(start=Vtot*(1 - L_start))
    "Volume of the fluid in vapor phase [m3]";
  Modelica.SIunits.MassFlowRate M_dot_ex_l "Outlet mass flow [kg/s]";
  Modelica.SIunits.MassFlowRate M_dot_ex_v "Outlet mass flow [kg/s]";
  Modelica.SIunits.MassFlowRate M_dot_su "Inlet mass flow [kg/s]";
  Modelica.SIunits.SpecificEnthalpy h_su "Inlet enthalpy [kJ/kg] ";
  Modelica.SIunits.Pressure p(start=pstart);
  Modelica.SIunits.Mass M "Total mass of the fluid stored [kg]";
  Modelica.SIunits.Enthalpy H;
  Real L(start=L_start) "Level of saturated liquid in the tank";
  Real H_der "derivative of the total enthalpy";

equation
  level = L;
  p_tot = p + p_ng;
  Vtot = Vl + Vv;
  L = Vl/Vtot;
  sat = Medium.setSat_p(p);

  /*  Energy balance */
  H_der = Vtot * ( (sat.hl * sat.dl - sat.hv * sat.dv)*der(L) + (L * (sat.hl * sat.ddldp + sat.dl * sat.dhldp) + (1-L) * (sat.hv*sat.ddvdp + sat.dv*sat.dhvdp))*der(p));
  H_der = semiLinear(M_dot_su,h_su,sat.hv) - M_dot_ex_l*sat.hl - M_dot_ex_v*sat.hv + Vtot*der(p_tot);

  /*  Mass balance */
  Vtot * ((sat.dl-sat.dv)*der(L) + (L*sat.ddldp+(1-L)*sat.ddvdp)*der(p))=M_dot_su - M_dot_ex_l - M_dot_ex_v;

  // Total mass and enthalpy in the tank:
  rho = L * sat.dl + (1-L)*sat.dv;
  M = rho*Vtot;
  H = Vtot * (L * sat.dl * sat.hl + (1-L) * sat.dv * sat.hv);

 /* BOUNDARY CONDITION */
  /* Enthalpies */
  h_su = if noEvent(M_dot_su <= 0) then sat.hl else inStream(InFlow.h_outflow);
  InFlow.h_outflow = sat.hv;
  OutFlow_l.h_outflow =   sat.hl;
  OutFlow_v.h_outflow = sat.hv;
  /*Mass Flow Rate */
  M_dot_su = InFlow.m_flow;
  -M_dot_ex_l = OutFlow_l.m_flow;
  -M_dot_ex_v = OutFlow_v.m_flow;
  /*pressure */
  InFlow.p = p_tot;
  OutFlow_l.p = p_tot;
  OutFlow_v.p = p_tot;
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false,extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={0,0,0},
          lineThickness=1,
          startAngle=0,
          endAngle=360,
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={0,0,0},
          lineThickness=1,
          startAngle=180,
          endAngle=360,
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{-41,-26},{41,-26},{33,-26}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-24,-36},{24,-36},{16,-36}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-13,-46},{13,-46},{5,-46}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-4,-56},{4,-56},{-4,-56}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Text(extent={{-100,52},{100,18}},
          textString="%name",
          lineColor={0,0,0}),
        Line(
          points={{-67,-14},{67,-14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><big>Model <b>Drum_pL</b> represents a liquid receiver. It is assumed to be in thermodynamic equilibrium at all times, i.e. the vapor and liquid are saturated at the given pressure. It is modeled with a dynamic energy and mass balances. </p>
<p><big>There is one inlet and two outlets (i.e. one for liquid, one for vapor) </p>
<p><big>It uses <b>L </b>, the relative level of saturated liquid, and <b>p</b>, pressure, as state variables. </p>
<p> </p>
<p><big><b>Modelling options</b> </p>
<p><big>In the <b>Initialization</b> tab the following options are available: </p>
<ul>
<li>impose_L: if true, the level of the tank is imposed during <i>Initialization</i> </li>
<li>impose_pressure: if true, the pressure of the tank is imposed during <i>Initialization</i> </li>
<li>SteadyState_p: if true, the derivative of the pressure of the tank is set to zero during <i>Initialization</i> </li>
<li>SteadyState_L: if true, the derivative of the level of the tank is set to zero during <i>Initialization</i> </li>
</ul>
<p>Sylvain Quoilin, March 2013.</p>
</html>"));
end Drum_pL;
