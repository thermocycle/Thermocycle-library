within ThermoCycle.Components.Units.HeatExchangers;
model HX_singlephase_pT
  replaceable package Medium1 =ThermoCycle.Media.Water  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid (cold)" annotation (choicesAllMatching=true);
  replaceable package Medium2 =
      ThermoCycle.Media.Incompressible.IncompressibleTables.FlueGas                           constrainedby
    Modelica.Media.Interfaces.PartialMedium "Hot fluid" annotation (choicesAllMatching=true);

  /******************************* PARAMETERS *****************************/
  /*Metal Wall*/
  parameter Modelica.SIunits.Mass M_wall= 69 "Mass of the Wall";
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 500
    "Specific heat capacity of the metal wall";

  /****************** Heat Transfer parameter  ******************/
  parameter Boolean Use_AU=false
    "if true, uses the global thermal conductance assuming constant area"                              annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.Area A_cf=0.03 annotation (Dialog(group="Heat transfer", tab="General", enable=(not Use_AU)));
  parameter Modelica.SIunits.Area A_hf=0.03 annotation (Dialog(group="Heat transfer", tab="General", enable=(not Use_AU)));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_cf
    "Constant heat transfer coefficient ColdFluid Side" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_hf
    "Constant heat transfer coefficient HotFluid Side" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.ThermalConductance AU_global=27240
    "Global Thermal conductance"                                                    annotation (Dialog(group="Heat transfer", tab="General", enable=(Use_AU)));

  parameter Modelica.SIunits.MassFlowRate Mdot_nom_hf = 1
    "Nominal hot fluid flow rate";
  parameter Modelica.SIunits.MassFlowRate Mdot_nom_cf = 1
    "Nominal cold fluid flow rate";

  /****************** Initialization parameters ******************/
  parameter Modelica.SIunits.AbsolutePressure p_cf_start=50E5
    "Initial pressure of the cold working fluid" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_cf_su_start=394.95
    "Initial value of cold fluid inlet temperature"                                                    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_hf_su_start=599.15
    "Initial value of hot fluid inlet temperature"                                                    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_cf_ex_start=516.25
    "Initial value of cold fluid outlet temperature"                                                    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_hf_ex_start=443.35
    "Initial value of hot fluid outlet temperature"                                                    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_w_1_start=(T_cf_su_start+T_hf_ex_start)/2
    "Initial value of wall temperature between T_cf_su and T_hf_ex"                                                  annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_w_2_start=(T_cf_ex_start+T_hf_su_start)/2
    "Initial value of wall temperature between T_cf_ex and T_hf_su"                                                  annotation (Dialog(tab="Initialization"));
  parameter Boolean steadystate_T_wall=false
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Initialization options", tab="Initialization"));
  parameter Boolean T_wall_fixed=false
    "if true, imposes the initial wall temperature"                                    annotation (Dialog(group="Initialization options", tab="Initialization"));
 parameter Boolean Cp_constant=false
    "if true, sets the specific heat capacity Cp to a constant value computed with inital conditions";

  /******************************* VARIABLES *****************************/
  Modelica.SIunits.Area A(start=A_cf);
  Modelica.SIunits.Power Q_dot_cf;
  Modelica.SIunits.Power Q_dot_hf;
  Modelica.SIunits.SpecificEnthalpy h_cf_ex(start= Medium1.specificEnthalpy_pT(p_cf_start,T_cf_ex_start));
  Modelica.SIunits.Temperature T_hf_ex(start=T_hf_ex_start);
  Modelica.SIunits.Temperature T_wall(start=(T_w_1_start+T_w_2_start)/2);
  Modelica.SIunits.Temperature T_w_1(start=T_w_1_start);
  Modelica.SIunits.Temperature T_w_2(start=T_w_2_start);
  Modelica.SIunits.Temperature DELTAT_w(start=T_w_2_start - T_w_1_start);
  Modelica.SIunits.ThermodynamicTemperature LMTD_cf(displayUnit="K");
  Modelica.SIunits.ThermodynamicTemperature LMTD_hf(displayUnit="K");
  Modelica.SIunits.ThermodynamicTemperature pinch_cf(displayUnit="K",min=1);
  Modelica.SIunits.ThermodynamicTemperature pinch_hf(displayUnit="K",min=1);
  Modelica.SIunits.ThermalConductance AU_cf;
  Modelica.SIunits.ThermalConductance AU_hf;

  Medium1.SpecificHeatCapacity Cp_cf;
  Medium2.SpecificHeatCapacity Cp_hf;

  Medium1.ThermodynamicState stateIn_cf;
  Medium1.ThermodynamicState stateOut_cf;
  Medium2.ThermodynamicState stateIn_hf;
  Medium2.ThermodynamicState stateOut_hf;

