within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Cells;
model TwoPhase "1-D lumped fluid flow model for two-phase flow"
replaceable package Medium =
  ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

import ThermoCycle.Components.Units.HeatExchangers.MB_HX.Records;
import ThermoCycle.Components.Units.HeatExchangers.MB_HX.Constants;
/************ Thermal and fluid ports ***********/
 ThermoCycle.Interfaces.Fluid.FlangeA inFlow(redeclare final package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB outFlow(redeclare final package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));

  ThermoCycle.Components.Units.HeatExchangers.MB_HX.Interfaces.MbOut mbOut
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

/* Hx Type */
   parameter Boolean Type = true "Evaporator or Condenser" annotation (Dialog(__Dymola_label="Type of heat exchanger:"), choices(choice=true
        "Evaporator",                                                                                    choice=false
        "Condenser",                                                                                                   __Dymola_radioButtons=true));
 final parameter Integer ev = if Type then Constants.ON else Constants.OFF;
 final parameter Integer cd = if Type then Constants.OFF else Constants.ON;

/************ Geometric characteristics **************/
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Modelica.SIunits.Area AA "Channel cross section";
  parameter Modelica.SIunits.Length YY "Channel perimeter";
  parameter Real Ltotal = 40 "Hx total length";

  parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
  parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));

  parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone " annotation (Dialog(group = "Heat transfer"));

  final parameter Integer nXi = Medium.nXi "mass fraction";
 /************ FLUID INITIAL VALUES ***************/
  parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Length lstart=1 "Start value of length"
    annotation (Dialog(tab="Initialization"));

parameter Boolean alone = true annotation (choices(checkBox=true),Dialog( group="CV",__Dymola_label="Only 1CV?:"));

parameter Boolean Flooded = true "Set to true if Flooded - false if Dry" annotation (Dialog(group = "CV"));
parameter Boolean General = false "Set to true if complete evaporator"
                                                                      annotation (Dialog(group = "CV"));

/***************  VARIABLES ******************/
 /* Summary Class variables */
 Modelica.SIunits.Temperature[3] Temp "Fluid temperature for SummaryClass";
 Modelica.SIunits.Length[3] length "Length vector for summaryClass";

  Modelica.SIunits.Length ll(start=lstart,min= Modelica.Constants.small);
  Modelica.SIunits.Length la;
  Modelica.SIunits.Length lb;
  Modelica.SIunits.Velocity dldt;
  Modelica.SIunits.Area SS "Lateral area of the cylinder";

  Modelica.SIunits.MassFlowRate M_dot_a(start=Mdotnom);
  Modelica.SIunits.MassFlowRate M_dot_b(start=Mdotnom);
  Modelica.SIunits.MassFlowRate dMdt(start=0)
    "Change in mass in control volume";

  Modelica.SIunits.HeatFlowRate dUdt(start=0)
    "Change in energy in control volume";
   Modelica.SIunits.HeatFlowRate H_dot_a(start=Mdotnom*hstart)
    "Enthalpy flow at inlet";
  Modelica.SIunits.HeatFlowRate H_dot_b(start=Mdotnom*hstart)
    "Enthalpy flow at outlet";

  Medium.SaturationProperties sat =  Medium.setSat_p(pp) "Saturation";

  Medium.AbsolutePressure pp(start=pstart);
  Medium.AbsolutePressure p_a(start=pstart) "Fluid pressure at inlet";
  Medium.AbsolutePressure p_b(start=pstart) "Fluid pressure at outlet";

  Medium.SpecificEnthalpy hh(start=hstart) "Fluid enthalpy, mean";
  Medium.SpecificEnthalpy h_a(start=hstart) "Fluid enthalpy at inlet";
  Medium.SpecificEnthalpy h_b(start=hstart) "Fluid enthalpy at outlet";
  Medium.SpecificEnthalpy h_l "Fluid enthalpy, saturated liquid";
  Medium.SpecificEnthalpy h_v "Fluid enthalpy, saturated vapour";

  Modelica.SIunits.Temperature Text "Temperature from the connection element";
  Medium.Temperature TT "Fluid temperature";
  Modelica.SIunits.Temperature T_a "Fluid temperature at inlet";
  Modelica.SIunits.Temperature T_b "Fluid temperature at outlet";

 // Medium.Density rho "Fluid density, mean";
  Medium.Density rho_a "Fluid density at inlet";
  Medium.Density rho_b "Fluid density at outlet";
  Medium.Density rho_l "Fluid density, saturated liquid";
  Medium.Density rho_v "Fluid density, saturated vapour";

 Modelica.SIunits.MassFraction[nXi] Xia "Inlet mass fraction";
 Modelica.SIunits.MassFraction[nXi] Xib "Outlet mass fraction";

