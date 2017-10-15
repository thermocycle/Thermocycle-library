within ThermoCycle.Components.Units.PdropAndValves;
model DP "Lumped, 3-terms pressure drop model"
  extends ThermoCycle.Icons.Water.PressDrop;

  /*********** PORTS ****************/
  Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  replaceable package Medium = ThermoCycle.Media.DummyFluid  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Boolean UseNom=false
    "Use Nominal conditions to compute pressure drop characteristics";
  parameter Modelica.SIunits.Length h=0 "Static fluid head (dp = h * rho * g)"  annotation (Dialog(enable=(not UseNom)));
  parameter Real k=0 "Coefficient for linear pressure drop (dp = k * V_dot)" annotation (Dialog(enable=(not UseNom)));
  parameter Modelica.SIunits.Area A=10e-5
    "Valve throat area for quadratic pressure drop (dp = 1/A²*M_dot²/(2*rho)) - Set 5e3 to put it to zero"
                                                                                 annotation (Dialog(enable=(not UseNom)));
  Modelica.SIunits.Length h_ok;
  Real k_ok;
  Modelica.SIunits.Area A_ok;
  parameter Modelica.SIunits.Pressure DELTAp_0=500
    "Pressure drop below which a 3rd order interpolation is used for the computation of the flow rate in order to avoid infinite derivative at 0";
  parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.1 "Nominal mass flow rate"
                             annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure"
                       annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Temperature T_nom=423.15 "Nominal temperature"
                          annotation (Dialog(tab="Nominal Conditions"));
//   parameter Modelica.SIunits.Density rho_nom=Medium.density_pTX(
//           p_nom,
//           T_nom,fill(0,0)) "Nominal density"    annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Density rho_nom=Medium.density(Medium.setState_pT(
          p_nom,T_nom)) "Nominal density"    annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_stat_nom=0
    "Nominal static pressure drop"
                           annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_lin_nom=0
    "Nominal linear pressure drop"
                           annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_quad_nom=0
    "Nominal quadratic pressure drop"                                                      annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_start=DELTAp_stat_nom + DELTAp_lin_nom + DELTAp_quad_nom
    "Start Value for the pressure drop"                                                         annotation (Dialog(tab="Initialization"));
  parameter Boolean   use_rho_nom=false
    "Use the nominal density for the computation of the pressure drop (i.e it depends only on the flow rate)"
                           annotation (Dialog(tab="Nominal Conditions"));
  // Fluid variables
  //Medium.ThermodynamicState fluidstate;
  Modelica.SIunits.Density d_fl(start=rho_nom);
  Medium.Density rho(start=rho_nom);
  Modelica.SIunits.Pressure p_fl;
  Medium.SpecificEnthalpy h_fl;
  Modelica.SIunits.Pressure DELTAp(start=DELTAp_start);
  Modelica.SIunits.Pressure DELTAp_quad(start=DELTAp_quad_nom)
    "Quadratic pressure drop";
  Modelica.SIunits.Pressure DELTAp_lin(start=DELTAp_lin_nom)
    "Linear pressure drop";
  Modelica.SIunits.Pressure DELTAp_stat(start=DELTAp_stat_nom)
    "Static pressure drop";
  Modelica.SIunits.MassFlowRate Mdot(start=Mdot_nom);
  Modelica.SIunits.Time t_change=5
    "time during which the transition of the weighting factor function happens";
  Modelica.SIunits.MassFlowRate Mdot_0 "Nominal mass flow rate";

  /***************************** Initialization options ********************************************/

  parameter Modelica.SIunits.Time t_init=10
    "if constinit is true, time during which the pressure drop is set to the constant value DELTAp_start"
    annotation (Dialog(tab="Initialization", enable=constinit));
  parameter Boolean constinit=false
    "if true, sets the pressure drop to a constant value at the beginning of the simulation in order to avoid oscillations"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean UseHomotopy=false
    "if true, uses homotopy to set the pressure drop to zero in the first initialization"
  annotation (Dialog(tab="Initialization"));

equation
  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";
  p_fl = InFlow.p;
  h_fl = smooth(1,if Mdot >= 0 then OutFlow.h_outflow else InFlow.h_outflow);
  d_fl = Medium.density_phX(p_fl,h_fl,fill(0,0));
  DELTAp = InFlow.p - OutFlow.p;
  Mdot_0 = A_ok*sqrt(2*rho_nom)*sqrt(DELTAp_0);
if not UseNom then
  k_ok = k;
  A_ok = A;
  h_ok = h;
else
  k_ok = DELTAp_lin_nom/Mdot_nom * rho_nom;
  DELTAp_stat = DELTAp_stat_nom;   //In this case the pressure head is considered constant
  A_ok = abs(Mdot_nom)/sqrt(max(abs(DELTAp_quad_nom),50) * 2 * rho_nom);
end if;
if use_rho_nom then
  rho = rho_nom;
else
  rho = d_fl;
