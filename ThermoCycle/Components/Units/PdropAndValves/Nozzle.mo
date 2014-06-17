within ThermoCycle.Components.Units.PdropAndValves;
model Nozzle
  "Model of a variable throat-area nozzle operating in subsonic or supersonic conditions."
  replaceable package Medium = ThermoCycle.Media.R245fa_CP constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (
      choicesAllMatching=true);
  Medium.ThermodynamicState inlet;
  Medium.ThermodynamicState inlet_start;
  Medium.ThermodynamicState throat_start;
  Medium.ThermodynamicState throat;
  Medium.ThermodynamicState throat_choked;
  parameter Modelica.SIunits.Area Afull=5e-7
    "Cross-sectional area of the fully open valve";
  Modelica.SIunits.Area A(start=Afull) "Valve throat area";
  parameter Real Xopen(
    min=0,
    max=1) = 1
    "Opening if no external command is connected (0=fully closed; 1=fully open)";
  parameter Boolean Compute_ChokedFlow=true
    "The computation of the choked conditions at the throat can be disabled if the nozzle always operate in subsonic conditions";
  parameter Boolean Use_gamma=false
    "Use a fictitious gamma (perfect gas model) to compute the critical pressure (not valid in liquid or two-phase!)"
                                                                                  annotation(Dialog(enable=Compute_ChokedFlow));

  parameter Medium.AbsolutePressure P_su_start=17E5
    "Start value for the inlet pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature T_su_start=273.15 + 150
    "Start value for the inlet pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure P_ex_start=2E5
    "Start value for the inlet pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Real gamma_start=1.05
    "Start value of the fictitious expansion factor, used to compute the start value of the critical pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure p_choked_start=P_su_start*(2/(
      gamma_start + 1))^(gamma_start/(gamma_start - 1))
    "Critical throat pressure start value"
    annotation (Dialog(tab="Initialization"));
  Medium.AbsolutePressure DELTAp_0=0.05e5
    "Minimum pressure drop below which a linear flow dependency is assumed";
  Medium.AbsolutePressure p_thr(start=P_ex_start,
      stateSelect=StateSelect.prefer);
  Medium.AbsolutePressure p_su(start=P_su_start);
  Medium.SpecificEntropy s_su;
  Medium.AbsolutePressure p_choked(start=p_choked_start);
  Modelica.SIunits.VolumeFlowRate V_dot_leak;
  Modelica.SIunits.Velocity C_thr(start=Medium.velocityOfSound(
      Medium.setState_pT(p_choked_start, T_su_start)));
  Modelica.SIunits.MassFlowRate Mdot_thr;
  Modelica.SIunits.MassFlowRate Mdot_choked;

  Real gamma "Equivalent isentropic expansion factor";

  ThermoCycle.Interfaces.Fluid.FlangeA su(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-112,-8},{-92,12}})));
  ThermoCycle.Interfaces.Fluid.FlangeB ex(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-8},{110,12}})));
  Modelica.Blocks.Interfaces.RealInput cmd annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,62}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={64,22})));
equation
  //Starting conditions:
  inlet_start = Medium.setState_pT(P_su_start, T_su_start);
  throat_start = Medium.setState_ps(p_choked_start, inlet_start.s);

  // Inlet conditions
  inlet = Medium.setState_ph(su.p, inStream(su.h_outflow));
  p_su = su.p;
  s_su = inlet.s;

  if cardinality(cmd) == 0 then
    cmd = Xopen;
  end if;
  A = Afull*cmd;

  //Subsonic Flow:
  throat = Medium.setState_ps(p_thr, s_su);
  // Energy balance: inlet.h = throat.h + 0.5*C_thr^2;
  C_thr = sqrt(max(1e-20, 2*(inlet.h - throat.h)));
  V_dot_leak = A*C_thr;

  // Outlet conditions (p_ex is bounded to avoid the case of a flow reversal):
  if ex.p < p_su - DELTAp_0 then
    p_thr = ex.p;
    Mdot_thr = V_dot_leak*throat.d;
  else
    p_thr = p_su - DELTAp_0;
    Mdot_thr = V_dot_leak*throat.d*max(0, p_su - ex.p)/DELTAp_0;
  end if;

  //Supersonic Flow:
  if Compute_ChokedFlow then
    //Identification of a fictitious gamma value that allows modeling the isentropic expansion as a perfect gas using the equation:
    //     inlet.p/inlet.d^gamma = throat.p/throat.d^gamma;
    gamma = log(inlet_start.p/throat_start.p)/log(inlet_start.d/throat_start.d);
    if Use_gamma then
      p_choked = inlet.p*(2/(gamma + 1))^(gamma/(gamma - 1));
      throat_choked = Medium.setState_ps(p_choked, s_su);
    else
      throat_choked.a = sqrt(max(1e-20, 2*(inlet.h - throat_choked.h)));
      throat_choked = Medium.setState_ps(p_choked, s_su);
    end if;
    Mdot_choked = throat_choked.d*throat_choked.a*A;
  else
    // Set dummy values:
    p_choked = 1e-20;
    throat_choked = Medium.setState_dT(20, 273.15 + 100);
    Mdot_choked = 1E20;
    gamma = 0;
  end if;

  // Mass flows, selecting between subsonic and supersonic
  su.m_flow + ex.m_flow = 0;
  su.m_flow = (if p_choked > p_thr then Mdot_choked else Mdot_thr);

  // The valve is isenthalpic in both directions:
  //su.h_outflow = inStream(ex.h_outflow);
  su.h_outflow = 6E5;
  ex.h_outflow = inStream(su.h_outflow);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-92,84},{90,-74}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-84,32},{-48,30},{0,8},{70,6},{82,6}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,0},{-24,0},{32,0},{70,0},{82,0}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,48},{-36,48},{22,14},{78,10}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-84,-32},{-48,-30},{0,-8},{70,-6},{82,-6}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,-48},{-36,-48},{22,-14},{78,-10}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Text(extent={{-100,-50},{100,-84}}, textString="%name")}));
end Nozzle;