/* Derivative of fluid properties */
  Modelica.SIunits.DerEnthalpyByPressure dhdp_l "TP:SatLiq  - h deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure dhdp_v "TP:SatVap - h deriv wrt p";
  Modelica.SIunits.DerDensityByPressure drdp_l "TP: SatLiq  - D deriv wrt p ";
  Modelica.SIunits.DerDensityByPressure drdp_v "TP: SatVap  - D deriv wrt p";
  Real dhdt_a "Inlet state - h deriv wrt time";
  Real dhdt_b "outlet state - h deriv wrt time";

  /* Heat transfer values */
  Real AU "AU value";
  Real q_dot;
  final parameter Real C_dot = 4000 "Dummy Cdot for the connector";

 Real VV "Void fraction";
 Real dVVdt "Void fraction derivative wrt time";
 Real dVVdp "Void fraction derivative wrt pressure";
 Real dVVdha "Void fraction derivative wrt enthalpy at the inlet";
 Real dVVdhb "Void fraction derivative wrt enthalpy at the outlet";
 Real Gamma_a "function a";
 Real Gamma_b "function b";
 Real GG "FUNCTION GG";
 Real Dh_ab "Differential";
 Real Dh_lv "Differential";
 Real Dr_lv "Differential";
 Real Theta_a "Function Theta_a";
 Real Theta_b "Function Theta_b";
 Real Dh_ab_lv "Differential";

  // CV Mode
  Records.Mode mode;
  Integer ka = mode.ka;
  Integer kb = mode.kb;
  //Integer Inlet;
  //Integer Outlet;
protected
  parameter Integer FL = if Flooded then Constants.ON else Constants.OFF;
  parameter Integer DR = if Flooded then Constants.OFF else Constants.ON;
  parameter Integer GR = if General then Constants.ON else Constants.OFF;
equation
  /*Equation to close the system */
  if alone then
  la = 0;
  mode = Constants.ModeBasic;
  lb = Ltotal;
end if;

  lb   = ll + la;

/* Inlet thermodynamic properties */
 T_a =Medium.temperature_ph(p_a,h_a);
 rho_a = Medium.density_ph(p_a,h_a);

/* Outlet thermodynamic properties */
 T_b = Medium.temperature_ph(p_b,h_b);
 rho_b = Medium.density_ph(p_b,h_b);

  /* Mean Thermodinamic properties */
  hh = 1/2*(h_a + h_b);
  pp = 1/2*(p_a + p_b);

  /* Fluid Properties */
  TT = Medium.saturationTemperature_sat(sat);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  rho_v =  Medium.dewDensity(sat);
  rho_l = Medium.bubbleDensity(sat);
  dhdp_l = Medium.dBubbleEnthalpy_dPressure(sat);
  dhdp_v = Medium.dDewEnthalpy_dPressure(sat);
  drdp_l = Medium.dBubbleDensity_dPressure(sat);
  drdp_v = Medium.dDewDensity_dPressure(sat);
  dldt   = der(ll);
  p_a = p_b;

/* MASS BALANCE */

dMdt = AA*(der(ll)*(VV*rho_v + (1-VV)*rho_l) + ll*(dVVdt*(rho_v - rho_l)+VV*drdp_v*der(pp) + (1-VV)*drdp_l*der(pp)))
+ rho_a*AA*der(la) - rho_b*AA*der(lb);

dMdt = M_dot_a - M_dot_b;

/* ENERGY BALANCE */
dUdt = AA*(der(ll)*(VV*rho_v*h_v + (1-VV)*rho_l*h_l) + ll*(dVVdt*(rho_v*h_v - rho_l*h_l)+VV*drdp_v*der(pp)*h_v
+VV*rho_v*dhdp_v*der(pp) +(1-VV)*drdp_l*der(pp)*h_l +(1-VV)*rho_l*dhdp_l*der(pp))) - AA*ll*der(pp) +AA*rho_a*h_a*der(la) -
AA*rho_b*h_b*der(lb);

