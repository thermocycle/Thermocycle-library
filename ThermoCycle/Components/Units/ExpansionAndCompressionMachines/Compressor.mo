within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
model Compressor "Generic volumetric compressor model"
 /****************************************** FLUID ******************************************/
replaceable package Medium =
      ThermoCycle.Media.DummyFluid                                                                      constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
 /*Ports */
public
Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_elc "Flange of shaft"
                      annotation (Placement(transformation(extent={{64,-8},{
            100,28}}, rotation=0), iconTransformation(extent={{68,-12},{92,12}})));
  Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-78,68},{-58,88}}),
        iconTransformation(extent={{-78,68},{-58,88}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{76,-50},{96,-30}}),
        iconTransformation(extent={{76,-50},{96,-30}})));
/****************************************** SELECT TYPE OF EXPANDER ******************************************/
parameter Real epsilon_s=0.7 "Isentropic Efficiency"
    annotation (Dialog(enable=(ExpType == ExpTypes.UD)));

  /****************************************** PARAMETERES ******************************************/
  parameter Real epsilon_v=1 "Volumetric efficiency"
    annotation (Dialog(enable=(ExpType == ExpTypes.UD)));
  parameter Modelica.SIunits.Volume V_s=1e-4 "Swept volume";
  parameter Real epsilon_start=0.5782 "Isentropic Efficiency"
    annotation (Dialog(tab="Initialization"));
  parameter Real epsilon_v_start=1 "Volumetric Efficiency"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure p_su_start=2.339e5
    "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure p_ex_start=1.77175e6
    "Outlet pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_su_start=293.15
    "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pT(p_su_start, T_su_start)
    "Inlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy h_ex_start= Medium.specificEnthalpy_pT(p_ex_start, T_su_start)
    "Outlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
  //parameter Boolean constinit=false
  //  "if true, sets the efficiencies to a constant value at the beginning of the simulation"
 //   annotation (Dialog(group="Initialization options",tab="Initialization"));
 // parameter Modelica.SIunits.Time t_init=10
 //   "if constinit is true, time during which the efficiencies are set to their start values"
//    annotation (Dialog(group="Initialization options",tab="Initialization", enable=constinit));

  /****************************************** VARIABLES ******************************************/
  Medium.ThermodynamicState vaporIn
    "Thermodynamic state of the fluid at the inlet";
  Medium.ThermodynamicState vaporOut
    "Thermodynamic state of the fluid at the outlet - isentropic";
  Real rpm;
  Modelica.SIunits.Frequency N_rot;
  Modelica.SIunits.Power W_dot;
  Modelica.SIunits.VolumeFlowRate V_dot_su;
  Modelica.SIunits.MassFlowRate M_dot;
  Medium.Density rho_su(start=Medium.density_pT(p_su_start,T_su_start));
  Medium.SpecificEntropy s_su;
  Medium.SpecificEnthalpy h_su(start=h_su_start);
  Medium.SpecificEnthalpy h_ex(start=h_ex_start);
  Medium.AbsolutePressure p_su(start=p_su_start);
  Medium.AbsolutePressure p_ex(start=p_ex_start);
  Medium.SpecificEnthalpy h_ex_s;
equation
  /* Fluid Properties */
  vaporIn = Medium.setState_ph(p_su,h_su);
  rho_su = Medium.density(vaporIn);
  s_su = Medium.specificEntropy(vaporIn);
  vaporOut = Medium.setState_ps(p_ex,s_su);
  h_ex_s = Medium.specificEnthalpy(vaporOut);
  /*equations */
  rpm = N_rot*60;
  V_dot_su = epsilon_v*V_s*N_rot;
  V_dot_su = M_dot/rho_su;
  h_ex = h_su + (h_ex_s - h_su)/epsilon_s;
  W_dot = M_dot*(h_ex - h_su) "Consumed Power";

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
          extent={{-62,-56},{80,-84}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          textString="Compressor"),
                              Polygon(
          points={{-60,80},{-60,-60},{80,-40},{80,40},{-60,80}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),Documentation(info="<html>
<p>The <i>Compressor</i> model represents the expansion of a fluid in a volumetric machine. It is a lumped model based on performance curves. It is characterized by two flow connector for the fluid inlet and outlet and by a mechanical connector for the connection with the generator.</p>
<p>The assumptions for this model are:</p>
<p><ul>
<li>No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger).</li>
<li>No thermal energy losses to the environment</li>
<li>Isentropic efficiency based on empirical performance curve</li>
<li>Filling factor based on empirical performance curve</li>
</ul></p>
<p><h4>Modelling options</h4></p>
<p>In this model, the user has the choice of providing constant isentropic and volumetric efficiencies, or providing performance curves for these two variables.</p>
</html>"));
end Compressor;
