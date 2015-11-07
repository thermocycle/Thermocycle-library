within ThermoCycle.Components.Units.Tanks;
model OpenTank "Lumped open tank model with an imposed constant pressure"

  replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
  annotation (choicesAllMatching = true);

/************ PORTS ************/
ThermoCycle.Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium)
  annotation (Placement(transformation(extent={{-108,-94},{-88,-74}}),
        iconTransformation(extent={{-108,-94},{-88,-74}})));
  Interfaces.Fluid.FlangeB OutFlow(  redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{88,-94},{108,-74}})));
Modelica.Blocks.Interfaces.RealOutput Level
 annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Interfaces.HeatTransfer.ThermalPortL TankWall
    annotation (Placement(transformation(extent={{-90,-34},{-76,62}}),
        iconTransformation(extent={{-100,-56},{-86,40}})));

/************ Constants ************/
  constant Real g=Modelica.Constants.g_n;
  constant Real pi=Modelica.Constants.pi "pi-greco";

/************ Geometric Characteristics  ************/
  parameter Real H_D= 2.5 "Height to diameter ratio";
  parameter Modelica.SIunits.Volume V_tank= 4 "Volume of the Tank";
  final parameter Modelica.SIunits.Length r_int=((V_tank/(H_D)*4/pi)^(1/3))/2
    "Internal tank radius ";
  final parameter Modelica.SIunits.Length D_int=r_int*2
    "Internal tank Diameter ";
  final parameter Modelica.SIunits.Length H=V_tank/(A_cross) "Tank Height ";
  final parameter Modelica.SIunits.Area A_lateral=pi*H*D_int
    "Lateral External Area ";
  final parameter Modelica.SIunits.Area A_cross=pi*r_int^2
    "Cross section of the tank External Area ";
  final parameter Modelica.SIunits.Area Atot_tank=A_lateral + 2*A_cross
    "Total External Area (lateral + bottom + top)";

  parameter Modelica.SIunits.Pressure p_ext=3e5
    "External pressure imposed to the system";

  /************ FLUID INITIAL VALUES ***************/
parameter Modelica.SIunits.Temperature Tstart= 100+273.15 "Initial temperature"
  annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure pstart=2e5 "Initial pressure"
  annotation (Dialog(tab="Initialization"));

  final parameter Modelica.SIunits.SpecificEnthalpy hstart=
    Medium.specificEnthalpy_pTX(
            pstart,
            Tstart,
            fill(0, 0))
    "Start value of enthalpy vector (initialized by default)"
  annotation (Dialog(tab="Initialization"));

  parameter Real L_lstart(min=0, max=1) =  0.3
    "Start value for the liquid level with respect to the height of the tank,Min=0,Max=1"
    annotation (Dialog(tab="Initialization"));

  parameter Modelica.SIunits.MassFlowRate Mdotnom= 2 "Nominal fluid flow rate"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom=1
    "Nominal Heat transfer coefficient for the fluid";

