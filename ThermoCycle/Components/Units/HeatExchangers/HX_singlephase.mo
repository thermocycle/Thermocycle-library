within ThermoCycle.Components.Units.HeatExchangers;
model HX_singlephase
  "HX singlephase model compatible with MSL - countercurrent configuration only"
  replaceable package MediumPs =ThermoCycle.Media.DummyFluid  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid primary side" annotation (Dialog(group= "Primary side", tab="General"),choicesAllMatching=true);
  replaceable package MediumSs =ThermoCycle.Media.DummyFluid  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid secondary side" annotation (Dialog(group= "Secondary side", tab="General"),choicesAllMatching=true);

protected
   record SummaryClass
   replaceable Arrays T_profile;
      record Arrays
      Modelica.SIunits.Temperature[2] T_ps;
      Modelica.SIunits.Temperature[2] T_ss;
      end Arrays;
    //Modelica.SIunits.SpecificEnthalpy[2] h_ps;
    //Modelica.SIunits.SpecificEnthalpy[2] h_ss;
    Modelica.SIunits.Power Q_ps;
    Modelica.SIunits.Power Q_ss;
    Modelica.SIunits.Pressure p_ps;
    Modelica.SIunits.Pressure p_ss;
   end SummaryClass;
public
 SummaryClass Summary( T_profile(T_ps= {T_primary[1],T_primary[2]}, T_ss = {T_secondary[1],T_secondary[2]}),  p_ps = stateIn_ps.p, p_ss = stateIn_ss.p, Q_ps = Q_dot_ps, Q_ss = Q_dot_ss);

protected
  Modelica.SIunits.Temperature[2] T_primary;
  Modelica.SIunits.Temperature[2] T_secondary;
  //
  /******************************* PARAMETERS *****************************/
  /*Metal Wall*/