end if;
  if constinit then
    if UseHomotopy then
      DELTAp = homotopy(DELTAp_start + (DELTAp_quad + DELTAp_lin +
        DELTAp_stat - DELTAp_start)*ThermoCycle.Functions.weightingfactor(
            t_init=t_init,
            length=t_change,
            t=time), DELTAp_start);
    else
      DELTAp = DELTAp_start + (DELTAp_quad + DELTAp_lin + DELTAp_stat -
        DELTAp_start)*ThermoCycle.Functions.weightingfactor(
            t_init=t_init,
            length=t_change,
            t=time);
    end if;
  else
    if UseHomotopy then
      DELTAp = homotopy(DELTAp_quad + DELTAp_lin + DELTAp_stat,DELTAp_start);
    else
      DELTAp = DELTAp_quad + DELTAp_lin + DELTAp_stat;
    end if;
  end if;
//Different possibilities to calculate the quadratic pressure drop:
// Explicit in deltap:
//    Mdot = A_ok*sqrt(2*rho)*smooth(1, noEvent(if (DELTAp_quad > DELTAp_0) then sqrt(
//      DELTAp_quad) else if (DELTAp_quad < -DELTAp_0) then -sqrt(-DELTAp_quad)
//       else sqrt(DELTAp_0)*(DELTAp_quad/DELTAp_0)/4*(5 - (DELTAp_quad/DELTAp_0)^2)));
//Mdot = A_ok*sqrt(2*rho)*sqrt(DELTAp_quad);
//Mdot = A_ok * Modelica.Fluid.Utilities.regRoot2(DELTAp_quad,DELTAp_0,2*rho,2*rho,use_yd0=false,yd0=0.0);
//Mdot = A_ok * sqrt(2*rho) * Modelica.Fluid.Utilities.regRoot(DELTAp_quad,10);
// Explicit in Mdot:
//DELTAp_quad = 1/A_ok^2 /(2*rho) * smooth(1, noEvent(if (Mdot > Mdot_0) then Mdot^2 else if (Mdot < -Mdot_0) then -Mdot^2 else 1/(2*Mdot_0) * Mdot^3 + Mdot_0/2*Mdot));
//DELTAp_quad = 1/A_ok^2 /(2*rho) * smooth(1, if (Mdot > Mdot_0) then Mdot^2 else if (Mdot < -Mdot_0) then -Mdot^2 else 1/(2*Mdot_0) * Mdot^3 + Mdot_0/2*Mdot);
//DELTAp_quad = 1/A_ok^2 * Mdot^2/(2*rho);
//DELTAp_quad = Modelica.Fluid.Utilities.regSquare2(Mdot,Mdot_0,1/A_ok^2 /(2*rho),1/A_ok^2 /(2*rho),use_yd0=false,yd0=0.0);
DELTAp_quad = if noEvent(A_ok >= 5000) then 0 else 1/A_ok^2 /(2*rho)*Modelica.Fluid.Utilities.regSquare(Mdot,1e-4);

// Linear pressure drop:
  DELTAp_lin = k_ok*Mdot/rho;
// Static pressure difference:
  DELTAp_stat = h_ok*rho*Modelica.Constants.g_n;
// Boundary conditions
  Mdot = InFlow.m_flow;
  InFlow.h_outflow = inStream(OutFlow.h_outflow);
  inStream(InFlow.h_outflow) = OutFlow.h_outflow;
  //DELTAp = 38453.9*Mdot + 23282.7*Mdot^2;
initial equation

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{-100,-40},{100,-74}}, textString=
              "%name"), Line(
          points={{-66,0},{58,0},{42,10},{58,0},{42,-10}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<html>
<p>The <b>DP</b> model is a lumped model that computes a punctual pressure drop. </p>
<p>The assumptions for this model are: </p>
<p><ul>
<li>Incompressible fluid for computing the pressure drop </li>
<li>No thermal energy losses to the ambient </li>
</ul></p>
<p><br/>The total pressure drop is computed as the sum of three different terms: a constant pressure difference (e.g. due to the static pressure head), a linear pressure drop (e.g. due to friction in a laminar flow) and a quadratic pressure drop (typical of turbulent flow):</p>
<p><img src=\"modelica://ThermoCycle/Resources/Images/DELTAp.png\"/></p>
<p><b>Modelling options</b> </p>
<p>In the <b>General</b> tab the following options are available: </p>
<p><ul>
<li>Medium: the user has the possibility to easly switch Medium. </li>
<li>UseNom: If true, use the nominal conditions defined in the Nominal Conditions tab to compute the pressure drop characteristic (i.e. the parameters h, K and A)</li>
</ul></p>
<p>In the <b>Nominal condition</b> tab the following option is available: </p>
<p><ul>
<li>use_rho_nom: If true, the density is considered constant during the whole simulation and equal to the nominal value. </li>
</ul></p>
<p>In the <b>Initialization</b> tab the following options are available: </p>
<p><ul>
<li>constinit: If true, the pressure drop is considered constant at the beginning of the simulation to avoid oscillations. </li>
<li>UseHomotopy: If true, the homotopy function is used to set the pressure drop to zero in the first initialization. </li>
</ul></p>
<p><br/>The parameter DELTAp_0 defines a limitation of the pressure drop below which the quadratic expression is replaced by a third order polynomial expression to avoid the non-physical infinite derivative at DELTAp=0.</p>
</html>",
        uses(Modelica(version="3.2"))));
end DP;
