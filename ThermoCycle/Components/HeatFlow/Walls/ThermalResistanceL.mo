within ThermoCycle.Components.HeatFlow.Walls;
model ThermalResistanceL
  //parameter Integer N(min=1)=2 "Number of nodes";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U
    "Heat transfer coefficient";
  parameter Modelica.SIunits.Area A "Heat exchange area";
  Modelica.SIunits.Power Qdot;

  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL port1
    annotation (Placement(transformation(extent={{-40,20},{40,40}})));
  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL port2
    annotation (Placement(transformation(extent={{-40,-20},{40,0}})));
equation
  Qdot = (port1.T - port2.T) * A * U;
  Qdot = port1.phi * A;
  Qdot = -port2.phi * A;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(extent={{-60,60},{60,-40}}, lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>The ThermalResistanceL model is a non-discretized thermal resistance between two states.</p>
<p>The inputs are the heat exchange surface and the heat transfer coefficient.</p>
</html>"));
end ThermalResistanceL;