dUdt = H_dot_a - H_dot_b + q_dot;

/* Void fraction */
if VoidFraction then
Dh_ab = h_a - h_b;
Dh_lv = h_l - h_v;
Dr_lv = rho_l - rho_v;
    Gamma_a = Functions.Gamma(
      hh=h_a,
      rho_l=rho_l,
      rho_v=rho_v,
      h_l=h_l,
      h_v=h_v);
    Gamma_b = Functions.Gamma(
      hh=h_b,
      rho_l=rho_l,
      rho_v=rho_v,
      h_l=h_l,
      h_v=h_v);
GG = Gamma_a/Gamma_b;
    Theta_a = Functions.Theta(
      hh=h_a,
      h_l=h_l,
      drdp_l=drdp_l,
      rho_l=rho_l,
      dhdp_l=dhdp_l,
      h_v=h_v,
      drdp_v=drdp_v,
      rho_v=rho_v,
      dhdp_v=dhdp_v);
    Theta_b = Functions.Theta(
      hh=h_b,
      h_l=h_l,
      drdp_l=drdp_l,
      rho_l=rho_l,
      dhdp_l=dhdp_l,
      h_v=h_v,
      drdp_v=drdp_v,
      rho_v=rho_v,
      dhdp_v=dhdp_v);
Dh_ab_lv = - Dh_ab + Dh_lv*log(GG);

/* Void fraction */
VV = max(Modelica.Constants.small,(rho_l^2*(h_a - h_b) +rho_l*rho_v*(h_b - h_a + (h_l -h_v)*log(GG)))/((h_a - h_b)*(rho_l - rho_v)^2));

/* Void fraction derivative wrt time */
dVVdt = dVVdp*der(pp) +dVVdha*dhdt_a+ dVVdhb*dhdt_b;
else
 /* Dummy values */
 Dh_ab = 1;
 Dh_lv = 1;
 Dr_lv = 1;
 Gamma_a = 1;
 Gamma_b = 1;
 GG = 1;
 Theta_a = 1;
 Theta_b = 1;
 Dh_ab_lv = 1;
 /*Void fraction derivative to zero*/
 dVVdt = 0;
 /* Constant void fraction*/
 VV = VoidF;
end if;

if alone then
  dhdt_a = der(h_a);
  dhdt_b = der(h_b);
elseif not alone and ev ==1 then
  if FL ==1 and GR ==0 then
    dhdt_a = dhdp_l*der(pp);
    dhdt_b = der(h_b);
  elseif FL ==0 and GR ==0 then
    dhdt_a = der(h_a);
    dhdt_b =dhdp_v*der(pp);
  else
    dhdt_a = dhdp_l*der(pp);
    dhdt_b =dhdp_v*der(pp);
  end if;
elseif not alone and cd ==1 then
  if FL ==1 and GR ==0 then
    dhdt_a= der(h_a);
    dhdt_b = dhdp_l*der(pp);
  elseif FL ==0 and GR ==0 then
    dhdt_a = dhdp_v*der(pp);
    dhdt_b = der(h_b);
    else
    dhdt_a = dhdp_l*der(pp);
    dhdt_b =dhdp_v*der(pp);
  end if;
else
  dhdt_a = dhdp_l*der(pp);
    dhdt_b =dhdp_v*der(pp);
end if;

/* Void fraction derivative wrt p */
dVVdp = drdp_l/(Dh_ab*Dr_lv^2)*(Dh_ab*rho_l + rho_v*Dh_ab_lv) -
 2*rho_l*(drdp_l -drdp_v)/(Dh_ab*Dr_lv^3)*(Dh_ab*rho_l + Dh_ab_lv*rho_v) +
rho_l/(Dh_ab*Dh_lv^2)*( Dh_ab*drdp_l +drdp_v*Dh_ab_lv +
rho_v*((dhdp_l -dhdp_v)*log(GG) +Dh_lv/Gamma_a*(Theta_a - GG*Theta_b)));

