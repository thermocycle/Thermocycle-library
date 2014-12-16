within ThermoCycle.Components.HeatFlow.Walls;
model ThermalResistance
  parameter Integer N(min=1)=2 "Number of cells";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U
    "Heat transfer coefficient";
  parameter Modelica.SIunits.Area A "Heat exchange area";
  Modelica.SIunits.Power Qdot[N];
  Modelica.SIunits.Power Qdot_tot;
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort port1(N=N)
    annotation (Placement(transformation(extent={{-40,20},{40,40}})));
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort port2(N=N)
    annotation (Placement(transformation(extent={{-40,-20},{40,0}})));
equation
  for i in 1:N loop
    Qdot[i] = (port1.T[i] - port2.T[i]) * A/N * U;
    Qdot[i] = port1.phi[i] * A/N;
    Qdot[i] = -port2.phi[i] * A/N;
  end for;
  Qdot_tot = sum(Qdot);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p><big> Model <b>ThermalResistance</b> is a discretized thermal resistance between two states.</p>
<p><big> The inputs are the heat exchange surface and the heat transfer coefficient which is considered constant and imposed by the user.</p>
</html>"));
end ThermalResistance;
