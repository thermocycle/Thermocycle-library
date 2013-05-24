within ThermoCycle.Components.Units.ControlSystems;
model PID "ISA PID controller with anti-windup"
  parameter Real Kp "Proportional gain (normalised units)";
  parameter Modelica.SIunits.Time Ti "Integral time";
  parameter Modelica.SIunits.Time Td=0 "Derivative time";
  parameter Real Nd=1 "Derivative action up to Nd / Td rad/s";
  parameter Real Ni=1 "Ni*Ti is the time constant of anti-windup compensation";
  parameter Real b=1 "Setpoint weight on proportional action";
  parameter Real c=0 "Setpoint weight on derivative action";
  parameter Real PVmin "Minimum value of process variable for scaling";
  parameter Real PVmax "Maximum value of process variable for scaling";
  parameter Real CSmin "Minimum value of control signal for scaling";
  parameter Real CSmax "Maximum value of control signal for scaling";
  parameter Real PVstart=0.5 "Start value of PV (scaled)";
  parameter Real CSstart=0.5 "Start value of CS (scaled)";
  parameter Boolean steadyStateInit=false;
  Real P "Proportional action / Kp";
  Real I(start=CSstart/Kp) "Integral action / Kp";
  Real D "Derivative action / Kp";
  Real Dx(start=c*PVstart - PVstart) "State of approximated derivator";
  Real PVs "Process variable scaled in per unit";
  Real SPs "Setpoint variable scaled in per unit";
  Real CSs(start=CSstart) "Control signal scaled in per unit";
  Real CSbs(start=CSstart)
    "Control signal scaled in per unit before saturation";
  Real track "Tracking signal for anti-windup integral action";
  Modelica.Blocks.Interfaces.RealInput PV "Process variable signal"
    annotation (Placement(transformation(extent={{-112,-52},{-88,-28}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput CS "Control signal" annotation (
      Placement(transformation(extent={{94,-12},{118,12}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput SP "Set point signal" annotation (
      Placement(transformation(extent={{-112,28},{-88,52}}, rotation=0)));
equation
  // Scaling
  SPs = (SP - PVmin)/(PVmax - PVmin);
  PVs = (PV - PVmin)/(PVmax - PVmin);
  CS = CSmin + CSs*(CSmax - CSmin);
  // Controller actions
  P = b*SPs - PVs;
  if Ti > 0 then
    Ti*der(I) = SPs - PVs + track;
  else
    I = 0;
  end if;
  if Td > 0 then
    Td/Nd*der(Dx) + Dx = c*SPs - PVs "State equation of approximated derivator";
    D = Nd*((c*SPs - PVs) - Dx) "Output equation of approximated derivator";
  else
    Dx = 0;
    D = 0;
  end if;
  CSbs = Kp*(P + I + D) "Control signal before saturation";
  CSs = smooth(0, if CSbs > 1 then 1 else if CSbs < 0 then 0 else CSbs)
    "Saturated control signal";
  track = (CSs - CSbs)/(Kp*Ni);
initial equation
  if steadyStateInit then
    if Ti > 0 then
      der(I) = 0;
    end if;
    if Td > 0 then
      D = 0;
    end if;
  end if;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,40},{52,-34}},
          lineColor={0,0,0},
          textString="PID"),
        Text(
          extent={{-110,-108},{110,-142}},
          lineColor={0,0,255},
          lineThickness=0.5,
          textString="%name")}),
    Documentation(revisions="<html>
<ul>
<li><i>10 Dec 2008</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
end PID;
