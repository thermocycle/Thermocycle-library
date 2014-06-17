within ThermoCycle.Components.Units.ControlSystems;
model SQThesisController
  // Control unit: all PID used in the control strategy + first value used to start the cycle simulations
  // Control unit inputs for evaporative temperature control
  Modelica.Blocks.Interfaces.RealInput Mdot "Set point signal Evap. Temp."
                                                                annotation (Placement(transformation(extent={{-98,14},
            {-74,38}},                                                                                                    rotation=0),
        iconTransformation(extent={{-100,6},{-86,20}})));
  Modelica.Blocks.Interfaces.RealInput T_hf_su "Present Value of Evap. Temp."
                                                                annotation (Placement(transformation(extent={{-98,40},
            {-74,64}},                                                                                                    rotation=0),
        iconTransformation(extent={{-100,30},{-86,44}})));
  Modelica.Blocks.Interfaces.RealInput p_su_exp
    "Elec. Frequency initial values"                            annotation (Placement(transformation(extent={{-98,-22},
            {-74,2}},                                                                                                    rotation=0),
        iconTransformation(extent={{-100,-42},{-86,-28}})));
  Modelica.Blocks.Interfaces.RealOutput CS_freq
    "Control Signal of the electrical frequency"
                                             annotation (Placement(
        transformation(extent={{92,54},{130,92}}),  iconTransformation(extent={{84,26},
            {104,46}})));
  PID PID_expander(
    PVmax=70,
    PVmin=-70,
    CSmin=16.7,
    CSmax=83.3,
    PVstart=0,
    CSstart=0.5,
    steadyStateInit=true,
    Ti=3,
    Kp=-5)
    annotation (Placement(transformation(extent={{20,62},{46,82}})));
  // Frequency controlling PID parameters
  parameter Real Kp_freq=2
    "Elec. freq.PID Proportional gain (normalised units)";
  parameter Modelica.SIunits.Time Ti_freq "Elec. freq.PID Integral time";
  parameter Modelica.SIunits.Time Td_freq=0 "Elec. freq.PID Derivative time";
  parameter Real Nd_freq = 1
    "Elec. freq.PID Derivative action up to Nd / Td rad/s";
  parameter Real Ni_freq = 1
    "Elec. freq.PID Ni*Ti is the time constant of anti-windup compensation";
  parameter Real b_freq = 1
    "Elec. freq.PID Setpoint weight on proportional action";
  parameter Real c_freq = 0
    "Elec. freq.PID Setpoint weight on derivative action";
  parameter Real PVmin_freq
    "Elec. freq.PID Minimum value of process variable for scaling";
  parameter Real PVmax_freq
    "Elec. freq.PID Maximum value of process variable for scaling";
  parameter Real CSmin_freq
    "Elec. freq.PID Minimum value of control signal for scaling";
  parameter Real CSmax_freq
    "Elec. freq.PID Maximum value of control signal for scaling";
  parameter Real PVstart_freq = 0.5 "Elec. freq.PID Start value of PV (scaled)";
  parameter Real CSstart_freq = 0.5 "Elec. freq.PID Start value of CS (scaled)";
  PID PID_pump(
    PVmin=0,
    PVmax=70,
    CSmin=0.01,
    PVstart=5,
    CSstart=0.55,
    steadyStateInit=true,
    Kp=-0.7,
    Ti=6,
    CSmax=1)
    annotation (Placement(transformation(extent={{20,0},{46,22}})));
  Modelica.Blocks.Interfaces.RealInput T_su_exp "Set point signal Overheating"
                                                                annotation (Placement(transformation(extent={{-98,-52},
            {-74,-28}},                                                                                                   rotation=0),
        iconTransformation(extent={{-100,-18},{-86,-4}})));
  Modelica.Blocks.Interfaces.RealInput p_cd "Present Value of Overheating"
                                                                annotation (Placement(transformation(extent={{-98,68},
            {-74,92}},                                                                                                    rotation=0),
        iconTransformation(extent={{-100,54},{-86,68}})));
  Modelica.Blocks.Interfaces.RealOutput CS_Xpp
    "Control signal of the pump capacity ratio"
                                             annotation (Placement(
        transformation(extent={{92,-10},{130,28}}), iconTransformation(extent={{84,-30},
            {104,-10}})));
  // Pump capacity ratio contrlling PID parameters
  parameter Real Kp_Xpp "Xpp PID Proportional gain (normalised units)";
  parameter Modelica.SIunits.Time Ti_Xpp "Xpp PID Integral time";
  parameter Modelica.SIunits.Time Td_Xpp=0 "Xpp PID Derivative time";
  parameter Real Nd_Xpp = 1 "Xpp PID Derivative action up to Nd / Td rad/s";
  parameter Real Ni_Xpp = 1
    "Xpp PID Ni*Ti is the time constant of anti-windup compensation";
  parameter Real b_Xpp = 1 "Xpp PID Setpoint weight on proportional action";
  parameter Real c_Xpp = 0 "Xpp PID Setpoint weight on derivative action";
  parameter Real PVmin_Xpp
    "Xpp PID Minimum value of process variable for scaling";
  parameter Real PVmax_Xpp
    "Xpp PID Maximum value of process variable for scaling";
  parameter Real CSmin_Xpp
    "Xpp PID Minimum value of control signal for scaling";
  parameter Real CSmax_Xpp
    "Xpp PID Maximum value of control signal for scaling";
  parameter Real PVstart_Xpp = 0.5 "Xpp PID Start value of PV (scaled)";
  parameter Real CSstart_Xpp = 0.5 "Xpp PID Start value of CS (scaled)";
  Modelica.Blocks.Sources.Constant DELTAT_SP(k=10)
    annotation (Placement(transformation(extent={{-52,10},{-40,22}})));
  Modelica.Blocks.Sources.Constant const_pump(k=0.5533)
    annotation (Placement(transformation(extent={{34,-26},{46,-14}})));
  Modelica.Blocks.Sources.Constant const_exp(k=50)
    annotation (Placement(transformation(extent={{34,34},{46,46}})));
  ThermoCycle.Components.Units.ControlSystems.Blocks.DELTAT dELTAT
    annotation (Placement(transformation(extent={{-60,-34},{-40,-14}})));
  ThermoCycle.Components.Units.ControlSystems.Blocks.Tev_SPOptim tev_SP
    annotation (Placement(transformation(extent={{-60,54},{-40,74}})));
  ThermoCycle.Functions.Init init(length=10, t_init=20)
            annotation (Placement(transformation(extent={{-20,-8},{0,12}})));
  ThermoCycle.Functions.Init init1(length=8, t_init=10)
             annotation (Placement(transformation(extent={{-20,54},{0,74}})));
  ThermoCycle.Functions.Init init2(t_init=4, length=3)
            annotation (Placement(transformation(extent={{70,2},{84,16}})));
  ThermoCycle.Functions.Init init3(t_init=6, length=3)
            annotation (Placement(transformation(extent={{70,66},{84,80}})));
