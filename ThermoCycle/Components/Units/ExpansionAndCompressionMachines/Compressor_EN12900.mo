within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
model Compressor_EN12900 "Compressor model according to standard EN12900"
 /****************************************** FLUID ******************************************/
replaceable package Medium =
      ThermoCycle.Media.DummyFluid                                                                      constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
 /*Ports */
  Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-78,68},{-58,88}}),
        iconTransformation(extent={{-78,68},{-58,88}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{76,-50},{96,-30}}),
        iconTransformation(extent={{76,-50},{96,-30}})));

  replaceable function CPmodel =
      ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits
    constrainedby ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits
    "Compressor Model - only valid for one particular working fluid!"
    annotation (choicesAllMatching=true);

/****************************************** SELECT TYPE OF EXPANDER ******************************************/

  /****************************************** PARAMETERES ******************************************/

  parameter Modelica.SIunits.Frequency N_rot=50 "Compressor frequency";
  parameter Modelica.SIunits.MassFlowRate M_dot_start=0.02
    "Nominal Mass flow rate"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure p_su_start=2.339e5
    "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure p_ex_start=1.77175e6
    "Outlet pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_su_start=293.15
    "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pT(p_su_start, T_su_start)
    "Inlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy h_ex_start= Medium.specificEnthalpy_pT(p_ex_start, Medium.saturationTemperature(p_ex_start)+50)
    "Outlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));

  /****************************************** VARIABLES ******************************************/
  Medium.ThermodynamicState vaporIn
    "Thermodynamic state of the fluid at the inlet";
  Medium.ThermodynamicState vaporOut
    "Thermodynamic state of the fluid at the outlet - isentropic";
  Real epsilon_s "Isentropic Efficiency";
  Real epsilon_v "Volumetric efficiency";
  Modelica.SIunits.Volume Vs "Swept Volume";
  Real rpm;
  Modelica.SIunits.Power W_dot;
  Modelica.SIunits.VolumeFlowRate V_dot_su;
  Modelica.SIunits.MassFlowRate M_dot(start=M_dot_start);
  Medium.Density rho_su(start=Medium.density_pT(p_su_start,T_su_start));
  Medium.SpecificEntropy s_su;
  Medium.SpecificEnthalpy h_su(start=h_su_start);
  Medium.SpecificEnthalpy h_ex(start=h_ex_start);
  Medium.AbsolutePressure p_su(start=p_su_start);
  Medium.AbsolutePressure p_ex(start=p_ex_start);
  Medium.SpecificEnthalpy h_ex_s;
  Medium.Temperature T_cd(start=Medium.saturationTemperature(p_ex_start));
  Medium.Temperature T_ev(start=Medium.saturationTemperature(p_su_start));
  Real results[3];
equation
  /* Fluid Properties */
  vaporIn = Medium.setState_ph(p_su,h_su);
  rho_su = Medium.density(vaporIn);
  s_su = Medium.specificEntropy(vaporIn);
  vaporOut = Medium.setState_ps(p_ex,s_su);
  h_ex_s = Medium.specificEnthalpy(vaporOut);
  T_cd = Medium.saturationTemperature(p_ex);
  T_ev = Medium.saturationTemperature(p_su);
  results=CPmodel(T_cd,T_ev);
  M_dot = results[1];
  W_dot = results[2];
  Vs = results[3];

  /*equations */
  rpm = N_rot*60;
  V_dot_su = epsilon_v*Vs*N_rot;
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
  InFlow.p = p_su;
  OutFlow.p = p_ex;

  annotation (Diagram(graphics),
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
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
<p>The <b>Compressor_EN12900</b> model represents the compression of a fluid in a scroll compressor according to standard EN12900. It is a lumped model. It is characterized by two flow connector for the fluid inlet and outlet and by a mechanical connector for the connection with the electric driver. </p>
<p>The assumptions for this model are: </p>
<p><ul>
<li>No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger). </li>
<li>No thermal energy losses to the environment </li>
<li>Mass flow and consumed power are calculated with a polynoms as a function of the saturation temperature of the corresponding inlet and outlet temperature </li>
</ul></p>
<p><b>Modelling options</b> </p>
<p>In the <b>General</b> tab the following option is available: </p>
<p><ul>
<li>CPmodel: it allows to select one of the different available scroll compressor characteristics. </li>
<li></li>
</ul></p>
<p><b>Polynomial expression</b></p>
<p>In the EN12900 standard, the compressor consumption and the mass flow rate are expressed as a function of the evaporation and condensation temperatures with the following equations:</p>
<p><img src=\"modelica://ThermoCycle/Resources/Images/EN12900.png\"/></p>
</html>"));
end Compressor_EN12900;