public
  parameter Modelica.SIunits.Mass M_wall= 69 "Mass of the Wall";
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 500
    "Specific heat capacity of the metal wall";

  parameter Modelica.SIunits.Mass M_ps = 300 "Mass of the fluid"
                        annotation (Dialog(group="Primary side", tab="General"));
  parameter Modelica.SIunits.MassFlowRate MdotNom_ps = 1
    "Nominal mass flow rate" annotation (Dialog(group="Primary side", tab="General"));

  parameter Modelica.SIunits.Mass M_ss = 300 "Mass of the fluid"
                        annotation (Dialog(group="Secondary side", tab="General"));
  parameter Modelica.SIunits.MassFlowRate MdotNom_ss = 1
    "Nominal mass flow rate" annotation (Dialog(group="Secondary side", tab="General"));

  /****************** Heat Transfer parameter  ******************/
  parameter Boolean Use_AU=false "if true, uses the global thermal conductance"
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.Area A_ps=0.03 "Heat transfer area primary side" annotation (Dialog(group="Heat transfer", tab="General", enable=(not Use_AU)));
  parameter Modelica.SIunits.Area A_ss=0.03 "Heat transfer area secondary side"
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General", enable=(not Use_AU)));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_ps
    "Constant heat transfer coefficient primary side" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_ss
    "Constant heat transfer coefficient secondary Side" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.ThermalConductance AU_global=27240
    "Global Thermal conductance"                                                    annotation (Dialog(group="Heat transfer", tab="General", enable=(Use_AU)));

    /****************** START VALUES ******************/
  parameter Modelica.SIunits.AbsolutePressure p_ps_start=50E5
    "Initial pressure" annotation (Dialog( group="Primary side",tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_ps_su_start=394.95
    "Initial value of inlet temperature"                                                    annotation (Dialog(group="Primary side",tab="Initialization"));
    parameter Modelica.SIunits.Temperature T_ps_ex_start=516.25
    "Initial value of outlet temperature"                                                    annotation (Dialog(group="Primary side",tab="Initialization"));

  parameter Modelica.SIunits.AbsolutePressure p_ss_start=50E5
    "Initial pressure" annotation (Dialog(group="Secondary side",tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_ss_su_start=599.15
    "Initial value of inlet temperature"                                                    annotation (Dialog(group="Secondary side",tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_ss_ex_start=443.35
    "Initial value of outlet temperature"                                                    annotation (Dialog(group="Secondary side",tab="Initialization"));

  parameter Modelica.SIunits.Temperature T_w_1_start=(T_ps_su_start+T_ss_ex_start)/2
    "Initial value of wall temperature at T_ps_su and T_ss_ex"                                                  annotation (Dialog(group="Metal wall",tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_w_2_start=(T_ps_ex_start+T_ss_su_start)/2
    "Initial value of wall temperature at T_ps_ex and T_ss_su"                                                  annotation (Dialog(group="Metal wall",tab="Initialization"));
  parameter Boolean steadystate_T_wall=false
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Metal wall", tab="Initialization"));
  parameter Boolean T_wall_fixed=false
    "if true, imposes the initial wall temperature"                                    annotation (Dialog(group="Metal wall", tab="Initialization"));

  parameter Boolean Cp_constant=false
    "if true, sets the fluid specific heat capacity, Cp, on the two side of the HX to a constant value computed with inital conditions";

  /******************************* VARIABLES *****************************/
  Modelica.SIunits.Area A(start=A_ps);
  Modelica.SIunits.Power Q_dot_ps;
  Modelica.SIunits.Power Q_dot_ss;
  Modelica.SIunits.SpecificEnthalpy h_ps_ex(start= MediumPs.specificEnthalpy_pTX(p_ps_start,T_ps_ex_start,fill(0,0)));
  Modelica.SIunits.SpecificEnthalpy h_ss_ex(start= MediumSs.specificEnthalpy_pTX(p_ss_start,T_ss_ex_start,fill(0,0)));
  Modelica.SIunits.Temperature T_wall(start=(T_w_1_start+T_w_2_start)/2);
  Modelica.SIunits.Temperature T_w_1(start=T_w_1_start);
  Modelica.SIunits.Temperature T_w_2(start=T_w_2_start);
  Modelica.SIunits.Temperature DELTAT_w(start=T_w_2_start - T_w_1_start);
  Modelica.SIunits.ThermodynamicTemperature LMTD_ps(displayUnit="K");
  Modelica.SIunits.ThermodynamicTemperature LMTD_ss(displayUnit="K");
  Modelica.SIunits.ThermodynamicTemperature pinch_ps(displayUnit="K",min=1);
  Modelica.SIunits.ThermodynamicTemperature pinch_ss(displayUnit="K",min=1);
  Modelica.SIunits.ThermalConductance AU_ps;
  Modelica.SIunits.ThermalConductance AU_ss;

  MediumPs.SpecificHeatCapacity Cp_ps;
  MediumSs.SpecificHeatCapacity Cp_ss;

  MediumPs.ThermodynamicState stateIn_ps;
  MediumPs.ThermodynamicState stateOut_ps;
  MediumSs.ThermodynamicState stateIn_ss;
  MediumSs.ThermodynamicState stateOut_ss;

/******************************* CONNECTORS *****************************/
  ThermoCycle.Interfaces.Fluid.FlangeA InFlowPs(redeclare package Medium =
        MediumPs)
    annotation (Placement(transformation(extent={{-120,-12},{-100,8}}),
        iconTransformation(extent={{-120,-12},{-100,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlowPs(redeclare package Medium =
        MediumPs)
    annotation (Placement(transformation(extent={{100,-12},{120,8}}),
        iconTransformation(extent={{100,-12},{120,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlowSs(redeclare package Medium =
        MediumSs)
    annotation (Placement(transformation(extent={{80,60},{100,80}}),
        iconTransformation(extent={{80,62},{100,82}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlowSs(redeclare package Medium =
        MediumSs)
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}}),
        iconTransformation(extent={{-100,-84},{-80,-64}})));

equation
  /* Define state of the fluid */
  stateIn_ps = MediumPs.setState_ph(InFlowPs.p,inStream(InFlowPs.h_outflow));
  stateIn_ss = MediumSs.setState_ph(InFlowSs.p,inStream(InFlowSs.h_outflow));
  stateOut_ps = MediumPs.setState_ph(OutFlowPs.p,h_ps_ex);
  stateOut_ss = MediumSs.setState_ph(OutFlowSs.p,h_ss_ex);

   if not Use_AU then
    AU_ps = A_ps * U_ps;
    AU_ss = A_ss * U_ss;
    A = (A_ps+A_ss)/2 "dummy";
  else
    AU_global = 1 / (1/AU_ps + 1/AU_ss);
    AU_ps = A * U_ps;
    AU_ss = A * U_ss;
  end if;

  if not Cp_constant then
    Cp_ps = MediumPs.specificHeatCapacityCp(stateIn_ps);
    Cp_ss = MediumSs.specificHeatCapacityCp(stateIn_ss);
  else
    Cp_ps = MediumPs.specificHeatCapacityCp(MediumPs.setState_pTX(InFlowPs.p,(T_ps_su_start+T_ps_ex_start)/2,fill(0,0)));
    Cp_ss = MediumSs.specificHeatCapacityCp(MediumSs.setState_pTX(InFlowSs.p,(T_ss_su_start+T_ss_ex_start)/2,fill(0,0)));
  end if;

  /*Solve heat tranfser problem with LMTD method*/
  Q_dot_ps = AU_ps * LMTD_ps;
  Q_dot_ss = AU_ss * LMTD_ss;

  /* Heat transfer calculation between the primary side and the wall */
    LMTD_ps = homotopy(ThermoCycle.Functions.RLMTD(T_w_1 - stateIn_ps.T, T_w_2 -
    stateOut_ps.T), max(0, pinch_ps));

  /* Heat transfer calculation between the secondary side and the wall */
    LMTD_ss = homotopy(ThermoCycle.Functions.RLMTD(stateOut_ss.T - T_w_1, stateIn_ss.T - T_w_2),
    max(0, pinch_ss));

  pinch_ps = min(T_w_1-stateIn_ps.T,T_w_2-stateOut_ps.T);
  pinch_ss = min(stateOut_ss.T-T_w_1,stateIn_ss.T-T_w_2);

  Q_dot_ps = max(MdotNom_ps/100,InFlowPs.m_flow) * (h_ps_ex - MediumPs.specificEnthalpy(stateIn_ps));
  Q_dot_ss = max(MdotNom_ss/100,InFlowSs.m_flow) * (MediumSs.specificEnthalpy(stateIn_ss) - h_ss_ex);

   /* Metal wall energy balance */
  ((M_wall * c_wall)+ (M_ps * Cp_ps) + (M_ss * Cp_ss))  * der(T_wall) = Q_dot_ss - Q_dot_ps;
  T_wall = (T_w_2 + T_w_1)/2;

  /* Linear temperature gradient in the wall */
  DELTAT_w = max((T_w_2 - T_w_1),0);
  (M_wall * c_wall)  * der(DELTAT_w) = AU_ps*(stateOut_ps.T-stateIn_ps.T - DELTAT_w) + AU_ss*(stateIn_ss.T-stateOut_ss.T - DELTAT_w);

/* BOUNDARY CONDITIONS */

  /*Boundary Conditions Cold Fluid*/
  InFlowPs.h_outflow=1E5;  // Backflow not allowed
  OutFlowPs.h_outflow = h_ps_ex;
  InFlowPs.m_flow = - OutFlowPs.m_flow;
  InFlowPs.p = OutFlowPs.p;

  /*Boundary Conditions Hot Fluid*/
  InFlowSs.h_outflow=1E5;  // Backflow not allowed
  OutFlowSs.h_outflow= h_ss_ex;
  InFlowSs.m_flow = - OutFlowSs.m_flow;
  InFlowSs.p = OutFlowSs.p;
  /* Equation for Summary */
  T_primary[1] = stateIn_ps.T;
  T_primary[2] = stateOut_ps.T;

  T_secondary[1] = stateIn_ss.T;
  T_secondary[2] = stateOut_ss.T;

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
    <p><big> The <b>HX_singlephase </b> is a lumped counter-current heat exchanger model.
<p><big> The main assumptions for this model are:
  <ul>
  <li> Static mass, energy and momentum balances are assumed in the primary and secondary fluids sides.</li>
  <li> Dynamic energy balance is considered in the metal wall.</li>
  <li> Linear temperature gradient is assumed in the metal wall.</li>
</ul>
 
<p><big> Contrary to a steady-state model, the heat transfer problem is divided in two: 
<ul>
<li>A first heat transfer between the hot fluid and the wall </li>
<li>A second heat transfer between the wall and the cold fluid </li>
<li> The heat transfer problem between the two fluid sides and the metal wall is solved with the <a href=\"modelica://ThermoCycle.Functions.RLMTD\">RLMTD</a> method.</li>
</ul>
</p>

<p><big><b>Modeling options</b>
<ul>
<li>Use_AU: allows the user to use a global thermal conductance, assuming constant heat exchange area</li>
</ul>
</html>"));
end HX_singlephase;
