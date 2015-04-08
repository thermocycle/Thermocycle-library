within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
model SteamTurbine "Steam turbine"
  replaceable package Medium = ThermoCycle.Media.DummyFluid  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);

/************************* CONNECTORS ****************************/
  Modelica.Blocks.Interfaces.RealInput partialArc
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}},
          rotation=0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft_a
    annotation (Placement(transformation(extent={{-76,-10},{-56,10}},
          rotation=0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft_b
    annotation (Placement(transformation(extent={{54,-10},{74,10}},
          rotation=0)));

  ThermoCycle.Interfaces.Fluid.FlangeA inlet(redeclare package Medium =
        Medium) annotation (Placement(
        transformation(extent={{-80,70},{-60,90}}), iconTransformation(extent={{
            -80,70},{-60,90}})));
  ThermoCycle.Interfaces.Fluid.FlangeB outlet(redeclare package Medium =
        Medium) annotation (Placement(
        transformation(extent={{58,68},{78,88}}), iconTransformation(extent={{58,
            68},{78,88}})));

/************************* INITIALIZATION ****************************/
  parameter Modelica.SIunits.Pressure p_su_start=p_su_nom
    "Inlet pressure start value"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.Pressure p_ex_start=p_ex_nom
    "Outlet pressure start value"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.MassFlowRate M_dot_start=M_dot_nom
    "Mass flow rate start value"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.SpecificEnthalpy h_su_start=Medium.specificEnthalpy_pT(p_su_nom,T_nom)
    "Inlet enthalpy start value"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.SpecificEnthalpy h_ex_start=Medium.specificEnthalpy_pT(p_ex_nom,T_nom)
    "Outlet enthalpy start value"
    annotation(Dialog(tab = "Initialization"));

/************************* PARAMETERS ****************************/
  parameter Real eta_mech=0.98 "Mechanical efficiency";
  parameter Real eta_s_nom=0.92 "Nominal isentropic efficiency";
  parameter Boolean UseNom=false
    "if true, uses Nominal Conditions to compute Kt";
  parameter Modelica.SIunits.Area Kt=1e-4 "Coefficient of Stodola's law"  annotation (Dialog(enable=(not UseNom)));

/************************* NOMINAL CONDITIONS ****************************/
  parameter Modelica.SIunits.MassFlowRate M_dot_nom
    "Nominal inlet mass flow rate"                                                 annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure p_su_nom "Nominal inlet pressure"
                       annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure p_ex_nom "Nominal outlet pressure"
                       annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Temperature T_nom "Nominal inlet temperature"
                          annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Density rho_nom=Medium.density_pT(
          p_su_nom,
          T_nom) "Nominal inlet density"    annotation (Dialog(tab="Nominal Conditions"));

  parameter Boolean use_ideal_gas=false
    "If true, uses the ideal gas law to compute the Stodola expression"                                          annotation (Dialog(tab="General"));

/************************* VARIABLES ****************************/
  Medium.ThermodynamicState steamIn(p(start=p_su_nom),T(start=T_nom),d(start=rho_nom));
  Modelica.SIunits.Angle phi "shaft rotation angle";
  Modelica.SIunits.Torque tau "net torque acting on the turbine";
  Modelica.SIunits.AngularVelocity omega "shaft angular velocity";
  Modelica.SIunits.MassFlowRate M_dot(start=M_dot_start) "Mass flow rate";
  Medium.SpecificEnthalpy h_su(start=h_su_start) "Inlet enthalpy";
  Medium.SpecificEnthalpy h_ex(start=h_ex_start) "Outlet enthalpy";
  Medium.SpecificEnthalpy h_ex_s(start=h_ex_start) "Isentropic outlet enthalpy";
  Medium.AbsolutePressure p_ex(start=p_ex_start) "Outlet pressure";
  Real PR "pressure ratio";
  Real PR_nom "nominal pressure ratio";
  Modelica.SIunits.Power W_dot "Mechanical power input";
  Real eta_s "Isentropic efficiency";
  Modelica.SIunits.Area K(start=Kt) "K coefficient of Stodola's law";
  Real x;
  Real x_nom;
  Real delta=0.001;

equation
  PR=inlet.p/outlet.p "Pressure ratio";
  if cardinality(partialArc)==0 then
    partialArc =1 "Default value if not connected";
  end if;

  h_ex_s=Medium.specificEnthalpy_ps(outlet.p, steamIn.s) "Isentropic enthalpy";

  h_su-h_ex=eta_s*(h_su-h_ex_s) "Computation of outlet enthalpy";
  W_dot=eta_mech*M_dot*(h_su-h_ex) "Mechanical power from the steam";
  W_dot = -tau*omega "Mechanical power balance";

  x_nom = (1 - (1/PR_nom)^2);
  PR_nom = p_su_nom/p_ex_nom;
  x = (1 - (1/PR)^2);
  eta_s = eta_s_nom "Constant isentropic efficiency";

  /* Calculation of the Coefficient of Stodola's equation */
 if not UseNom then
    K = Kt;
  else
    if use_ideal_gas then
      K = M_dot_nom/(partialArc*p_su_nom/sqrt(T_nom)*(x_nom/sqrt(sqrt(x_nom*
        x_nom + delta*delta))));
    else
      K = M_dot_nom/(partialArc*sqrt(p_su_nom*rho_nom)*(x_nom/sqrt(sqrt(x_nom*
        x_nom + delta*delta))));
    end if;
 end if;

  /* Calculation of the inlet massflow mass flow */
  if use_ideal_gas then
    M_dot = partialArc*homotopy(K*steamIn.p/sqrt(steamIn.T)*(x/sqrt(sqrt(x*x + delta*
      delta))), M_dot_nom*steamIn.p/p_su_nom);
  else
    M_dot = partialArc*homotopy(K*sqrt(steamIn.p*steamIn.d)*(x/sqrt(sqrt(x*x + delta*delta))), M_dot_nom*steamIn.p/p_su_nom)
      "Stodola's law";

  end if;

/* BOUNDARY CONDITIONS */
  // Mechanical boundary conditions
  shaft_a.phi = phi;
  shaft_b.phi = phi;
  shaft_a.tau + shaft_b.tau = tau;
  der(phi) = omega;

  // Steam boundary conditions and inlet steam properties
  steamIn = Medium.setState_ph(inlet.p,h_su);
  p_ex=outlet.p;

  inlet.h_outflow=inStream(outlet.h_outflow);
  h_su=inStream(inlet.h_outflow);
  outlet.h_outflow=h_ex;

  inlet.m_flow = M_dot;
  outlet.m_flow = -M_dot "Mass balance";

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                  graphics={
        Polygon(
          points={{-28,76},{-28,28},{-22,28},{-22,82},{-60,82},{-60,76},{
              -28,76}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{26,56},{32,56},{32,76},{60,76},{60,82},{26,82},{26,56}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,8},{60,-8}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={160,160,164}),
        Polygon(
          points={{-28,28},{-28,-26},{32,-60},{32,60},{-28,28}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(extent={{-120,-64},{138,-104}}, textString=
                                                   "%name"),
        Text(
          extent={{-74,-48},{-38,-64}},
          lineColor={0,0,255},
          textString="PartialArc")}),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                    graphics),
    Documentation(info="<html>
<p><big> Model <b>SteamTurbine</b> describe the expansion of a fluid through a turbine which is modeled by Stodola&rsquo;s elliptic law, with a symmetric square root approximation with finite derivative in zero.</p>
The main advantage is that there is still a solution even if p_ex &GT; p_su.</p>
<p><big>The inlet mass flow rate is proportional to the <i>partialArc</i> signal if the corresponding connector is wired. </p>
<p><big><br>The assumptionss for this model are:</p>
<ul>
<li>Constant isentropic efficiency</li>
<li>No dynamics</li>
<li>No thermal energy losses to the environment</li>
</ul>
<h4>Modeling options</h4>
<ul>
<li><i>useNom</i>: if true, uses Nominals Conditions to compute the Stodola's coefficient.</li>
<li><i>use_ideal_gas</i>: If true, uses the ideal gas law to compute the Stodola expression.</li>
</ul>
</html>",
        revisions="<html>
</html>"));
end SteamTurbine;