equation
  connect(DELTAT_SP.y, PID_pump.SP) annotation (Line(
      points={{-39.4,16},{4.3,16},{4.3,15.4},{20,15.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p_su_exp, dELTAT.P) annotation (Line(
      points={{-86,-10},{-68,-10},{-68,-17.4},{-59.8,-17.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_su_exp, dELTAT.T) annotation (Line(
      points={{-86,-40},{-68,-40},{-68,-28.2},{-60,-28.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(p_cd, tev_SP.p_cd) annotation (Line(
      points={{-86,80},{-74,80},{-74,70.6},{-60,70.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_hf_su, tev_SP.T_hf_su) annotation (Line(
      points={{-86,52},{-74,52},{-74,65.2},{-60,65.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Mdot, tev_SP.Mdot) annotation (Line(
      points={{-86,26},{-68,26},{-68,59.8},{-60,59.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(init1.y, PID_expander.PV) annotation (Line(
      points={{0.8,64.2},{14.4,64.2},{14.4,68},{20,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(init3.y, CS_freq) annotation (Line(
      points={{84.56,73.14},{94.4,73.14},{94.4,73},{111,73}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(init2.y, CS_Xpp) annotation (Line(
      points={{84.56,9.14},{95.4,9.14},{95.4,9},{111,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(init.y, PID_pump.PV) annotation (Line(
      points={{0.8,2.2},{13.4,2.2},{13.4,6.6},{20,6.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dELTAT.DELTAT, init.u2) annotation (Line(
      points={{-39.6,-21},{-28,-21},{-28,6},{-22,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dELTAT.Tsat, init1.u2) annotation (Line(
      points={{-39.6,-25},{-32,-25},{-32,68},{-22,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const_pump.y, init2.u1) annotation (Line(
      points={{46.6,-20},{62,-20},{62,6.34},{68.6,6.34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const_exp.y, init3.u1) annotation (Line(
      points={{46.6,40},{60,40},{60,70.34},{68.6,70.34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tev_SP.Tev, init1.u1) annotation (Line(
      points={{-39.4,65.2},{-36,65.2},{-36,60.2},{-22,60.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DELTAT_SP.y, init.u1) annotation (Line(
      points={{-39.4,16},{-36,16},{-36,-1.8},{-22,-1.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tev_SP.Tev, PID_expander.SP) annotation (Line(
      points={{-39.4,65.2},{-36,65.2},{-36,76},{20,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_expander.CS, init3.u2) annotation (Line(
      points={{46.78,72},{58,72},{58,75.8},{68.6,75.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_pump.CS, init2.u2) annotation (Line(
      points={{46.78,11},{58.39,11},{58.39,11.8},{68.6,11.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-96,74},{88,-54}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-68,50},{56,12}},
          lineColor={255,0,0},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="Control"),          Text(
          extent={{-70,22},{60,-16}},
          lineColor={255,0,0},
          lineThickness=0.5,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="Unit")}));
end SQThesisController;