/******************************* CONNECTORS *****************************/
  ThermoCycle.Interfaces.Fluid.FlangeA inlet_cf(redeclare package Medium =
        Medium1)
    annotation (Placement(transformation(extent={{-120,-12},{-100,8}}),
        iconTransformation(extent={{-120,-12},{-100,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeB outlet_cf(redeclare package Medium =
        Medium1)
    annotation (Placement(transformation(extent={{100,-12},{120,8}}),
        iconTransformation(extent={{100,-12},{120,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeA_pT inlet_hf(redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{80,62},{100,82}}),
        iconTransformation(extent={{80,62},{100,82}})));
  ThermoCycle.Interfaces.Fluid.FlangeB_pT outlet_hf(redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{-100,-84},{-80,-64}}),
        iconTransformation(extent={{-100,-84},{-80,-64}})));

equation
  stateIn_cf = Medium1.setState_ph(inlet_cf.p,inStream(inlet_cf.h_outflow));
  stateIn_hf = Medium2.setState_pT(inlet_hf.p,inStream(inlet_hf.T_outflow));

  if not Use_AU then
    AU_cf = A_cf * U_cf;
    AU_hf = A_hf * U_hf;
    A = (A_cf+A_hf)/2 "dummy";
  else
    AU_global = 1 / (1/AU_cf + 1/AU_hf);
    AU_cf = A * U_cf;
    AU_hf = A * U_hf;
  end if;

  /*Method LMTD*/
  Q_dot_cf = AU_cf * LMTD_cf;
  Q_dot_hf = AU_hf * LMTD_hf;

  /* Heat transfer calculation between the cold fluid and the wall */
  LMTD_cf = homotopy(ThermoCycle.Functions.RLMTD(T_w_1 - stateIn_cf.T, T_w_2 -
    stateOut_cf.T), max(0, pinch_cf));

  /* Heat transfer calculation between the hot fluid and the wall */
  LMTD_hf = homotopy(ThermoCycle.Functions.RLMTD(T_hf_ex - T_w_1, stateIn_hf.T - T_w_2),
    max(0, pinch_hf));

  pinch_cf = min(T_w_1-stateIn_cf.T,T_w_2-stateOut_cf.T);
  pinch_hf = min(T_hf_ex-T_w_1,stateIn_hf.T-T_w_2);

  if not Cp_constant then
    Cp_cf = Medium1.specificHeatCapacityCp(stateIn_cf);
    Cp_hf = Medium2.specificHeatCapacityCp(stateIn_hf);
  else
    Cp_cf = Medium1.specificHeatCapacityCp(Medium1.setState_pT(inlet_cf.p,(T_cf_su_start+T_cf_ex_start)/2));
    Cp_hf = Medium2.specificHeatCapacityCp(Medium2.setState_pT(inlet_hf.p,(T_hf_su_start+T_hf_ex_start)/2));
  end if;

  Q_dot_cf = max(Mdot_nom_cf/100,inlet_cf.m_flow) * (h_cf_ex - stateIn_cf.h);
  Q_dot_hf = max(Mdot_nom_hf/100,inlet_hf.m_flow) * Cp_hf * (stateIn_hf.T - T_hf_ex);

/* Metal wall energy balance */
  M_wall * c_wall * der(T_wall) = Q_dot_hf - Q_dot_cf;
  T_wall = (T_w_2 + T_w_1)/2;

  /* Linear temperature gradient in the wall */
  DELTAT_w = T_w_2 - T_w_1;
  M_wall * c_wall * der(DELTAT_w) = AU_cf*(stateOut_cf.T-stateIn_cf.T - DELTAT_w) + AU_hf*(stateIn_hf.T-T_hf_ex - DELTAT_w);
  //DELTAT_w = (AU_cf*(stateOut_cf.T-stateIn_cf.T) + AU_hf*(stateIn_hf.T-T_hf_ex))/(AU_cf+AU_hf);

  stateOut_cf = Medium1.setState_ph(outlet_cf.p,h_cf_ex);
  stateOut_hf = Medium2.setState_pT(outlet_hf.p,T_hf_ex);

/* BOUNDARY CONDITIONS */

  /*Boundary Conditions Cold Fluid*/
  //inlet_cf.h_outflow=inStream(outlet_cf.h_outflow);
  inlet_cf.h_outflow=1E5;  // Backflow not allowed
  outlet_cf.h_outflow = stateOut_cf.h;
  inlet_cf.m_flow = - outlet_cf.m_flow;
  inlet_cf.p = outlet_cf.p;
  /*Boundary Conditions Hot Fluid*/
  //inlet_hf.T_outflow=inStream(outlet_hf.T_outflow);
  inlet_hf.T_outflow=300;  // Backflow not allowed
  outlet_hf.T_outflow=T_hf_ex;
  inlet_hf.m_flow = - outlet_hf.m_flow;
  inlet_hf.p = outlet_hf.p;

initial equation

  if steadystate_T_wall then
    der(T_wall)=0;
  end if;

  if T_wall_fixed then
    T_w_1 = T_w_1_start;
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-100,42},{-100,24},{100,24},{100,40},{100,70},{80,70},{80,42},
              {80,42},{-100,42}},
          smooth=Smooth.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{100,-44},{100,-26},{-100,-26},{-100,-42},{-100,-72},{-80,-72},
              {-80,-44},{-80,-44},{100,-44}},
          smooth=Smooth.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,14},{100,-16}},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,24},{100,14}},
          fillColor={95,95,95},
          fillPattern=FillPattern.HorizontalCylinder,
          lineThickness=0.5,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-16},{100,-26}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.HorizontalCylinder,
          lineThickness=0.5),
        Line(
          points={{-90,-1},{-48,-1},{-58,7},{-48,-1},{-58,-9},{-58,-9}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-58,7},{-48,-1},{-58,-9},{-58,-7},{-58,7}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,38},{46,32},{54,26},{54,26},{54,38}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{46,32},{74,32},{90,32}},
          color={255,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-46,38},{-54,32},{-46,26},{-46,26},{-46,38}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-54,32},{-26,32},{-10,32}},
          color={255,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{10,-28},{2,-34},{10,-40},{10,-40},{10,-28}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{6,-34},{34,-34},{50,-34}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-90,-34},{-62,-34},{-52,-34}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-90,-34},{-90,-42},{-90,-42}},
          color={255,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{4,6},{-4,0},{4,-6},{4,-6},{4,6}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-90,-46},
          rotation=90),
        Line(
          points={{90,32},{90,48},{90,48}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,-1},{20,-1},{10,7},{20,-1},{10,-9},{10,-9}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{10,7},{20,-1},{10,-9},{10,-7},{10,7}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{42,-1},{84,-1},{74,7},{84,-1},{74,-9},{74,-9}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{74,7},{84,-1},{74,-9},{74,-7},{74,7}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,24},{-100,14},{-100,14}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-100,-16},{-100,-26},{-100,-26}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{100,24},{100,14},{100,14}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{100,-16},{100,-26},{100,-26}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(extent={{-100,-46},{100,-72}}, textString="%name")}),
    Documentation(info="<html>
<p><big> The <b>HX_singlephase_pT </b>model is a non-discretized counter-current heat exchanger
 where both working and secondary fluids are single-phase and are modeled by means of the LMTD method. 
<p><big> The main assumptions for this model are:
  <ul>
<li>The secondary fluid is considered incompressible </li>
<li>Static mass and energy balance in the fluid sides
<li> Energy accumulation is considered in the metal wall
 <li>Linear temperature gradient is assumed in the metal wall</li>
</ul>
 
<p><big> Contrary to a steady-state model, the heat transfer problem is divided in two: 
<ul>
<li>A first heat transfer between the hot fluid and the wall </li>
<li>A second heat transfer between the wall and the cold fluid </li>
</ul>
</p>

<p><big><b>Modeling options</b>
<ul>
<li>Use_AU: allows the user to use a global thermal conductance, assuming constant heat exchange area</li>
</ul>
</html>"),
    uses(Modelica(version="3.2.1")));
end HX_singlephase_pT;