/********************************* HEAT TRANSFER WITH EXTERNAL AMBIENT ********************************/
 /* Heat transfer Model */
 replaceable model HeatTransfer =
 ThermoCycle.Components.HeatFlow.HeatTransfer.Ideal
 constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Convective heat transfer for the fluid"                                                          annotation (choicesAllMatching = true);
 HeatTransfer heatTransfer( redeclare final package Medium = Medium,
 final n=1,
 final Mdotnom = Mdotnom,
 final Unom_l = Unom,
 final Unom_tp = Unom,
 final Unom_v = Unom,
 final M_dot = M_dot_su,
 final x = 0,
 final FluidState={fluidState})
                           annotation (Placement(transformation(extent={{-12,-26},
            {8,-6}})));

  /********** Variables ****************/
  Medium.ThermodynamicState fluidState;
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.Volume V_l(stateSelect=StateSelect.never)
    "Volume of the liquid";
  Modelica.SIunits.Area A_l "Lateral area of the tank occupied by the fluid";
  Real L_l(stateSelect=StateSelect.prefer, start=L_lstart)
    "Height of the liquid with respect to tank height";
  Modelica.SIunits.Mass M_l(start=Medium.density_pTX(
              pstart,
              Tstart,
              fill(0, 0))*V_tank*L_lstart) "Liquid Mass";
  Medium.SpecificEnthalpy h(start=hstart) "Fluid specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy h_su(start=hstart)
    "Enthalpy state variable at inlet node";
 Modelica.SIunits.SpecificEnthalpy h_ex(start=hstart)
    "Enthalpy state variable at outlet node";
  Medium.Density rho "Fluid density";
  Medium.Temperature T "Fluid temperature";
  Modelica.SIunits.MassFlowRate M_dot_su(start=Mdotnom);
  Modelica.SIunits.MassFlowRate M_dot_ex(start=Mdotnom);
  Modelica.SIunits.DerDensityByEnthalpy drdh
    "Derivative of average density by enthalpy";
  Modelica.SIunits.HeatFlux qdot "heat flux with the external ambient";
  Real dMdt;

equation
  assert(L_l < 1 and L_l > 0, "Height of the fluid with respect to tank height = "
     + String(L_l) + ", Value out of limit min 0 max 1");

  L_l = Level;
  fluidState = Medium.setState_ph(p, h);
  rho = Medium.density(fluidState);
  T = Medium.temperature(fluidState);
  drdh = Medium.density_derh_p(fluidState);
  L_l = V_l/V_tank;
  M_l = rho*V_l;
 A_l = A_lateral*L_l;

  /* Energy Balance */
  der(h)*M_l = (h_su - h)*M_dot_su - (h_ex - h)*M_dot_ex + A_l*qdot;

  qdot = heatTransfer.q_dot[1];

  /* Mass Balance */
  dMdt = M_dot_su - M_dot_ex;

  dMdt = rho*der(V_l) + V_l*drdh*der(h);

  p - p_ext = g*V_l/A_cross*rho;

  /* Boundary Conditions */
  /* Enthalpies */
InFlow.h_outflow = h_su;
OutFlow.h_outflow = h_ex;
  h_su = if noEvent(M_dot_su <= 0) then h else inStream(InFlow.h_outflow);
  OutFlow.h_outflow =   if noEvent(M_dot_ex >= 0) then h else inStream(OutFlow.h_outflow);

  /* pressures */
InFlow.p = p;
OutFlow.p = p;
  /*Mass Flow*/
  M_dot_su = InFlow.m_flow;
  -M_dot_ex = OutFlow.m_flow;
  connect(TankWall, heatTransfer.thermalPortL[1]) annotation (Line(
      points={{-83,14},{-2.2,14},{-2.2,-9.4}},
      color={255,0,0},
      smooth=Smooth.None));
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
<li>The model is based on dynamic mass and energy balance</li>
<li>Constant external pressure </li>
<li>The static pressure head due to the liquid level is taken into account</li>
<li> Thermal energy transfer through the lateral surface is ensured by the <em>TankWall</em> connector.
The actual heat flow is computed by the thermal energy model.</li>
<li>Minimum liquid level with respect to tank height= 0 </li>
<li>Maximum liquid level with respect to tank height= 1 </li>
</ul></p>
<p>The model comprises two flow connectors and one lumped thermal port connector.
 During normal operation the fluid enters the model from the <em>InFlow</em> connector and exits from the <em>OutFlow</em> connector.
 In case of flow reversal the fluid direction is inversed</p>
 
<p><b>Modelling options</b> </p>
<p>In the <b>General</b> tab the following options are available: </p>
<p><ul>
<li>Medium: the user has the possibility to easily switch Medium. </li>
<li>HeatTransfer: selection between the different heat transfer models available in ThermoCycle</li>
</ul></p>
</html>"));
end OpenTank;
