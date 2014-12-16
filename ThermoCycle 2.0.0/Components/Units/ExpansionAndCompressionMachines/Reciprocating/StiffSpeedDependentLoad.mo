within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model StiffSpeedDependentLoad "High order dependency of load on speed"
  extends Modelica.Mechanics.Rotational.Interfaces.PartialTorque;
  parameter Modelica.SIunits.Power P_nominal(displayUnit="kW") = 1000
    "Nominal load (if positive, load is acting as drive)";
  parameter Boolean LoadDirection=true
    "Same direction of load in both directions of rotation";
  parameter Modelica.SIunits.AngularVelocity w_nominal(displayUnit="rpm",min=Modelica.Constants.eps) = 20
    "Nominal speed";
  parameter Integer order(min=2) = 10 "Order of dependency";
  Modelica.SIunits.AngularVelocity w
    "Angular velocity of flange with respect to support (= der(phi))";
  Modelica.SIunits.Torque tau
    "Accelerating torque acting at flange (= -flange.tau)";
protected
  Modelica.SIunits.Torque tau_nominal
    "Accelerating torque acting at flange (= -flange.tau)";
equation
  w = der(phi);
  tau_nominal = P_nominal / w_nominal;
  tau = -flange.tau;
  if LoadDirection then
    tau = tau_nominal*(w/w_nominal)^order;
  else
    tau = tau_nominal*smooth(1,if w >= 0 then (w/w_nominal)^order else -abs((w/w_nominal)^order));
  end if;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
            graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-100,-100},{-80,-98},{-60,-92},
              {-40,-82},{-20,-68},{0,-50},{20,-28},{40,-2},{60,28},{80,62},
              {100,100}}, color={0,0,255})}),
    Documentation(info="<HTML>
<p>
Model of torque, quadratic dependent on angular velocity of flange.<br>
Parameter TorqueDirection chooses whether direction of torque is the same in both directions of rotation or not.
</p>
</HTML>"));
end StiffSpeedDependentLoad;
