within ThermoCycle.Components.Units.Tanks;
model OpenTank "Lumped open tank model with an imposed constant pressure"

replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

  ThermoCycle.Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Modelica.Blocks.Interfaces.RealOutput Level
   annotation (Placement(transformation(extent={{90,30},{110,50}})));

 /************ Constants ************/
constant Real g=Modelica.Constants.g_n;
constant Real pi = Modelica.Constants.pi "pi-greco";

 /************ Geometric Characteristics  ************/
parameter Real H_D "Height to diameter ratio";
parameter Modelica.SIunits.Volume V_tank "Volume of the Tank";
final parameter Modelica.SIunits.Length   r_int = ((V_tank/(H_D)*4/pi)^(1/3))/2
    "Internal tank radius ";
final parameter Modelica.SIunits.Length   D_int = r_int*2
    "Internal tank Diameter ";
final parameter Modelica.SIunits.Length   H = sqrt( V_tank/(pi*r_int))
    "Tank Height ";
final parameter Modelica.SIunits.Area A_lateral=pi*H*D_int
    "Lateral External Area ";
final parameter Modelica.SIunits.Area A_cross= pi*r_int^2
    "Cross section of the tank External Area ";
final parameter Modelica.SIunits.Area Atot_tank= A_lateral + 2*pi*r_int^2
    "Total External Area (lateral + bottom + top)";

parameter Modelica.SIunits.Pressure p_ext
    "External pressure imposed to the system";

 /************ FLUID INITIAL VALUES ***************/
  parameter Modelica.SIunits.Temperature Tstart "Initial temperature"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Pressure pstart "Initial temperature"
    annotation (Dialog(tab="Initialization"));

final parameter Modelica.SIunits.SpecificEnthalpy hstart=
      Medium.specificEnthalpy_pTX(
              pstart,
              Tstart,
              fill(0, 0))
    "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));

parameter Real L_lstart( min=0,max=1)
    "Start value for the liquid level with respect to the height of the tank,Min=0,Max=1"
 annotation (Dialog(tab="Initialization"));

parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate" annotation (Dialog(tab="Initialization"));

/********** Variables ****************/
Medium.ThermodynamicState  fluidState;
Medium.AbsolutePressure p(start=pstart);
Modelica.SIunits.Volume V_l(stateSelect = StateSelect.never)
    "Volume of the liquid";
Real L_l(stateSelect=StateSelect.prefer,start= L_lstart)
    "Height of the liquid with respect to tank height";
Modelica.SIunits.Mass M_l(  start = Medium.density_pTX(
                pstart,
                Tstart,
                fill(0, 0))*V_tank*L_lstart) "Liquid Mass";
Medium.SpecificEnthalpy h( start = hstart) "Fluid specific enthalpy";
Modelica.SIunits.SpecificEnthalpy h_su(start=hstart)
    "Enthalpy state variable at inlet node";
//Modelica.SIunits.SpecificEnthalpy h_ex(start=hstart)
//    "Enthalpy state variable at outlet node";
Medium.Density rho "Fluid density";
Medium.Temperature T "Fluid temperature";
Modelica.SIunits.MassFlowRate M_dot(start=Mdotnom);
//Modelica.SIunits.MassFlowRate M_dot_ex(start=Mdotnom);
Modelica.SIunits.DerDensityByEnthalpy drdh
    "Derivative of average density by enthalpy";
Real dMdt;

equation
assert(L_l <1 and L_l>0, "Height of the fluid with respect to tank height = " + String(L_l) + ", Value out of limit min 0 max 1");

L_l = Level;
fluidState = Medium.setState_ph(p,h);
rho = Medium.density(fluidState);
T = Medium.temperature(fluidState);
drdh = Medium.density_derh_p(fluidState);
L_l = V_l/V_tank;
M_l = rho*V_l;

/* Energy Balance */
dMdt*h + der(h)*M_l = h_su*M_dot;

/* Mass Balance */
dMdt = M_dot;

dMdt = rho*der(V_l) + V_l*drdh*der(h);

p - p_ext = g*V_l/A_cross*rho;

/* Boundary Conditions */
 /* Enthalpies */
  InFlow.h_outflow = h_su;
  //OutFlow.h_outflow = h_ex;
h_su = if noEvent(M_dot <= 0) then h else inStream(InFlow.h_outflow);

/* pressures */
 InFlow.p = p;

/*Mass Flow*/
 M_dot = InFlow.m_flow;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,40},{100,-100}},
          lineColor={0,255,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{-98,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-98},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{98,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,92},{66,62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-44,32},{38,32},{30,32}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-26,24},{22,24},{14,24}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-16,16},{10,16},{2,16}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-6,8},{2,8},{-6,8}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None)}),     Diagram(graphics),Documentation(info="<html>
<p>The model <b>OpenTank</b> describes the storage of fluid in liquid phase in an open tank. </p>
<p><b>Pressure</b> and <b>enthalpy</b> are selected as state variables. </p>
<p>The assumptions for this model are: </p>
<p><ul>
<li>The model is based on dynamic mass and energy</li>
<li>Constant external pressure </li>
<li>The static pressure head due to the liquid level is taken into account</li>
<li>The thermal energy transfer with the ambient is neglected </li>
<li>Minimum liquid level with respect to tank height= 0 </li>
<li>Maximum liquid level with respect to tank height= 1 </li>
</ul></p>
<p>The model comprises one single flow connector. </p>
<p><b>Modelling options</b> </p>
<p>In the <b>General</b> tab the following options are available: </p>
<p><ul>
<li>Medium: the user has the possibility to easily switch Medium. </li>
</ul></p>
</html>"));
end OpenTank;