/* Void fraction derivative wrt h_a */
dVVdha = - rho_l/(Dh_ab^2*Dr_lv^2)*(Dh_ab*rho_l +rho_v*Dh_ab_lv) +
rho_l/(Dh_ab*Dr_lv^2)*(rho_l + rho_v*(-1 + Dh_lv*Dr_lv/Gamma_a));

/* Void fraction derivative wrt h_b */
dVVdhb = +rho_l/(Dh_ab^2*Dr_lv^2)*(Dh_ab*rho_l +rho_v*Dh_ab_lv) +
rho_l/(Dh_ab*Dr_lv^2)*(-rho_l +rho_v*(1 - Dh_lv*Dr_lv/Gamma_b));

/* Energy boundaries */
H_dot_a = M_dot_a*h_a;
H_dot_b = M_dot_b*h_b;

 /* Heat transfer */
  AU = YY*Ltotal*Unom;
  SS = YY*ll;
  q_dot = SS*Unom*(Text - TT);

q_dot = mbOut.Q_flow;
Text = mbOut.T;
mbOut.ll = ll;
mbOut.Cdot = C_dot;
/* Boundaries and connectors */
    h_a = inStream(inFlow.h_outflow);
    h_a = inFlow.h_outflow;
    h_b = outFlow.h_outflow;
    p_a = inFlow.p;
    p_b = outFlow.p;

  /* Mass and substance flows, no composition changes */
  M_dot_a = inFlow.m_flow;
  M_dot_b = -outFlow.m_flow;
  inFlow.Xi_outflow  = inStream(outFlow.Xi_outflow);
  outFlow.Xi_outflow = inStream(inFlow.Xi_outflow);
  inFlow.C_outflow  = inStream(outFlow.C_outflow);
  outFlow.C_outflow = inStream(inFlow.C_outflow);
/* Define Temp and length values for summaryClass */
  Temp[1] = T_a;
  Temp[2] = TT;
  Temp[3] = T_b;
  length[1] = la;
  length[2] = (la+lb)/2;
  length[3] = lb;
public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
     Modelica.SIunits.Temperature[3] T_cell;
     Modelica.SIunits.Length[3] l_cell;
     end Arrays;
     Modelica.SIunits.Power Q_flow;
  end SummaryClass;
  SummaryClass Summary(T_profile(T_cell = Temp[:],l_cell = length[:]),Q_flow= q_dot);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
                   Rectangle(
          extent={{-100,48},{100,-32}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          fillColor={175,255,200}),       Text(
          extent={{-80,32},{80,-8}},
          lineColor={0,0,0},
          textString="2Phase")}),Documentation(info="<HTML>
          
          <p><big>Model <b>TwoPhase</b> describes the flow of a fluid in <b>two phase</b> through a channel of variable length.
          When the model is simulated alone the length is fixed to the total length of the channel.
          <p><big><b>Pressure</b> and <b>enthalpy</b> are selected as state variables. 
       <p><big>The assumptions for this model are reported in the annotation of the <a href=\"modelica://ThermoCycle.Components.Units.HeatExchangers.MB_HX\">MB_HX package</a>

<p><big>The model is characterized by two flow connectors and one special lumped thermal port connector which considered as an output the length of the zone.

<p><big> The rate of mass change for the two-phase flow is defined as:
<p>
<img src=\"modelica://ThermoCycle/Resources/Images/MB/MassRate_TP.png\">
</p> 

<p><big> The rate of energy change for the two-phase flow is defined as:
<p>
<img src=\"modelica://ThermoCycle/Resources/Images/MB/EnergyRate_TP.png\">
</p> 

<p><big> where la and lb represents the inlet and the outlet zone of the channel, and &#8169; is the average void fraction defined as
<p><big> the integral of the void fraction over the enthalpy change of the zone divided by the enthalpy change:

<p>
<img src=\"modelica://ThermoCycle/Resources/Images/MB/VoidFraction_MB.png\">
</p> 


<p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following options are availabe:
        <ul><li>Medium: the user has the possibility to easly switch Medium.
        <li> Only1CV: Set to true if the model is simulated alone - to false if connected to a TwoPhase model.
        <li> Flooded: if true the fluid is cell works for a flooded evaporator - to false the cell works for a dry evaporator.
        <li> General: if true the cell works for a general evaporator - to false cell trend depends on the Flooded parameter value.</ul> 
          </HTML>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end TwoPhase;
