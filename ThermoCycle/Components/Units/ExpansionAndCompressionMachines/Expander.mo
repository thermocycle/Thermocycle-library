within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
model Expander "Generic expander model"
 /****************************************** FLUID ******************************************/
replaceable package Medium = ThermoCycle.Media.DummyFluid  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
 /*Ports */
public
Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_elc "Flange of shaft"
                      annotation (Placement(transformation(extent={{64,-8},{
            100,28}}, rotation=0), iconTransformation(extent={{68,-2},{92,22}})));
  Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-78,36},{-58,56}}),
        iconTransformation(extent={{-78,36},{-58,56}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
/****************************************** SELECT TYPE OF EXPANDER ******************************************/
  import ThermoCycle.Functions.Enumerations.ExpTypes;
parameter ExpTypes ExpType=ExpTypes.UD;
parameter Real epsilon_s=0.7 "Isentropic Efficiency"
    annotation (Dialog(enable=(ExpType == ExpTypes.UD)));

  /****************************************** PARAMETERES ******************************************/
  parameter Real FF_exp=1 "Filling factor"
    annotation (Dialog(enable=(ExpType == ExpTypes.UD)));
  parameter Modelica.SIunits.Volume V_s "Swept volume";
  parameter Real epsilon_start=0.5782 "Isentropic Efficiency"
    annotation (Dialog(tab="Initialization"));
  parameter Real FF_start=0.00003915 "Filling factor"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure p_su_start=23.39e5
    "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure p_ex_start=1.77175e5
    "Outlet pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_su_start=423.15
    "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pT(p_su_start, T_su_start)
    "Inlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy h_ex_start= Medium.specificEnthalpy_pT(p_ex_start, T_su_start)
    "Outlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
  parameter Boolean constPinit=false
    "if true, sets the evaporating pressure to a constant value at the beginning of the simulation in order to avoid oscillations"
    annotation (Dialog(group="Initialization options",tab="Initialization"));
  parameter Boolean constinit=false
    "if true, sets the efficiencies to a constant value at the beginning of the simulation"
    annotation (Dialog(group="Initialization options",tab="Initialization"));
  parameter Modelica.SIunits.Time t_init=10
    "if constinit is true, time during which the efficiencies are set to their start values"
    annotation (Dialog(group="Initialization options",tab="Initialization", enable=constinit));

  /****************************************** VARIABLES ******************************************/
  Medium.ThermodynamicState steamIn
    "Thermodynamic state of the fluid at the inlet";
  Medium.ThermodynamicState steamOut
    "Thermodynamic state of the fluid at the outlet - isentropic";
  Real epsilon(start=epsilon_start);
  Real FF( start=FF_start);
  Real rpm;
  Modelica.SIunits.Frequency N_rot(start=48.3);
  Modelica.SIunits.Power W_dot;
  Modelica.SIunits.VolumeFlowRate V_dot_su;
  Modelica.SIunits.MassFlowRate M_dot;
  Medium.Density rho_su(start=40);
  Medium.SpecificEntropy s_su;
  Medium.SpecificEnthalpy h_su(start=h_su_start);
  Medium.SpecificEnthalpy h_ex(start=h_ex_start);
  Medium.AbsolutePressure p_su(
    min=1E5,
    max=28E5,
    start=p_su_start);
  Medium.AbsolutePressure p_ex(
    min=1E5,
    max=10E5,
    start=p_ex_start);
  Medium.SpecificEnthalpy h_ex_s;
equation
  /* Fluid Properties */
  steamIn = Medium.setState_ph(p_su,h_su);
  rho_su = Medium.density(steamIn);
  s_su = Medium.specificEntropy(steamIn);
  steamOut = Medium.setState_ps(p_ex,s_su);
  h_ex_s = Medium.specificEnthalpy(steamOut);
  /*equations */
  rpm = N_rot*60;
  V_dot_su = FF*V_s*N_rot;
  V_dot_su = M_dot/rho_su;
  h_ex = h_su - (h_su - h_ex_s)*epsilon;
  W_dot = M_dot*(h_su - h_ex) "Power generated";
if (ExpType == ExpTypes.ODExp) then
    FF = ThermoCycle.Functions.correlation_open_expander_FF(rho=rho_su,
      log_Nrot=log(rpm));
    epsilon = ThermoCycle.Functions.correlation_open_expander_epsilon_s(
          rho=rho_su,
          log_rp=log(p_su/p_ex),
          N_rot=rpm);
elseif (ExpType == ExpTypes.Screw) then
  FF= ThermoCycle.Functions.TestRig.GenericScrewExpander_FillingFactor(
                                                           p_su_exp= p_su,rho_su_exp= rho_su,rpm=N_rot*60);  // V_s has to be set ugual to 1 [m3]
    epsilon = ThermoCycle.Functions.TestRig.GenericScrewExpander_IsentropicEfficiency(
          rp=p_su/p_ex,
          rpm=N_rot*60,
          p=p_su);
elseif (ExpType == ExpTypes.HermExp) then
    FF = ThermoCycle.Functions.correlation_hermetic_scroll_FF(rho=rho_su,
      rp=p_su/p_ex);
    epsilon = ThermoCycle.Functions.correlation_hermetic_scroll_epsilon_s(
      rho=rho_su, rp=p_su/p_ex);
  else
  FF = FF_exp;
  epsilon = epsilon_s;
end if;

   //BOUNDARY CONDITIONS //
   /* Enthalpies */
  h_su = if noEvent(InFlow.m_flow <= 0) then h_ex else inStream(InFlow.h_outflow);
  h_su = InFlow.h_outflow;
  OutFlow.h_outflow = if noEvent(OutFlow.m_flow <= 0) then h_ex else inStream(
    OutFlow.h_outflow);

   /*Mass flows */
   M_dot = InFlow.m_flow;
   OutFlow.m_flow = -M_dot;
   /*pressures */
  //flange.p = vapor_su.p;
  InFlow.p = p_su;
  OutFlow.p = p_ex;
// Mechanical port:
  der(flange_elc.phi) = 2*N_rot*Modelica.Constants.pi;
  flange_elc.tau = W_dot/(2*N_rot*Modelica.Constants.pi)
  annotation (Diagram(graphics));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false,extent={{-120,-120},{120,120}}), graphics={
          Text(
          extent={{-68,-44},{74,-72}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          textString="Expander"),
                              Polygon(
          points={{-60,40},{-60,-20},{80,-60},{80,80},{-60,40}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),Documentation(info="<html>
<p>The Expander model represents the expansion of a fluid in a volumetric machine. It is a lumped model based on performance curves. It is characterized by two flow connector for the fluid inlet and outlet and by a mechanical connector for the connection with the generator. </p>
<p>The assumptions for this model are: </p>
<p><ul>
<li>No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger). </li>
<li>No thermal energy losses to the environment </li>
<li>Isentropic efficiency based on empirical performance curve </li>
<li>Filling factor based on empirical performance curve </li>
</ul></p>
<p><b>Modelling options</b> </p>
<p>In this model, the user has the choice of providing constant isentropic and volumetric efficiencies, or providing performance curves in the form of a Modelica function. The performance curves can be selected from the General tab with the ExpType enumeration variable.</p>
</html>"));
end Expander;
